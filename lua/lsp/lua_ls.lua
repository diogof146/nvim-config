-- lua_ls: Lua Language Server

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},

	settings = {
		Lua = {
			-- Disable telemetry
			telemetry = { enable = false },

			-- Formatting options (if not using stylua via none-ls)
			format = {
				enable = false, -- Disable built-in formatter (use stylua via none-ls instead)
			},

			-- Diagnostics
			diagnostics = {
				-- Don't warn about vim global (lazydev handles this better)
				globals = { "vim" },
			},

			-- Workspace settings
			workspace = {
				-- Don't ask about Luassert workspace config
				checkThirdParty = false,
			},

			-- Completion settings
			completion = {
				callSnippet = "Replace", -- Show function signatures
			},

			-- Hover documentation
			hint = {
				enable = true, -- Enable inlay hints
			},
		},
	},
}
