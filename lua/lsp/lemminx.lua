-- LemMinX: XML language server (by Red Hat)

return {
	cmd = { "lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_markers = { ".git" },

	settings = {
		xml = {
			-- Enable file associations
			fileAssociations = {},

			-- Catalog configuration for XML schemas
			catalogs = {},

			-- Formatting options
			format = {
				enabled = true,
				splitAttributes = false,
				joinCDATALines = false,
				joinContentLines = false,
				joinCommentLines = false,
				preserveEmptyContent = false,
				preservedNewlines = 2,
				maxLineWidth = 120,
			},

			-- Validation settings
			validation = {
				enabled = true,
				namespaces = {
					enabled = "always",
				},
			},
		},
	},
}
