-- Inline LSP Diagnostics
return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			-- Preset style - available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
			preset = "modern",

			-- Transparency settings
			transparent_bg = false,
			transparent_cursorline = true,

			-- Highlight groups for colors
			hi = {
				error = "DiagnosticError",
				warn = "DiagnosticWarn",
				info = "DiagnosticInfo",
				hint = "DiagnosticHint",
				arrow = "NonText",
				background = "CursorLine",
				mixing_color = "Normal", -- Color to blend with (or "None")
			},

			-- Filetypes to disable
			disabled_ft = {},

			options = {
				-- Show diagnostic source (e.g., "lua_ls", "pyright")
				show_source = {
					enabled = false,
					if_many = false, -- Only show if multiple sources
				},

				-- Use icons from vim.diagnostic.config
				use_icons_from_diagnostic = false,

				-- Color arrow to match diagnostic severity
				set_arrow_to_diag_color = false,

				-- Throttle updates (ms) - higher = less CPU, may feel less responsive
				throttle = 20,

				-- Minimum chars before wrapping
				softwrap = 30,

				-- Diagnostic message display
				add_messages = {
					messages = true, -- Show full messages
					display_count = false, -- Show count when cursor not on line
					use_max_severity = false, -- Only count most severe
					show_multiple_glyphs = true, -- Multiple icons for same severity
				},

				-- Multiline diagnostic support
				multilines = {
					enabled = false, -- Enable multiline diagnostics
					always_show = false, -- Show on all lines
					trim_whitespaces = false, -- Remove leading/trailing whitespace
					tabstop = 4, -- Spaces per tab
					severity = nil, -- Filter by severity
				},

				-- Show all diagnostics on cursor line (not just under cursor)
				show_all_diags_on_cursorline = false,

				-- Only show diagnostics directly under cursor
				show_diags_only_under_cursor = false,

				-- Related diagnostics from LSP
				show_related = {
					enabled = true,
					max_count = 3,
				},

				-- Enable in insert mode (may cause visual artifacts)
				enable_on_insert = false,

				-- Enable in select mode
				enable_on_select = false,

				-- Overflow handling
				overflow = {
					mode = "wrap", -- "wrap", "none", "oneline"
					padding = 0,
				},

				-- Break long messages into lines
				break_line = {
					enabled = false,
					after = 30,
				},

				-- Custom format function
				-- format = function(diag) return diag.message end,
				format = nil,

				-- Virtual text priority
				virt_texts = {
					priority = 2048,
				},

				-- Severity filter
				severity = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},

				-- Events to attach diagnostics
				overwrite_events = nil,

				-- Auto-disable when opening diagnostic float
				override_open_float = false,

				-- Experimental options
				experimental = {
					use_window_local_extmarks = false,
				},
			},
		})

		-- Show diagnostics on all lines when enabled
		vim.diagnostic.config({
			virtual_text = false, -- Disable default virtual text
		})

		local diagnostics_enabled = false

		-- Toggle function using enable/disable
		local function toggle_diagnostics()
			if diagnostics_enabled then
				require("tiny-inline-diagnostic").disable()
				vim.diagnostic.config({ signs = false }) -- Hide number column signs
				diagnostics_enabled = false
				vim.notify("Inline diagnostics disabled", vim.log.levels.INFO)
			else
				require("tiny-inline-diagnostic").enable()
				vim.diagnostic.config({ signs = true }) -- Show number column signs
				diagnostics_enabled = true
				vim.notify("Inline diagnostics enabled", vim.log.levels.INFO)
			end
		end

		-- Toggle keybinding
		vim.keymap.set("n", "<leader>dt", toggle_diagnostics, { desc = "Toggle inline diagnostics" })
	end,
}
