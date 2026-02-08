-- File Explorer and Git Status for Neovim
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			-- Close Neo-tree when opening a file
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- Configure available sources
			sources = {
				"filesystem",
				"buffers",
				"git_status",
			},

			-- Default component configs
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = nil,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "ﰊ",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "",
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},

			-- Filesystem configuration
			filesystem = {
				-- Follow current file settings
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},

				-- File watching
				use_libuv_file_watcher = true,

				bind_to_cwd = true,
				cwd_target = {
					sidebar = "tab",
					current = "window",
				},

				hijack_netrw_behavior = "open_current",
				scan_mode = "shallow",

				async_directory_scan = "auto",

				group_empty_dirs = true, -- Group empty directories to reduce clutter
				find_by_full_path_words = false, -- Faster searching

				-- File filtering
				filtered_items = {
					visible = false,
					hide_dotfiles = false, -- Show dotfiles by default
					hide_gitignored = true,
					hide_hidden = true, -- Hide system hidden files
					hide_by_name = {
						"node_modules",
						".git",
						".cache",
						"__pycache__",
						".pytest_cache",
						".mypy_cache",
						"target", -- Java build directory
						"build", -- Common build directory
						"dist", -- Distribution directory
						".gradle", -- Gradle cache
						".m2", -- Maven cache
					},
					hide_by_pattern = {
						"*.class", -- Java compiled files
						"*.jar", -- Java archives (optional)
						"*.pyc", -- Python compiled files
						"*.pyo", -- Python optimized files
						"*~", -- Backup files
						"*.swp", -- Vim swap files
						"*.tmp", -- Temporary files
						".DS_Store", -- macOS system files
						"thumbs.db", -- Windows system files
					},
					always_show = {
						".gitignore",
						".env",
						".nvmrc",
					},
					never_show = {
						".DS_Store",
						"thumbs.db",
					},
				},

				-- Window mappings for filesystem
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["b"] = "navigate_up",
						["e"] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["D"] = "fuzzy_finder_directory",
						["#"] = "fuzzy_sorter",
						["f"] = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["og"] = { "order_by_git_status", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
				},
			},

			-- Buffers configuration
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["b"] = "navigate_up",
						["e"] = "set_root",
					},
				},
			},

			-- Git status configuration
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},

			-- Global window configuration
			window = {
				position = "left",
				width = 30,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false,
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["w"] = "open_with_window_picker",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["Z"] = "expand_all_nodes",
					["a"] = {
						"add",
						config = {
							show_path = "none",
						},
					},
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				},
			},

			nesting_rules = {},

			-- Event handlers for better integration
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
						-- Auto close Neo-tree when opening a file (optional)
						-- require("neo-tree.command").execute({ action = "close" })
					end,
				},
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.opt_local.number = false
						vim.opt_local.relativenumber = false
						vim.opt_local.signcolumn = "no"
					end,
				},
			},
		})

		-- Simple toggle function that always opens in current buffer's directory
		local function toggle_neotree()
			local manager = require("neo-tree.sources.manager")
			local renderer = require("neo-tree.ui.renderer")
			local state = manager.get_state("filesystem")

			if renderer.window_exists(state) then
				-- Neo-tree is open, close it
				require("neo-tree.command").execute({ action = "close" })
			else
				-- Neo-tree is closed, open it in current buffer's directory
				local current_file = vim.api.nvim_buf_get_name(0)
				if current_file and current_file ~= "" and not current_file:match("^neo%-tree") then
					-- Get the directory of current buffer
					local current_dir = vim.fn.fnamemodify(current_file, ":h")
					require("neo-tree.command").execute({
						action = "show",
						source = "filesystem",
						position = "left",
						dir = current_dir,
						reveal_file = current_file,
					})
				else
					-- No current file, open at cwd
					require("neo-tree.command").execute({
						action = "show",
						source = "filesystem",
						position = "left",
					})
				end
			end
		end

		-- Key mapping
		vim.keymap.set("n", "<leader>n", toggle_neotree, {
			noremap = true,
			silent = true,
		})
	end,
}
