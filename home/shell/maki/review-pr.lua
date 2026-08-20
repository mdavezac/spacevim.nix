local ListPicker = require("maki.list_picker")

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function run(command, cwd, timeout_ms)
  local job_id = maki.fn.jobstart(command, { cwd = cwd })
  local result = maki.fn.jobwait(job_id, timeout_ms or 30000)
  if not result then
    maki.fn.jobstop(job_id)
    return nil, "command timed out: " .. command
  end
  if result.exit_code ~= 0 then
    local message = result.stderr:gsub("%s+$", "")
    if message == "" then
      message = result.stdout:gsub("%s+$", "")
    end
    return nil, message ~= "" and message or "command failed: " .. command
  end
  return result.stdout:gsub("%s+$", ""), nil
end

local function split_lines(text)
  local lines = {}
  for line in (text .. "\n"):gmatch("(.-)\n") do
    if line ~= "" then
      lines[#lines + 1] = line
    end
  end
  return lines
end

local function unmanaged_files(status)
  local files = {}
  for _, line in ipairs(split_lines(status)) do
    if line:sub(1, 3) == "?? " then
      files[#files + 1] = line:sub(4)
    end
  end
  return files
end

local function choose_unmanaged_files(files)
  if #files == 0 then
    return {}, nil
  end

  local items = {
    { label = "Include unmanaged files", detail = table.concat(files, ", ") },
    { label = "Exclude unmanaged files", detail = table.concat(files, ", ") },
  }
  local choice = ListPicker.open(items, {
    title = "Unmanaged files found",
    footer = { { "Enter", "select" }, { "Esc", "cancel" } },
  })

  if choice.type ~= "choice" then
    return nil, "review cancelled"
  end
  if choice.index == 1 then
    return files, nil
  end
  return {}, nil
end

local function issue_commits(root)
  local history, history_err = run("git log --format='%H%x09%s'", root)
  if not history then
    return nil, "could not inspect Git history: " .. history_err
  end

  local commits = {}
  for _, line in ipairs(split_lines(history)) do
    local sha, subject = line:match("^(%S+)%s+(.+)$")
    local issue = subject and subject:match("^%[C%-(%d+)%]")
    commits[#commits + 1] = {
      sha = sha,
      subject = subject,
      issue = issue and "C-" .. issue or nil,
    }
  end

  local latest = commits[1]
  if not latest then
    return nil, "Git history is empty"
  end
  for _, commit in ipairs(commits) do
    if not commit.issue then
      return nil, "commit does not start with [C-XYZ]: " .. commit.sha:sub(1, 12) .. " " .. commit.subject
    end
  end

  local selected = {}
  for _, commit in ipairs(commits) do
    if commit.issue ~= latest.issue then
      break
    end
    selected[#selected + 1] = commit
  end

  if #selected == 0 then
    return nil, "no commits found for " .. latest.issue
  end

  local oldest = selected[#selected]
  local parent, parent_err = run("git rev-parse " .. shell_quote(oldest.sha .. "^"), root)
  if not parent then
    return nil, "could not determine the review range: " .. parent_err
  end

  return {
    issue = latest.issue,
    commits = selected,
    parent = parent,
    head = selected[1].sha,
  }, nil
end

local function resolve_target()
  local cwd = maki.uv.cwd()
  if not cwd then
    return nil, "could not determine the working directory"
  end

  local root, root_err = run("git rev-parse --show-toplevel", cwd)
  if not root then
    return nil, "not a Git repository: " .. root_err
  end

  local status, status_err = run("git status --porcelain=v1 --untracked-files=all", root)
  if not status then
    return nil, "could not inspect the working tree: " .. status_err
  end

  local unmanaged, unmanaged_err = choose_unmanaged_files(unmanaged_files(status))
  if not unmanaged then
    return nil, unmanaged_err
  end

  local history, history_err = issue_commits(root)
  if not history then
    return nil, history_err
  end

  return {
    root = root,
    issue = history.issue,
    commits = history.commits,
    parent = history.parent,
    head = history.head,
    unmanaged = unmanaged,
  }, nil
end

local function build_prompt(target)
  local commit_lines = {}
  for _, commit in ipairs(target.commits) do
    commit_lines[#commit_lines + 1] = string.format("- `%s` %s", commit.sha:sub(1, 12), commit.subject)
  end

  local unmanaged_context = "No unmanaged files are included."
  if #target.unmanaged > 0 then
    unmanaged_context = "The following unmanaged files are included in the review. Read them directly; they are not represented in the Git diff:\n"
      .. table.concat(target.unmanaged, "\n")
  end

  return string.format([[
        Review the current checkout as a code review for Linear issue `%s`.

        ## Review scope

        - Repository: `%s`
        - Commits included: `%d`
        - Diff range: `git diff %s..%s`

        %s

        Commits included, newest first:
        %s

        Review only the changes introduced by the listed commits. Read surrounding code and project
        instructions as needed to verify impact. Do not modify files or implement fixes during this
        review. Review the local commits only. Do not fetch from the remote.

        Flag only discrete, actionable defects introduced by these commits that the author would likely fix.
        Prioritize correctness and regressions, security and trust boundaries, data loss, concurrency and
        lifecycle problems, broken API or compatibility contracts, and error handling that masks failures.
        Report missing tests only when they leave significant changed behavior unverified.

        Do not report pure style preferences, speculative risks without a concrete affected path,
          intentional behavior apparent from the change, or pre-existing issues.

        For each finding:

        - Prefix the title with `[P0]`, `[P1]`, `[P2]`, or `[P3]`.
        - Include the shortest useful `path:line` location overlapping the diff.
        - Explain the concrete triggering scenario and impact.
        - Keep the explanation concise and actionable.

        List every qualifying finding. If there are none, explicitly state that the change looks correct.

        Finish with these sections:

        ## Verdict

        Write exactly `correct` when there are no blocking findings, otherwise `needs attention`.

        ## Human Reviewer Callouts (Non-Blocking)

        List only applicable migrations, dependency or lockfile changes, auth or permission changes,
        backwards-incompatible contracts, destructive operations, feature flag changes, or
        configuration-default changes. Write `- (none)` if none apply.
    ]],
    target.issue,
    target.root,
    #target.commits,
    target.parent,
    target.head,
    unmanaged_context,
    table.concat(commit_lines, "\n")
  )
end

maki.api.register_command({
  name = "/code-review",
  description = "Review the latest Linear issue's commits in the current checkout",
  nargs = 0,
  handler = function()
    local target, err = resolve_target()
    if not target then
      maki.ui.flash("Review failed: " .. err)
      return
    end

    local state, prompt_err = maki.session.prompt(build_prompt(target))
    if not state then
      maki.ui.flash("Could not start review: " .. prompt_err)
      return
    end

    maki.ui.flash("Review " .. target.issue .. " started")
  end,
})
