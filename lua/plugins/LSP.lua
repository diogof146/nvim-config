-- Language Server Protocol Configuration

-- This script sets up the Language Server Protocol (LSP) for Neovim, enabling features
-- such as intelligent code completion, diagnostics, code navigation, and more. It leverages
-- Mason for installing LSP servers, integrates with nvim-lspconfig for server configuration,
-- and adds additional functionality such as enhanced code actions, keybindings, and linter configurations.

return {
	-- The core plugin for LSP configuration
	"neovim/nvim-lspconfig", -- Source for the LSP plugin (GitHub: neovim/nvim-lspconfig)

	dependencies = {
		-- Adds LSP support to the completion engine (completion plugin)
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp

		-- Handles installation and management of LSP servers and tools
		"williamboman/mason.nvim", -- Mason: LSP server and tool manager

		-- Integrates Mason with nvim-lspconfig, simplifying LSP server setup
		"williamboman/mason-lspconfig.nvim", -- Mason integration for nvim-lspconfig
	},

	config = function()
		-- Setup Mason: A tool for managing LSP servers and related tools
		require("mason").setup({
			ui = {
				border = "rounded", -- Rounded borders for Mason's UI
				check_outdated_packages_on_open = true, -- Check for outdated packages upon opening Mason
			},
		})

		-- Setup Mason-LSPConfig: Automates installation of LSP servers
		require("mason-lspconfig").setup({
			-- List of LSP servers to install automatically via Mason
			ensure_installed = {
				"pyright", -- Python LSP
				"lua_ls", -- Lua LSP
				"ruff", -- Python linter (as LSP server)
				"ts_ls", -- TypeScript/JavaScript LSP
			},
			-- Automatically install missing LSP servers
			automatic_installation = true, -- Ensures missing LSP servers are installed automatically
		})

		-- Import core LSP configuration
		local lspconfig = require("lspconfig")

		-- Import cmp-nvim-lsp to extend LSP functionality with autocompletion capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Advanced setup for code actions (e.g., refactorings, quick fixes)
		capabilities.textDocument.codeAction = {
			dynamicRegistration = true, -- Enable dynamic registration for code actions
			codeActionLiteralSupport = {
				codeActionKind = {
					valueSet = (function()
						-- Generate and sort supported code action kinds
						local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
						table.sort(res)
						return res
					end)(),
				},
			},
		}

		-- Function to attach LSP functionality to a buffer
		local on_attach = function(client, bufnr)
			-- Set omnifunc (completion function) for the current buffer
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Helper function to set buffer-local keymaps
			local function buf_set_keymap(mode, key, func, desc)
				vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
			end

			-- Keymap for invoking code actions (e.g., refactoring, quick fixes)
			buf_set_keymap("n", "<leader>ca", function()
				-- Context for code actions
				local context = {
					diagnostics = vim.lsp.get_active_clients()[1]
							and vim.diagnostic.get(bufnr, { lnum = vim.fn.line(".") - 1 })
						or {}, -- Retrieve diagnostics for the current line
					only = vim.tbl_values(vim.lsp.protocol.CodeActionKind), -- All code action kinds
				}

				-- Trigger the code action menu with context
				vim.lsp.buf.code_action({
					context = context,
					callback = function(_, actions)
						if not actions or #actions == 0 then
							vim.notify("No code actions available", vim.log.levels.INFO)
							return
						end
						-- If Telescope is installed, use it for a better UI
						if pcall(require, "telescope") then
							require("telescope.builtin").lsp_code_actions()
						else
							vim.lsp.buf.code_action()
						end
					end,
				})
			end, "Code Action")

			-- LSP keybindings for navigating definitions, documentation, renaming symbols, etc.
			buf_set_keymap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
			buf_set_keymap("n", "K", vim.lsp.buf.hover, "Show Documentation")
			buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
			buf_set_keymap("n", "<leader>e", vim.diagnostic.open_float, "Show Line Diagnostics")
			buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			buf_set_keymap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
			buf_set_keymap("n", "gr", vim.lsp.buf.references, "Find References")
			buf_set_keymap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
		end

		-- Configuration for Python LSP (Pyright)
		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true, -- Automatically detect Python import paths
						diagnosticMode = "workspace", -- Perform analysis across the entire workspace
						useLibraryCodeForTypes = true, -- Use library code for type inference
						typeCheckingMode = "basic", -- Basic type checking mode
						diagnosticSeverityOverrides = { -- Override diagnostic severity levels for specific issues
							reportGeneralTypeIssues = "error", -- Type issues reported as errors
							reportOptionalMemberAccess = "warning", -- Optional member access reported as warnings
						},
					},
				},
			},
		})

		-- Configuration for Python Linter (using Ruff as LSP)
		lspconfig.ruff.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			init_options = {
				settings = {
					ruff = {
						lint = {
							enable = true, -- Enable linting via Ruff
							args = { "--line-length=500" }, -- Customize line length for linting
						},
					},
				},
			},
		})

		-- TypeScript/JavaScript LSP configuration (using tsserver)
		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
