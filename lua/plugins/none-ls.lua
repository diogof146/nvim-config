-- none-ls: Bridge for non-LSP formatters/linters to work via LSP protocol
-- Use this for tools that don't have native LSP servers (Prettier, Stylua, etc.)

return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting

		null_ls.setup({
			sources = {
				-- Lua formatter
				formatting.stylua,

				-- Swift formatter
				formatting.swiftformat,

				-- JavaScript/TypeScript/HTML/CSS formatter
				-- Only activates if project has Prettier config file
				formatting.prettier.with({
					condition = function(utils)
						return utils.root_has_file({
							".prettierrc",
							".prettierrc.js",
							".prettierrc.json",
							"prettier.config.js",
						})
					end,
				}),
			},
		})

		-- Keybind for formatting current buffer
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })
	end,
}
