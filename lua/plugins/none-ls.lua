-- Integration with External Tools for Code Formatting and Diagnostics

return {
	"nvimtools/none-ls.nvim", -- Plugin repository (GitHub: nvimtools/none-ls.nvim)

	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		-- Require 'null-ls' plugin for integrating external tools into Neovim.
		local null_ls = require("null-ls")

		-- The 'builtins' module provides built-in sources for common tools like formatters and linters.
		local formatting = null_ls.builtins.formatting -- Provides access to code formatting tools
		local diagnostics = null_ls.builtins.diagnostics -- Provides access to diagnostics (linting) tools

		-- Setup 'null-ls' with specific configurations
		null_ls.setup({
			debug = true, -- Enables debug logging for troubleshooting issues with the plugin
			sources = {
				-- Python Formatting Tools
				formatting.black.with({
					-- 'black' is a Python code formatter that adheres to PEP 8 style guide
					extra_args = { "--fast", "--line-length", "500" }, -- Custom arguments passed to 'black' for performance and line length
				}), -- Python code formatter (black)

				formatting.isort, -- 'isort' is used to sort imports in Python files

				-- Lua Formatting
				formatting.stylua, -- 'stylua' is a code formatter for Lua

				-- Web Development Formatting with Prettier
				-- Only triggers if the project has a Prettier configuration file (e.g., '.prettierrc')
				formatting.prettier.with({
					condition = function(utils)
						-- Check if the project root directory contains Prettier configuration files
						return utils.root_has_file({
							".prettierrc",
							".prettierrc.js",
							".prettierrc.json",
						})
					end,
				}),
			},
		})

		-- Keybinding for formatting the current buffer
		-- Maps the leader key followed by 'gf' to trigger the 'vim.lsp.buf.format' function,
		-- which formats the buffer according to the configured formatters.
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })
	end,
}
