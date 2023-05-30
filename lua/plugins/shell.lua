local function nullls_opt(_, opts)
	local nls = require("null-ls")
	for i, source in ipairs(opts.sources) do
		if source.name == "shfmt" then
			opts.sources[i] = nls.builtins.formatting.shfmt.with({
				command = require("config.directories") .. "/shfmt/bin/shfmt",
			})
		end
	end
end

return {
	{ "jose-elias-alvarez/null-ls.nvim", opts = nullls_opt },
}
