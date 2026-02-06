-- nvim-ts-autotag: Auto-close and auto-rename HTML/JSX tags

return {
	"windwp/nvim-ts-autotag",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("nvim-ts-autotag").setup({
			-- Filetypes to enable auto-tag
			filetypes = {
				"html",
				"htmldjango",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"xml",
				"vue",
				"svelte",
			},

			-- Skip auto-tag for these tags
			skip_tags = {
				"area",
				"base",
				"br",
				"col",
				"command",
				"embed",
				"hr",
				"img",
				"slot",
				"input",
				"keygen",
				"link",
				"meta",
				"param",
				"source",
				"track",
				"wbr",
				"menuitem",
			},
		})
	end,
}
