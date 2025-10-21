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
	},

	config = function()
		-- Setup Mason: A tool for managing LSP servers and related tools (installation only)
		require("mason").setup({
			ui = {
				border = "rounded", -- Rounded borders for Mason's UI
				check_outdated_packages_on_open = true, -- Check for outdated packages upon opening Mason
			},
		})

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

			-- Navigation keybindings
			buf_set_keymap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
			buf_set_keymap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
			buf_set_keymap("n", "gt", vim.lsp.buf.type_definition, "Go to Type Definition")
			buf_set_keymap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
			buf_set_keymap("n", "gr", vim.lsp.buf.references, "Find References")

			-- Documentation
			buf_set_keymap("n", "K", vim.lsp.buf.hover, "Show Documentation")

			-- Code actions
			buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

			-- Inlay hints toggle (if supported)
			if client.server_capabilities.inlayHintProvider then
				buf_set_keymap("n", "<leader>ih", function()
					local bufnr = vim.api.nvim_get_current_buf()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
				end, "Toggle Inlay Hints")
			end
		end

		-- Configuration for Python LSP (Pyright)
		vim.lsp.config("pyright", {
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
							reportGeneralTypeIssues = "error", -- Type issues reporte as errors
							reportOptionalMemberAccess = "warning", -- Optional member access reported as warnings
						},
					},
				},
			},
		})
		vim.lsp.enable("pyright")

		-- Configuration for Python Linter (using Ruff as LSP)
		vim.lsp.config("ruff", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				-- Configure Ruff linting and formatting options
				args = { "--line-length=500" }, -- Set custom line length for linting
			},
		})
		vim.lsp.enable("ruff")

		-- TypeScript/JavaScript LSP configuration (using tsserver)
		vim.lsp.config("ts_ls", {
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
		vim.lsp.enable("ts_ls")

		-- Configuration for C/C++ LSP (Clangd)
		vim.lsp.config("clangd", {
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
		vim.lsp.enable("clangd")

		-- HTML Language Server configuration
		vim.lsp.config("html", {
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
		vim.lsp.enable("html")

		-- CSS Language Server configuration
		vim.lsp.config("cssls", {
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
		vim.lsp.enable("cssls")

		-- Emmet Language Server configuration for HTML/CSS abbreviations
		vim.lsp.config("emmet_ls", {
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
		vim.lsp.enable("emmet_ls")

		-- Swift Language Server configuration
		vim.lsp.config("sourcekit", {
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "sourcekit-lsp" }, -- Swift LSP command
		})
		vim.lsp.enable("sourcekit")
	end,
}
