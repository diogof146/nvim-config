-- Java Development Tools Language Server (jdtls)

return {
	"mfussenegger/nvim-jdtls",
	ft = "java",

	config = function()
		-- Suppress jdtls exit messages
		local old_notify = vim.notify
		vim.notify = function(msg, level, opts)
			if msg and msg:match("Client jdtls quit with exit code") then
				return
			end
			old_notify(msg, level, opts)
		end

		-- Setup
		local function setup_jdtls()
			-- Find project root directory
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
			local root_dir = require("jdtls.setup").find_root(root_markers)

			if not root_dir or root_dir == "" then
				root_dir = vim.fn.getcwd()
			end

			-- Detect OS for platform-specific config
			local os_config = "linux"
			if vim.fn.has("mac") == 1 then
				os_config = "mac"
			elseif vim.fn.has("win32") == 1 then
				os_config = "win"
			end

			-- Get jdtls installation path from Mason
			local jdtls_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls")

			local mason_ok, mason_registry = pcall(require, "mason-registry")
			if mason_ok and mason_registry.get_package then
				local pkg_ok, jdtls_pkg = pcall(mason_registry.get_package, "jdtls")
				if pkg_ok and jdtls_pkg then
					local path_ok, path = pcall(function()
						return jdtls_pkg:get_install_path()
					end)
					if path_ok and path then
						jdtls_path = path
					end
				end
			end

			-- Verify jdtls is installed
			if vim.fn.isdirectory(jdtls_path) ~= 1 then
				vim.notify("jdtls not found. Install with :MasonInstall jdtls", vim.log.levels.ERROR)
				return false
			end

			-- Detect available JDK installations
			local available_runtimes = {}
			local java_home = os.getenv("JAVA_HOME")
			if java_home and vim.fn.isdirectory(java_home) == 1 then
				table.insert(available_runtimes, {
					name = "JavaSE-21",
					path = java_home,
				})
			end

			-- Find launcher jar
			local launcher_pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
			local launcher_files = vim.fn.glob(launcher_pattern, true, true)

			if #launcher_files == 0 then
				vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
				return false
			end

			local launcher_jar = launcher_files[1]

			-- Workspace directory
			local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. vim.fn.fnamemodify(root_dir, ":p:h:t")

			-- ========================================================================
			-- JDTLS CONFIGURATION
			-- ========================================================================
			local config = {
				cmd = {
					"java",

					-- JVM options
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.level=ERROR",

					-- Memory settings (start small, allow up to 2GB)
					"-Xms256m",
					"-Xmx2g",

					-- Performance optimizations
					"-XX:+UseG1GC",
					"-XX:+UseStringDeduplication",

					-- Launcher
					"-jar",
					launcher_jar,

					-- Platform-specific config
					"-configuration",
					jdtls_path .. "/config_" .. os_config,

					-- Workspace (isolated per project)
					"-data",
					workspace_dir,
				},

				root_dir = root_dir,

				settings = {
					java = {
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" }, -- Decompiler

						inlayHints = {
							parameterNames = {
								enabled = "all", -- Show parameter names
							},
						},

						compile = {
							nullAnalysis = {
								mode = "automatic",
							},
						},

						completion = {
							favoriteStaticMembers = {
								"org.junit.Assert.*",
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
								"org.mockito.ArgumentMatchers.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
							chain = {
								enabled = true,
							},
							importOrder = { "java", "javax", "com", "org", "net" },
							matchCase = "firstLetter",
						},

						autobuild = { enabled = true },

						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},

						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
								generateComments = true,
							},
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},

						configuration = {
							updateBuildConfiguration = "interactive",
							runtimes = available_runtimes,
						},

						references = {
							includeDecompiledSources = true,
						},

						format = {
							enabled = true,
							-- No custom formatter config since you don't have the XML file
							-- jdtls will use its default Eclipse formatter
						},

						eclipse = {
							downloadSources = true,
						},
						maven = {
							downloadSources = true,
						},

						-- Disable code lens for performance
						implementationsCodeLens = { enabled = false },
						referencesCodeLens = { enabled = false },
					},
				},

				-- Capabilities from nvim-cmp
				capabilities = (function()
					local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
					if has_cmp then
						return cmp_lsp.default_capabilities()
					else
						return vim.lsp.protocol.make_client_capabilities()
					end
				end)(),

				init_options = {
					bundles = {}, -- For DAP debugger support (empty for now)
					extendedClientCapabilities = {
						progressReportProvider = true,
						classFileContentsSupport = true,
						overrideMethodsPromptSupport = true,
						hashCodeEqualsPromptSupport = true,
						advancedOrganizeImportsSupport = true,
						generateToStringPromptSupport = true,
						advancedGenerateAccessorsSupport = true,
						generateConstructorsPromptSupport = true,
					},
				},

				-- Java-specific keybinds (standard LSP keybinds handled by LspAttach)
				on_attach = function(client, bufnr)
					local function map(mode, key, func, desc)
						vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
					end

					-- Java-specific refactoring commands
					map("n", "<leader>oi", function()
						require("jdtls").organize_imports()
					end, "Organize Imports")

					map("n", "<leader>ev", function()
						require("jdtls").extract_variable()
					end, "Extract Variable")

					map("v", "<leader>ev", function()
						require("jdtls").extract_variable(true)
					end, "Extract Variable")

					map("v", "<leader>em", function()
						require("jdtls").extract_method(true)
					end, "Extract Method")
				end,

				flags = {
					allow_incremental_sync = true,
					server_side_fuzzy_completion = true,
				},

				handlers = {
					["textDocument/signatureHelp"] = vim.lsp.with(
						vim.lsp.handlers.signature_help,
						{ border = "rounded" }
					),
					["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				},
			}

			-- Start jdtls
			local jdtls = require("jdtls")
			jdtls.start_or_attach(config)
			return true
		end

		-- ========================================================================
		-- AUTOCMD: Start jdtls when opening Java files
		-- ========================================================================
		local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_setup", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			group = jdtls_augroup,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()

				-- Check if jdtls already attached to this buffer
				local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })
				if #clients > 0 then
					return
				end

				-- Delay startup slightly to ensure everything is ready
				vim.defer_fn(function()
					-- Double check buffer is still valid and is Java
					if not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end

					if vim.bo[bufnr].filetype ~= "java" then
						return
					end

					-- Start jdtls
					local success = setup_jdtls()

					if not success then
						vim.notify("jdtls failed to start. Use :JdtlsRestart to retry", vim.log.levels.WARN)
					end
				end, 100) -- 100ms delay to avoid race conditions
			end,
		})

		-- ========================================================================
		-- MANUAL RESTART COMMAND
		-- ========================================================================
		vim.api.nvim_create_user_command("JdtlsRestart", function()
			-- Stop all jdtls clients
			local clients = vim.lsp.get_clients({ name = "jdtls" })
			for _, client in ipairs(clients) do
				client.stop()
			end

			-- Wait for clients to stop, then restart
			vim.defer_fn(function()
				setup_jdtls()
			end, 500)
		end, { desc = "Restart jdtls language server" })
	end,
}
