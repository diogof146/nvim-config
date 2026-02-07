-- nvim-ts-autotag: Auto-close and auto-rename HTML/JSX tags

return {
	"windwp/nvim-ts-autotag",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("nvim-ts-autotag").setup({
			-- Options
			opts = {
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Don't auto-close on trailing </
			},

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
