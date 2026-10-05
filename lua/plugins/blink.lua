-- Autocompletion Plugin
return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		-- Load VSCode-style snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		require("blink.cmp").setup({
			snippets = { preset = "luasnip" },

			completion = {
				ghost_text = { enabled = true },
				menu = {
					border = "rounded",
					draw = {
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
						components = {
							kind_icon = {
								text = function(ctx)
									local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return icon .. " "
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
			},

			keymap = {
				preset = "default",
				["<C-space>"] = { "show" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				-- Super-Tab behavior: select next if menu open, else jump snippet, else insert tab
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},

			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
				providers = {
					lsp = { score_offset = 90 },
					snippets = { score_offset = 60 },
					path = { score_offset = 30 },
					buffer = { score_offset = 10 },
				},
			},
		})
	end,
}
