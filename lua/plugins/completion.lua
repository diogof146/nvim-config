-- Autocompletion Plugin for Neovim

return {
	"hrsh7th/nvim-cmp",

	-- Define plugin dependencies
	dependencies = {
		"hrsh7th/cmp-buffer", -- Buffer source for completions (suggestions from the current buffer)
		"hrsh7th/cmp-path", -- Path source for completions (suggests file paths)
		"hrsh7th/cmp-cmdline", -- Command-line source for completions (suggests commands in the command-line mode)
		"L3MON4D3/LuaSnip", -- Snippet engine (used for managing and expanding code snippets)
		"saadparwaiz1/cmp_luasnip", -- LuaSnip source for completions (provides snippet suggestions)
		"rafamadriz/friendly-snippets", -- Pre-made snippet collection (useful for a variety of languages)
	},

	config = function()
		-- Load the required modules
		local cmp = require("cmp") -- The main completion module for nvim-cmp
		local luasnip = require("luasnip") -- The snippet engine for expanding snippets

		-- Load VSCode-style snippets from the friendly-snippets collection (if available)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Main setup for nvim-cmp autocompletion
		cmp.setup({
			-- Configure snippet expansion
			snippet = {
				expand = function(args)
					-- Use LuaSnip's lsp_expand function to expand the snippet
					luasnip.lsp_expand(args.body) -- Expands the snippet in place
				end,
			},

			-- Key mappings for navigating and selecting completion items
			mapping = cmp.mapping.preset.insert({
				-- Scroll documentation up when <C-b> is pressed
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
				-- Scroll documentation down when <C-f> is pressed
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
				-- Trigger the completion menu with <C-Space>
				["<C-Space>"] = cmp.mapping.complete(), -- Open completion menu
				-- Confirm the selected completion with <CR> (enter)
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection

				-- Tab key behavior: Navigate to next completion or expand the snippet
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item() -- Select the next completion item
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump() -- Expand snippet or jump inside the snippet
					else
						fallback() -- If no completion or snippet action, fall back to default behavior
					end
				end, { "i", "s" }),

				-- Shift-Tab behavior: Navigate to previous completion or jump backward in snippet
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item() -- Select the previous completion item
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1) -- Jump backward in the snippet
					else
						fallback() -- If no completion or snippet action, fall back to default behavior
					end
				end, { "i", "s" }),
			}),

			-- Configure the completion sources in priority order
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- Prioritize LSP completions
				{ name = "luasnip" }, -- Next, prioritize snippets
				{ name = "buffer" }, -- Then, complete from words in the current buffer
				{ name = "path" }, -- Finally, complete filesystem paths
			}),

			-- Custom formatting for completion items (add source-specific labels/icons)
			formatting = {
				format = function(entry, vim_item)
					-- Add a label next to the completion item to indicate its source
					vim_item.kind = string.format("%s %s", vim_item.kind, ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name] or "") -- Append a label based on the source of completion
					return vim_item -- Return the formatted completion item
				end,
			},
		})

		-- Configure command-line completion (e.g., for ':command')
		cmp.setup.cmdline(":", {
			-- Use the preset command-line mappings
			mapping = cmp.mapping.preset.cmdline(),
			-- Configure sources for command-line completions (filesystem paths and command-line commands)
			sources = {
				{ name = "path" }, -- Complete filesystem paths in command-line mode
				{ name = "cmdline" }, -- Complete command-line commands (e.g., ":w", ":q")
			},
		})
	end,
}
