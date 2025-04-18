return {
	"zeioth/garbage-day.nvim",
	dependencies = "neovim/nvim-lspconfig",
	event = "VeryLazy",
	opts = {
		-- Core options
		aggressive_mode = true, -- Set to true to maximize RAM savings but might cause brief delays when switching files
		excluded_lsp_clients = { -- LSP clients that should never be stopped
			"null-ls", -- Keep formatters/linters running
			"none-ls"
		},
		grace_period = 60 * 10, -- Wait (sec) after losing focus before stopping LSP clients
		wakeup_delay = 0, -- Wait (ms) before restoring LSP to avoid accidental wakeups

		-- Debug options
		notifications = true, -- Set to true initially to confirm it's working properly
		retries = 3, -- Times to try starting an LSP client before giving up
		timeout = 1000, -- Time in ms to complete retries
	},
}
