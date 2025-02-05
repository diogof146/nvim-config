-- Syntax Highlighting and Smart Indentation for Neovim

return {
	-- The plugin repository for nvim-treesitter.
	"nvim-treesitter/nvim-treesitter", -- Plugin source (GitHub: nvim-treesitter/nvim-treesitter)

	-- The `build` function runs when the plugin is installed.
	-- It updates the Treesitter parsers to ensure you have the latest versions.
	build = function()
		-- This ensures that any new or updated parsers are fetched and installed immediately.
		-- The `with_sync = true` ensures this update is done synchronously, meaning the process
		-- will complete before Neovim continues loading.
		require("nvim-treesitter.install").update({ with_sync = true })
	end,

	-- The `config` function is called once the plugin has been loaded, to apply custom configuration.
	config = function()
		-- Load Treesitter configurations
		require("nvim-treesitter.configs").setup({
			-- List of programming languages for which parsers should be installed.
			ensure_installed = {
				"javascript",
				"typescript",
				"html",
				"css",
				"python",
				"java",
				"lua",
				"r",
			},

			-- Enable syntax highlighting via Treesitter.
			highlight = { enable = true },

			-- Enable smart indentation using Treesitter.
			indent = { enable = true },

			-- Automatically install any missing parsers for the configured languages.
			auto_install = true,
		})
	end,
}
