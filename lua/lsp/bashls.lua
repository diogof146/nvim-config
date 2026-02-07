-- bash-language-server: Bash/shell script LSP

return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git" },

	settings = {
		bashIde = {
			-- Use shellcheck for linting
			shellcheckPath = "shellcheck",

			-- Glob pattern for finding shell scripts
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},
}
