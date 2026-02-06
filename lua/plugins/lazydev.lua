-- lazydev.nvim: Better Lua LSP for Neovim config development
-- Provides vim.* API completions and documentation

return {
	"folke/lazydev.nvim",
	ft = "lua", -- Only load when editing Lua files

	opts = {
		library = {
			-- Load the full Neovim runtime for vim.* completions
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},

	dependencies = {
		-- Optional: Type definitions for vim.uv (Neovim's async I/O)
		{ "Bilal2453/luvit-meta", lazy = true },
	},
}
