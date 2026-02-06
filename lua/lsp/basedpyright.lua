-- basedpyright: Community fork of Pyright with better features

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },

	settings = {
		basedpyright = {
			analysis = {
				-- Automatically detect Python import paths
				autoSearchPaths = true,

				-- Analyze entire workspace instead of just open files
				diagnosticMode = "openFilesOnly",

				-- Use library source code for better type inference
				useLibraryCodeForTypes = true,

				-- Type checking strictness: "off", "basic", or "strict"
				typeCheckingMode = "basic",

				-- Customize severity of specific type issues
				diagnosticSeverityOverrides = {
					reportGeneralTypeIssues = "error",
					reportOptionalMemberAccess = "warning",
				},
			},
		},
	},
}
