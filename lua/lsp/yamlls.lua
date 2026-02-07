-- yaml-language-server: YAML LSP
-- Provides: schema validation, completions for YAML (k8s, docker-compose, GitHub Actions, etc.)

return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },

	settings = {
		yaml = {
			-- Schema associations
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
				["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
			},

			-- Validation
			validate = true,

			-- Formatting
			format = {
				enable = true,
				singleQuote = false,
				bracketSpacing = true,
			},

			-- Hover documentation
			hover = true,
			completion = true,

			-- Custom tags (for special YAML features)
			customTags = {},
		},
	},
}
