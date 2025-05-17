-- Java Development Tools Language Server (jdtls) Configuration

return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- Only load this plugin for Java files

	config = function()
		-- Override notification handler to suppress jdtls exit messages
		local old_notify = vim.notify
		vim.notify = function(msg, level, opts)
			-- Filter out jdtls quit messages with exit code
			if msg and msg:match("Client jdtls quit with exit code") then
				return -- Don't show these messages
			end
			old_notify(msg, level, opts)
		end

		-- Define a setup function that can be called both on FileType and manually
		local function setup_jdtls()
			-- Create a global variable to track diagnostics state
			if vim.g.diagnostics_visible == nil then
				vim.g.diagnostics_visible = false
			end

			-- Disable diagnostics by default (on startup)
			vim.diagnostic.config({
				virtual_text = false,
				signs = false,
				underline = false,
				update_in_insert = false,
				severity_sort = false,
			})

			-- Add keybind to toggle diagnostics
			vim.keymap.set("n", "<localleader>dg", function()
				vim.g.diagnostics_visible = not vim.g.diagnostics_visible
				if vim.g.diagnostics_visible then
					-- Enable all diagnostic displays
					vim.diagnostic.config({
						virtual_text = true,
						signs = true,
						underline = true,
						update_in_insert = false,
						severity_sort = false,
					})
				else
					-- Disable all diagnostic displays
					vim.diagnostic.config({
						virtual_text = false,
						signs = false,
						underline = false,
						update_in_insert = false,
						severity_sort = false,
					})
				end
			end, { desc = "Toggle diagnostics" })

			-- Get the root directory of the project
			-- This assumes we're using a common project structure (git, maven, gradle)
			local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

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

			-- Detect available JDK installations
			-- Helper function to check if a path exists
			local function path_exists(path)
				return vim.fn.isdirectory(path) == 1
			end

			-- Homebrew JDK paths
			local jdk_paths = {
        ["JavaSE-21"] = os.getenv("JAVA_HOME"),
			}

			-- Filter to only include existing JDK paths
			local available_runtimes = {}
			for name, path in pairs(jdk_paths) do
				if path_exists(path) then
					table.insert(available_runtimes, { name = name, path = path })
				end
			end

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
					-- Reduced logging
					"-Dlog.level=ERROR",
					-- Memory settings (512MB starting, 1GB max)
					"-Xms512m",
					"-Xmx1g",

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
							-- Configure JDK for this project (dynamically based on detected JDKs)
							runtimes = available_runtimes,
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

					-- Enable most useful extended capabilities
					extendedClientCapabilities = {
						progressReportProvider = true, -- Show progress notifications
						classFileContentsSupport = true, -- Support decompiled code navigation
						overrideMethodsPromptSupport = true, -- Support method override prompt
						hashCodeEqualsPromptSupport = true, -- Support hashCode/equals generation
						advancedOrganizeImportsSupport = true, -- Support advanced import organization
						generateToStringPromptSupport = true, -- Support toString generation
						advancedGenerateAccessorsSupport = true, -- Support advanced getter/setter generation
						generateConstructorsPromptSupport = true, -- Support constructor generation
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

					-- Test related commands (kept for reference but commented out)
					-- These are the testing functions mentioned earlier
					-- Uncomment if you need Java testing capabilities
					--[[ 
					buf_set_keymap("n", "<leader>tc", function()
						require("jdtls").test_class()
					end, "Test Class")
					buf_set_keymap("n", "<leader>tm", function()
						require("jdtls").test_nearest_method()
					end, "Test Method")
					--]]
				end,

				-- Configure how the language server interacts with Neovim
				flags = {
					allow_incremental_sync = true, -- More efficient updates
					server_side_fuzzy_completion = true, -- Enable fuzzy completion
					quiet = true, -- Attempt to reduce some LSP messages
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

			-- Start or attach to the language server
			require("jdtls").start_or_attach(config)

			-- Store the current buffer number in a global variable to track the most recent Java buffer
			vim.g.last_active_java_buffer = vim.api.nvim_get_current_buf()
		end

		-- Setup an autocommand to configure jdtls when opening a Java file
		local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_cmds", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			group = jdtls_augroup,
			callback = function()
				setup_jdtls()
			end,
		})

		-- Enhanced BufEnter handler to better handle jdtls restarts
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.java",
			group = jdtls_augroup,
			callback = function(args)
				local bufnr = args.buf

				-- Check if any jdtls client is active for this buffer
				local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })

				if #clients == 0 then
					-- No active jdtls client, try to start it
					setup_jdtls()

					-- Check if it started successfully
					vim.defer_fn(function()
						clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })
						if #clients == 0 then
							vim.notify("JDTLS failed to start - attempting forced restart", vim.log.levels.INFO)
							setup_jdtls()
						end
					end, 200)
				end
			end,
		})

		-- Add FocusGained event to restart jdtls after returning from AFK
		-- This directly addresses the issue with garbage-day.nvim
		vim.api.nvim_create_autocmd("FocusGained", {
			group = jdtls_augroup,
			callback = function()
				-- If we have a stored java buffer and it still exists
				if vim.g.last_active_java_buffer and vim.api.nvim_buf_is_valid(vim.g.last_active_java_buffer) then
					-- Check if the buffer is visible
					local wins = vim.fn.win_findbuf(vim.g.last_active_java_buffer)
					if #wins > 0 then
						-- Check if jdtls is already running
						local clients = vim.lsp.get_active_clients({ name = "jdtls" })
						if #clients == 0 then
							-- jdtls is not running, restore it after a short delay
							-- This delay helps avoid race conditions with garbage-day's wakeup process
							vim.defer_fn(function()
								vim.api.nvim_buf_call(vim.g.last_active_java_buffer, function()
									vim.notify("Restarting JDTLS after inactivity", vim.log.levels.INFO)
									setup_jdtls()
								end)
							end, 200) -- Wait 500ms after focus is gained
						end
					end
				end

				-- Also check current buffer if it's Java
				local current_buf = vim.api.nvim_get_current_buf()
				local ft = vim.api.nvim_buf_get_option(current_buf, "filetype")
				if ft == "java" then
					local clients = vim.lsp.get_active_clients({ bufnr = current_buf, name = "jdtls" })
					if #clients == 0 then
						vim.defer_fn(function()
							setup_jdtls()
						end, 200)
					end
				end
			end,
		})

		-- Track active Java buffers
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.java",
			group = jdtls_augroup,
			callback = function(args)
				vim.g.last_active_java_buffer = args.buf
			end,
		})
	end,
}
