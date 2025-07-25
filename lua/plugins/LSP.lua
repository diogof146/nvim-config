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
				"jdtls", -- Java
				"clangd", -- C/C++ LSP
				"html", -- HTML LSP
				"cssls", -- CSS LSP
				"emmet_ls", -- Emmet for HTML/CSS abbreviations
			},
			-- Automatically install missing LSP servers
			automatic_installation = true, -- Ensures missing LSP servers are installed automatically
		})

		-- Import core LSP configuration
		local lspconfig = require("lspconfig")

		-- Create a global variable to track diagnostics state
		if vim.g.diagnostics_visible == nil then
			vim.g.diagnostics_visible = false
		end

		-- Configure diagnostics display settings
		local function setup_diagnostics(enabled)
			vim.diagnostic.config({
				virtual_text = enabled,
				signs = enabled,
				underline = enabled,
				update_in_insert = false,
				severity_sort = false,
			})
		end

		-- Disable diagnostics by default (on startup)
		setup_diagnostics(false)

		-- Add keybind to toggle diagnostics
		vim.keymap.set("n", "<localleader>dg", function()
			vim.g.diagnostics_visible = not vim.g.diagnostics_visible
			setup_diagnostics(vim.g.diagnostics_visible)
		end, { desc = "Toggle diagnostics" })

		-- Import cmp-nvim-lsp to extend LSP functionality with autocompletion capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
				vim.lsp.buf.code_action()
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
			settings = {
				-- Configure Ruff linting and formatting options
				args = { "--line-length=500" }, -- Set custom line length for linting
			},
		})

		-- TypeScript/JavaScript LSP configuration (using tsserver)
		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all", -- Show parameter name hints
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		-- Configuration for C/C++ LSP (Clangd)
		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = {
				"clangd",
				"--background-index", -- Enable background indexing for better performance
				"--clang-tidy", -- Enable clang-tidy integration for additional linting
				"--header-insertion=iwyu", -- Use include-what-you-use for header insertion
				"--completion-style=detailed", -- Provide detailed completion information
				"--function-arg-placeholders", -- Show function argument placeholders in completions
				"--fallback-style=llvm", -- Use LLVM coding style as fallback
			},
			init_options = {
				usePlaceholders = true, -- Enable placeholders in code completion
				completeUnimported = true, -- Complete symbols from unimported headers
				clangdFileStatus = true, -- Show file status in clangd
			},
			settings = {
				clangd = {
					InlayHints = {
						Designators = true, -- Show designator inlay hints
						Enabled = true, -- Enable inlay hints
						ParameterNames = true, -- Show parameter name hints
						DeducedTypes = true, -- Show deduced type hints
					},
					fallbackFlags = { "-std=c++17" }, -- Default to C++17 standard when no compile_commands.json
				},
			},
		})

		-- HTML Language Server configuration
		lspconfig.html.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				html = {
					format = {
						templating = true, -- Enable formatting for templating languages
						wrapLineLength = 120, -- Wrap lines at 120 characters
						wrapAttributes = "auto", -- Auto wrap attributes
					},
					hover = {
						documentation = true, -- Show documentation on hover
						references = true, -- Show references on hover
					},
					completion = {
						attributeDefaultValue = "doublequotes", -- Use double quotes for attribute values
					},
				},
			},
		})

		-- CSS Language Server configuration
		lspconfig.cssls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				css = {
					validate = true, -- Enable CSS validation
					lint = {
						unknownAtRules = "ignore", -- Ignore unknown at-rules (useful for CSS frameworks)
					},
				},
				scss = {
					validate = true, -- Enable SCSS validation
					lint = {
						unknownAtRules = "ignore",
					},
				},
				less = {
					validate = true, -- Enable Less validation
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		-- Emmet Language Server configuration for HTML/CSS abbreviations
		lspconfig.emmet_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"html",
				"htmldjango",
				"css",
				"sass",
				"scss",
				"less",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
			settings = {
				emmet = {
					includeLanguages = {
						-- Enable Emmet in JavaScript files for JSX
						javascript = "javascriptreact",
						typescript = "typescriptreact",
						vue = "html",
						svelte = "html",
					},
				},
			},
		})
	end,
}
