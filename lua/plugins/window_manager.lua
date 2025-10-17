-- Neovim Window and Tab Management Configuration

-- Key Mappings:
--   Window Navigation:   <leader>w + h/j/k/l - Move between windows
--   Window Splits:      <leader>ws (horizontal), <leader>wv (vertical), <leader>w= (balance)
--   Window Resize:      <leader>wr (toggle mode), then use h/j/k/l
--   Tab Management:     <leader>tn (new), <leader>tc (close), <leader>1-9 (switch to specific tab)

return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			-- Global state for resize mode
			local ResizeMode = {
				active = false, -- Tracks if resize mode is currently active
				original_statusline = vim.o.statusline, -- Store original statusline
			}

			-- Setup bufferline configuration
			-- This creates the tab bar at the top of the editor
			require("bufferline").setup({
				options = {
					mode = "tabs", -- Use tabs mode instead of buffers
					separator_style = "slant", -- Use slanted separators between tabs
					always_show_bufferline = true, -- Always display the tab bar
					show_buffer_close_icons = true, -- Show close icons on tabs
					show_close_icon = true, -- Show close icon on the right
					color_icons = true, -- Enable filetype icon colors
					numbers = function(opts)
						-- Display tab number for <leader>N navigation
						return string.format("%d", opts.ordinal)
					end,
				},
			})

			-- Updates statusline to indicate resize mode state
			local function update_statusline()
				if ResizeMode.active then
					vim.o.statusline = "🔧 RESIZE MODE - Use HJKL to resize, <leader>wr to exit 🔧"
				else
					vim.o.statusline = ResizeMode.original_statusline
				end
			end

			-- Window navigation function
			-- Creates a function for moving to adjacent windows in specified direction
			local function create_window_nav(direction)
				return function()
					vim.cmd("wincmd " .. direction)
				end
			end

			-- Create resize function for a specific direction
			-- Returns a function that resizes the window in the specified direction
			local function create_resize_fn(direction)
				return function()
					local amount = 3 -- Amount to resize by each keypress

					-- Apply the appropriate resize command based on direction
					if direction == "h" then
						vim.cmd("vertical resize -" .. amount)
					elseif direction == "l" then
						vim.cmd("vertical resize +" .. amount)
					elseif direction == "j" then
						vim.cmd("resize +" .. amount)
					elseif direction == "k" then
						vim.cmd("resize -" .. amount)
					end
				end
			end

			-- Toggle function for resize mode
			-- Switches between normal and resize mode, updating keymaps accordingly
			local function toggle_resize_mode()
				ResizeMode.active = not ResizeMode.active

				if ResizeMode.active then
					-- Enter resize mode: map HJKL to resize commands
					vim.keymap.set("n", "h", create_resize_fn("h"), { buffer = 0 })
					vim.keymap.set("n", "j", create_resize_fn("j"), { buffer = 0 })
					vim.keymap.set("n", "k", create_resize_fn("k"), { buffer = 0 })
					vim.keymap.set("n", "l", create_resize_fn("l"), { buffer = 0 })
					vim.notify("Resize mode activated - Use HJKL to resize")
				else
					-- Exit resize mode: restore original HJKL mappings
					for _, key in ipairs({ "h", "j", "k", "l" }) do
						vim.keymap.del("n", key, { buffer = 0 })
					end
					vim.notify("Resize mode deactivated")
				end

				update_statusline()
			end

			-- Window navigation mappings
			-- Direct window movement using <leader>w + direction
			vim.keymap.set("n", "<leader>wh", create_window_nav("h"), { desc = "Move to left window" })
			vim.keymap.set("n", "<leader>wj", create_window_nav("j"), { desc = "Move to down window" })
			vim.keymap.set("n", "<leader>wk", create_window_nav("k"), { desc = "Move to up window" })
			vim.keymap.set("n", "<leader>wl", create_window_nav("l"), { desc = "Move to right window" })

			-- Window splitting mappings
			-- Create new window splits using mnemonics
			vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split horizontal" })
			vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
			vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })

			-- Resize mode toggle
			vim.keymap.set("n", "<leader>wr", toggle_resize_mode, { desc = "Toggle resize mode" })

			-- Tab management mappings
			vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
			vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

			-- Quick tab switching with numbers
			-- Maps <leader>N to switch to tab N (where N is 1-9)
			for i = 1, 9 do
				vim.keymap.set("n", "<leader>" .. i, function()
					vim.cmd(i .. "tabnext")
				end, { desc = "Go to tab " .. i })
			end
		end,
	},
}
