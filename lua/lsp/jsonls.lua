-- vscode-json-language-server: JSON LSP
-- Provides: schema validation, completions, formatting for JSON files

return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },

	init_options = {
		provideFormatter = true,
	},

	settings = {
		json = {
			-- Schema associations
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
				{
					fileMatch = { ".eslintrc", ".eslintrc.json" },
					url = "https://json.schemastore.org/eslintrc.json",
				},
			},

			-- Validation
			validate = { enable = true },

			-- Formatting
			format = { enable = true },
		},
	},
}
