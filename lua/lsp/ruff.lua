-- Ruff: Python linter and formatter
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".git" },

	init_options = {
		settings = {
			lint = {
				args = { "--line-length=500" },
			},
			format = {
				args = { "--line-length=500" },
			},
		},
	},
}
