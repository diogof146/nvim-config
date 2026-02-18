-- Language Server Protocol Configuration
-- Handles LSP client setup, keybindings, and server initialization

return {
	"hrsh7th/cmp-nvim-lsp",

	dependencies = {
		"hrsh7th/nvim-cmp",
	},

	config = function()
		-- Initialize diagnostics visibility state
		if vim.g.diagnostics_visible == nil then
			vim.g.diagnostics_visible = false
		end

		-- Configure diagnostic display settings
		local function setup_diagnostics(enabled)
			vim.diagnostic.config({
				virtual_text = enabled, -- Show diagnostics as virtual text
				signs = enabled, -- Show signs in the gutter
				underline = enabled, -- Underline diagnostic regions
				update_in_insert = false, -- Don't update while typing
				severity_sort = false, -- Don't sort by severity
			})
		end

		-- Disable diagnostics by default
		setup_diagnostics(false)

		-- Toggle diagnostics keybind
		vim.keymap.set("n", "<localleader>dg", function()
			vim.g.diagnostics_visible = not vim.g.diagnostics_visible
			setup_diagnostics(vim.g.diagnostics_visible)
		end, { desc = "Toggle diagnostics" })

		-- CAPABILITIES SETUP

		-- Extend base LSP capabilities with nvim-cmp features for better completions
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Map server names to their config file names in lua/lsp/
		local server_configs = {
			basedpyright = "basedpyright", -- Python type checker
			ruff = "ruff", -- Python linter/formatter
			ts_ls = "ts_ls", -- TypeScript/JavaScript
			clangd = "clangd", -- C/C++
			["csharp-ls"] = "csharp-ls", -- C#
			lua_ls = "lua_ls", -- Lua
			sourcekit = "sourcekit", -- Swift
			bashls = "bashls", -- Bash/Shell
			html = "html", -- HTML
			cssls = "cssls", -- CSS/SCSS/Less
			emmet_ls = "emmet_ls", -- HTML/CSS abbreviations
			tailwindcss = "tailwindcss", -- Tailwind CSS
			jsonls = "jsonls", -- JSON
			yamlls = "yamlls", -- YAML
			taplo = "taplo", -- TOML
			lemminx = "lemminx", -- XML
			marksman = "marksman", -- Markdown
		}

		-- Load individual server configs from ~/.config/nvim/lua/lsp/<server>.lua
		for server_name, config_file in pairs(server_configs) do
			local config_path = "lsp." .. config_file
			local ok, server_config = pcall(require, config_path)

			if ok then
				-- Merge nvim-cmp capabilities with server config
				server_config.capabilities = capabilities
				vim.lsp.config(server_name, server_config)
			else
				-- Warn if config file is missing
				vim.notify("Could not load LSP config for " .. server_name, vim.log.levels.WARN)
			end
		end

		-- Sets up keybindings and features when LSP attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				-- Enable omnifunc completion
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Helper function for buffer-local keymaps
				local function map(mode, key, func, desc)
					vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
				end

				-- Navigation Keybinds
				map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
				map("n", "gt", vim.lsp.buf.type_definition, "Go to Type Definition")
				map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				map("n", "gr", vim.lsp.buf.references, "Find References")

				-- Documentation
				map("n", "K", vim.lsp.buf.hover, "Show Documentation")
				map("n", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
				map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")

				-- Code Actions & Refactoring
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
				map("n", "<localleader>r", vim.lsp.buf.rename, "Rename Symbol")

				-- Symbols & Workspace
				map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
				map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

				-- Diagnostics
				map("n", "<leader>dg", vim.diagnostic.open_float, "Show Diagnostic")
				map("n", "<Leader>jd", vim.diagnostic.goto_next, "Next Diagnostic")
				map("n", "<Leader>kd", vim.diagnostic.goto_prev, "Previous Diagnostic")
				map("n", "<leader>dq", vim.diagnostic.setloclist, "Diagnostics to Location List")

				-- Format on Save
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end

				-- Inlay Hints Toggle (if supported by server)
				if client.server_capabilities.inlayHintProvider then
					map("n", "<leader>ih", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "Toggle Inlay Hints")
				end
			end,
		})

		-- Activates all configured language servers
		vim.lsp.enable(vim.tbl_keys(server_configs))
	end,
}
