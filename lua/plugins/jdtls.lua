-- Java Development Tools Language Server (jdtls) Configuration

return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- Only load this plugin for Java files

	config = function()
		-- Setup an autocommand to configure jdtls when opening a Java file
		local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_cmds", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			group = jdtls_augroup,
			callback = function()
				-- Disable diagnostics by default
				vim.diagnostic.disable()

				-- Add keybind to toggle diagnostics
				vim.keymap.set("n", "<localleader>dg", function()
					if vim.diagnostic.is_disabled() then
						vim.diagnostic.enable()
					else
						vim.diagnostic.disable()
					end
				end, { desc = "Toggle diagnostics" })

				-- Get the root directory of the project
				-- This assumes we're using a common project structure (git, maven, gradle)
				local root_dir =
					require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

				-- If no project root found, use the current directory
				if root_dir == "" then
					root_dir = vim.fn.getcwd()
				end

				-- Get OS-specific settings
				local os_config = ""
				if vim.fn.has("mac") == 1 then
					os_config = "mac"
				elseif vim.fn.has("unix") == 1 then
					os_config = "linux"
				elseif vim.fn.has("win32") == 1 then
					os_config = "win"
				end

				-- Get the Mason installation path for jdtls
				local mason_registry = require("mason-registry")
				local jdtls_pkg = mason_registry.get_package("jdtls")
				local jdtls_path = jdtls_pkg:get_install_path()

				-- JDTLS configuration for Java projects
				local config = {
					-- Command that starts the language server
					cmd = {
						-- Java executable
						"java",

						-- JVM options for the language server
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xms1g",
						"-Xmx2g",

						-- The main jar file of the language server
						"-jar",
						vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

						-- Configuration for the language server
						"-configuration",
						jdtls_path .. "/config_" .. os_config,

						-- Important: This controls workspace path handling
						"-data",
						vim.fn.expand("~/.cache/jdtls-workspace/") .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
					},

					-- Root directory for the language server
					-- This is crucial for multi-module projects
					root_dir = root_dir,

					-- Various settings that control the behavior of the language server
					settings = {
						java = {
							-- Configure the Java language server settings
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" }, -- Use Fernflower decompiler
							completion = {
								favoriteStaticMembers = {
									-- Static imports
									"org.junit.Assert.*",
									"org.junit.Assume.*",
									"org.junit.jupiter.api.Assertions.*",
									"org.junit.jupiter.api.Assumptions.*",
									"org.junit.jupiter.api.DynamicContainer.*",
									"org.junit.jupiter.api.DynamicTest.*",
									"org.mockito.Mockito.*",
									"org.mockito.ArgumentMatchers.*",
									"org.mockito.Answers.*",
									"java.util.Objects.requireNonNull",
									"java.util.Objects.requireNonNullElse",
								},
								filteredTypes = {
									-- Filter out some types from auto-imports to reduce noise
									"com.sun.*",
									"io.micrometer.shaded.*",
									"java.awt.*",
									"jdk.*",
									"sun.*",
								},
								importOrder = {
									-- Import ordering
									"java",
									"javax",
									"com",
									"org",
									"net",
								},
							},
							-- Configure sources path for better navigation
							sources = {
								organizeImports = {
									starThreshold = 9999, -- Number of imports required for a star-import
									staticStarThreshold = 9999, -- Number of static imports required for a star-import
								},
							},
							-- Enable code generation
							codeGeneration = {
								toString = {
									template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}", -- toString() template
									generateComments = true,
								},
								hashCodeEquals = {
									useJava7Objects = true, -- Use Java 7+ Objects class for hashCode/equals
								},
								useBlocks = true, -- Use blocks in if/for/etc.
							},
							-- Configure the project's JDK version
							configuration = {
								-- Auto-download Maven/Gradle sources
								updateBuildConfiguration = "interactive",
								-- Configure JDK for this project (change to match your JDK version)
								runtimes = {
									{
										name = "JavaSE-17",
										path = vim.fn.expand("~/.sdkman/candidates/java/17.0.7-tem"), -- JDK path
									},
									{
										name = "JavaSE-11",
										path = vim.fn.expand("~/.sdkman/candidates/java/11.0.20-tem"), -- JDK path
									},
									{
										name = "JavaSE-1.8",
										path = vim.fn.expand("~/.sdkman/candidates/java/8.0.392-amzn"), -- JDK path
									},
								},
							},
							-- Better references
							references = {
								includeDecompiledSources = true,
							},
							-- Enable formatting
							format = {
								enabled = true,
								-- Configure the formatter settings
								settings = {
									url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
									profile = "GoogleStyle",
								},
							},
						},
					},

					-- Add capabilities from nvim-cmp
					-- This enables autocompletion integration with completion engine
					capabilities = require("cmp_nvim_lsp").default_capabilities(),

					-- Configure Java-specific features
					init_options = {
						-- Enable bundles that provide useful functionality
						bundles = {},

						-- Enable extended code actions support
						extendedClientCapabilities = {
							progressReportProvider = true, -- Show progress notifications
							classFileContentsSupport = true, -- Support decompiled code navigation
							overrideMethodsPromptSupport = true, -- Support method override prompt
							hashCodeEqualsPromptSupport = true, -- Support hashCode/equals generation
							advancedOrganizeImportsSupport = true, -- Support advanced import organization
							generateToStringPromptSupport = true, -- Support toString generation
							advancedGenerateAccessorsSupport = true, -- Support advanced getter/setter generation
							generateConstructorsPromptSupport = true, -- Support constructor generation
							generateDelegateMethodsPromptSupport = true, -- Support delegate method generation
							moveRefactoringSupport = true, -- Support move refactoring
							introduceSupportSupport = { -- Support introduction refactorings
								introduceSupportVariableSupport = true,
								introduceSupportConstantSupport = true,
								introduceSupportFieldSupport = true,
							},
						},
					},

					-- Set up key mappings specific to Java development
					on_attach = function(client, bufnr)
						-- Set omnifunc for enhanced completion
						vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

						-- Helper function to create buffer-local keymaps
						local function buf_set_keymap(mode, key, func, desc)
							vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
						end

						-- Standard LSP keymappings
						buf_set_keymap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
						buf_set_keymap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
						buf_set_keymap("n", "gr", vim.lsp.buf.references, "Go to References")
						buf_set_keymap("n", "K", vim.lsp.buf.hover, "Show Documentation")

						-- Java-specific keymappings
						-- Import organization
						buf_set_keymap("n", "<leader>oi", function()
							require("jdtls").organize_imports()
						end, "Organize Imports")

						-- Extract variable refactoring
						buf_set_keymap("n", "<leader>ev", function()
							require("jdtls").extract_variable()
						end, "Extract Variable")
						buf_set_keymap("v", "<leader>ev", function()
							require("jdtls").extract_variable(true)
						end, "Extract Variable")

						-- Extract method refactoring
						buf_set_keymap("v", "<leader>em", function()
							require("jdtls").extract_method(true)
						end, "Extract Method")

						-- Code action
						buf_set_keymap("n", "<leader>ca", function()
							vim.lsp.buf.code_action()
						end, "Code Action")

						-- Test related commands
						buf_set_keymap("n", "<leader>tc", function()
							require("jdtls").test_class()
						end, "Test Class")
						buf_set_keymap("n", "<leader>tm", function()
							require("jdtls").test_nearest_method()
						end, "Test Method")
					end,

					-- Configure how the language server interacts with Neovim
					flags = {
						allow_incremental_sync = true, -- More efficient updates
						server_side_fuzzy_completion = true, -- Enable fuzzy completion
					},

					-- Add completion capabilities
					-- Enable auto-import and method signature completion
					handlers = {
						-- Enhanced signature help
						["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
							-- Show signature help in a floating window
							border = "rounded",
							resolve_completion_items = true,
						}),
						-- Enhanced hover documentation
						["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
							border = "rounded",
						}),
					},
				}

				-- Start the language server with the configuration
				require("jdtls").start_or_attach(config)
			end,
		})
	end,
}
