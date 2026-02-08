-- Language Server Protocol Configuration

return {
	"hrsh7th/cmp-nvim-lsp",

	config = function()
		-- DIAGNOSTICS SETUP
		if vim.g.diagnostics_visible == nil then
			vim.g.diagnostics_visible = false
		end

		-- Configure diagnostic display settings
		local function setup_diagnostics(enabled)
			vim.diagnostic.config({
				virtual_text = enabled,
				signs = enabled,
				underline = enabled,
				update_in_insert = false,
				severity_sort = false,
			})
		end

		-- Disable diagnostics by default
		setup_diagnostics(false)

		-- Toggle diagnostics keybind
		vim.keymap.set("n", "<localleader>dg", function()
			vim.g.diagnostics_visible = not vim.g.diagnostics_visible
			setup_diagnostics(vim.g.diagnostics_visible)
		end, { desc = "Toggle diagnostics" })

		-- Extend base capabilities with nvim-cmp features for better completions
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Default settings for all LSP servers
		vim.lsp.config("*", {
			root_markers = { ".git", ".project" },
			capabilities = capabilities,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				-- Enable omnifunc completion
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Helper for buffer-local keymaps
				local function map(mode, key, func, desc)
					vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
				end

				-- Navigation keybinds
				map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
				map("n", "gt", vim.lsp.buf.type_definition, "Go to Type Definition")
				map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				map("n", "gr", vim.lsp.buf.references, "Find References")

				-- Documentation
				map("n", "K", vim.lsp.buf.hover, "Show Documentation")

				-- Code actions
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

				-- Document symbols (outline of current file)
				map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")

				-- Workspace symbols (search symbols across project)
				map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

				-- Show diagnostic in floating window
				map("n", "<leader>dg", vim.diagnostic.open_float, "Show Diagnostic")

				-- Jump to next/previous diagnostic
				map("n", "<Leader>jd", vim.diagnostic.goto_next, "Next Diagnostic")
				map("n", "<Leader>kd", vim.diagnostic.goto_prev, "Previous Diagnostic")

				-- Show all diagnostics in location list
				map("n", "<leader>dq", vim.diagnostic.setloclist, "Diagnostics to Location List")

				-- Signature help
				map("n", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
				map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")

				-- Rename symbol across all files
				map("n", "<localleader>r", vim.lsp.buf.rename, "Rename Symbol")

				-- Format on save
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end

				-- Inlay hints toggle (if supported by server)
				if client.server_capabilities.inlayHintProvider then
					map("n", "<leader>ih", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "Toggle Inlay Hints")
				end
			end,
		})

		-- Server configs are loaded from ~/.config/nvim/lsp/<server_name>.lua
		vim.lsp.enable({
			"basedpyright", -- Python type checker
			"ruff", -- Python linter/formatter
			"ts_ls", -- TypeScript/JavaScript
			"clangd", -- C/C++
			"omnisharp", -- C#
			"lua_ls", -- Lua
			"sourcekit", -- Swift
			"bashls", -- Bash/Shell
			"html", -- HTML
			"cssls", -- CSS/SCSS/Less
			"emmet_ls", -- HTML/CSS abbreviations
			"tailwindcss", -- Tailwind CSS
			"jsonls", -- JSON
			"yamlls", -- YAML
			"taplo", -- TOML
			"lemminx", -- XML
			"marksman", -- Markdown
		})
	end,
}
