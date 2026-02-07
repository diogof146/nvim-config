-- Taplo: TOML language server

return {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { "*.toml", ".git" },

	settings = {
		evenBetterToml = {
			-- Schema associations
			schema = {
				enabled = true,
				associations = {
					["pyproject\\.toml"] = "https://json.schemastore.org/pyproject.json",
					["Cargo\\.toml"] = "https://json.schemastore.org/cargo.json",
				},
			},

			-- Formatting
			formatter = {
				alignEntries = false,
				alignComments = true,
				arrayTrailingComma = true,
				arrayAutoExpand = true,
				arrayAutoCollapse = true,
				compactArrays = true,
				compactInlineTables = false,
				columnWidth = 80,
				indentTables = false,
				indentEntries = false,
				trailingNewline = true,
				reorderKeys = false,
			},
		},
	},
}
