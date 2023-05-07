local function project_config()
	local cwd = vim.cmd.pwd()
	if cwd == nil or cwd == "" then
		cwd = "./"
	end
	cwd = vim.fs.normalize(cwd)
	local candidates = { cwd .. "/.nvim.lua", cwd .. "/.nvim/init.lua", cwd .. "/.local/nvim.lua" }
	for _, candidate in ipairs(candidates) do
		if candidate ~= nil then
			candidate = vim.fs.normalize(candidate)
			local canopen = io.open(candidate, "r")
			if canopen ~= nil then
				io.close(canopen)
				return candidate
			end
		end
	end
end
local project = project_config()
if project ~= nil then
	return dofile(project)
end

return {}
