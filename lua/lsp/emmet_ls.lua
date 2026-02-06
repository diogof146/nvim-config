-- Emmet Language Server
-- Provides: HTML/CSS abbreviation expansion (e.g., div.container>ul>li*5)

return {
	cmd = { "emmet-ls", "--stdio" },
	filetypes = {
		"html",
		"htmldjango",
		"css",
		"sass",
		"scss",
		"less",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_markers = { ".git" },

	settings = {
		emmet = {
			-- Enable Emmet in JSX/TSX files by treating them as React
			includeLanguages = {
				javascript = "javascriptreact",
				typescript = "typescriptreact",
				vue = "html",
				svelte = "html",
			},
		},
	},
}
