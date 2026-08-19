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

local function resolve_target()
  local cwd = maki.uv.cwd()
  if not cwd then
    return nil, "could not determine the working directory"
  end

  local root, root_err = run("git rev-parse --show-toplevel", cwd)
  if not root then
    return nil, "not a Git repository: " .. root_err
  end

  local branch, branch_err = run("git branch --show-current", root)
  if not branch then
    return nil, "could not determine the current branch: " .. branch_err
  end
  if branch == "" then
    return nil, "cannot review a detached HEAD"
  end

  local base = "main"
  if maki.fn.executable("gh") == 1 then
    local output = run("gh pr view --json baseRefName --jq .baseRefName", root)
    if output and output ~= "" then
      base = output
    end
  end

  local valid_base, valid_err = run(
    "git check-ref-format " .. shell_quote("refs/heads/" .. base),
    root
  )
  if not valid_base then
    return nil, "invalid base branch reported for review: " .. valid_err
  end

  maki.ui.flash("Fetching origin/" .. base .. "...")
  local refspec = "refs/heads/" .. base .. ":refs/remotes/origin/" .. base
  local _, fetch_err = run("git fetch --quiet origin " .. shell_quote(refspec), root, 120000)
  if fetch_err then
    return nil, "could not fetch origin/" .. base .. ": " .. fetch_err
  end

  local base_ref = "origin/" .. base
  local merge_base, merge_err = run(
    "git merge-base HEAD " .. shell_quote(base_ref),
    root
  )
  if not merge_base then
    return nil, "could not find a merge base with " .. base_ref .. ": " .. merge_err
  end

  local status, status_err = run("git status --porcelain", root)
  if not status then
    return nil, "could not inspect the working tree: " .. status_err
  end

  return {
    root = root,
    branch = branch,
    base = base,
    base_ref = base_ref,
    merge_base = merge_base,
    dirty = status ~= "",
  }, nil
end

local function build_prompt(target)
  local worktree_context = "The working tree is clean."
  if target.dirty then
    worktree_context = "The working tree has uncommitted changes. They are outside this review; review only committed changes in the branch diff."
  end

  return string.format([[Review the current branch as a pull request.

## Review target

- Repository: `%s`
- Current branch: `%s`
- Base branch: `%s`
- Base ref: `%s`
- Merge base: `%s`
- Worktree: %s

Inspect the committed branch changes with `git diff %s...HEAD`. Read surrounding code and project instructions as needed to verify impact. Do not modify files or implement fixes during this review.

Flag only discrete, actionable defects introduced by the diff that the author would likely fix. Prioritize correctness and regressions, security and trust boundaries, data loss, concurrency and lifecycle problems, broken API or compatibility contracts, and error handling that masks failures. Report missing tests only when they leave significant changed behavior unverified.

Do not report pure style preferences, speculative risks without a concrete affected path, intentional behavior apparent from the change, or pre-existing issues unless the changed code directly exposes them.

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

List only applicable migrations, dependency or lockfile changes, auth or permission changes, backwards-incompatible contracts, destructive operations, feature flag changes, or configuration-default changes. Write `- (none)` if none apply.]],
    target.root,
    target.branch,
    target.base,
    target.base_ref,
    target.merge_base,
    worktree_context,
    target.merge_base
  )
end

maki.api.register_command({
  name = "/code-review",
  description = "Review the current branch against its pull request base",
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

    maki.ui.flash("Review " .. state .. " against " .. target.base_ref)
  end,
})
