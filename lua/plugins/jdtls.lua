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
      if not root_dir or root_dir == "" then
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
      local jdtls_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls")

      -- Only try to get the path from Mason if the module exists
      local status_ok, mason_registry = pcall(require, "mason-registry")
      if status_ok then
        -- Check if the registry has a get_package method
        if mason_registry.get_package then
          -- Safely try to get the jdtls package
          local pkg_ok, jdtls_pkg = pcall(mason_registry.get_package, "jdtls")
          if pkg_ok and jdtls_pkg then
            -- Safely try to get the install path
            local path_ok, path = pcall(function()
              return jdtls_pkg:get_install_path()
            end)
            if path_ok and path then
              jdtls_path = path
            end
          end
        end
      end

      -- Make sure this path actually exists
      if vim.fn.isdirectory(jdtls_path) ~= 1 then
        vim.notify(
          "JDTLS installation not found at: "
          .. jdtls_path
          .. ". Please install JDTLS using :MasonInstall jdtls",
          vim.log.levels.ERROR
        )
        -- Return early to avoid further errors
        return
      end

      -- Detect available JDK installations
      -- Helper function to check if a path exists
      local function path_exists(path)
        if not path then
          return false
        end
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

      -- Safely build the launcher jar path
      local launcher_jar
      local launcher_pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
      local launcher_files = vim.fn.glob(launcher_pattern, true, true)

      if #launcher_files > 0 then
        launcher_jar = launcher_files[1]
      else
        vim.notify("JDTLS launcher jar not found with pattern: " .. launcher_pattern, vim.log.levels.ERROR)
        return
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
          -- Optimized memory settings (reduce starting memory, increase max)
          "-Xms256m",
          "-Xmx2g",
          -- Performance optimizations
          "-XX:+UseG1GC",
          "-XX:+UseStringDeduplication",
          "-Djdt.ls.vmargs=-Xmx2g",

          -- The main jar file of the language server
          "-jar",
          launcher_jar,

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
            -- Performance optimizations (re-enabled for better development experience)
            eclipse = {
              downloadSources = true, -- Enable automatic source download
            },
            maven = {
              downloadSources = true, -- Enable automatic source download for Maven
            },
            implementationsCodeLens = {
              enabled = false, -- Disable code lens for better performance
            },
            referencesCodeLens = {
              enabled = false, -- Disable code lens for better performance
            },
          },
        },

        -- Add capabilities from nvim-cmp if available
        capabilities = (function()
          local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
          if has_cmp then
            return cmp_lsp.default_capabilities()
          else
            return vim.lsp.protocol.make_client_capabilities()
          end
        end)(),

        -- Configure Java-specific features
        init_options = {
          -- Enable bundles that provide useful functionality
          bundles = {},

          -- Enable most useful extended capabilities
          extendedClientCapabilities = {
            progressReportProvider = true,      -- Show progress notifications
            classFileContentsSupport = true,    -- Support decompiled code navigation
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

          -- Helper function to create buffer-local keymaps
          local function buf_set_keymap(mode, key, func, desc)
            vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
          end

          -- Standard LSP keymappings (use buffer-local to avoid conflicts)
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
        end,

        -- Configure how the language server interacts with Neovim
        flags = {
          allow_incremental_sync = true,  -- More efficient updates
          server_side_fuzzy_completion = true, -- Enable fuzzy completion
        },

        -- Add completion capabilities
        -- Enable auto-import and method signature completion
        handlers = {
          -- Enhanced signature help
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            -- Show signature help in a floating window
            border = "rounded",
          }),
          -- Enhanced hover documentation
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
          }),
        },
      }

      -- Safely start or attach to the language server
      local has_jdtls, jdtls = pcall(require, "jdtls")
      if has_jdtls then
        jdtls.start_or_attach(config)
        -- Store the current buffer number in a global variable to track the most recent Java buffer
        vim.g.last_active_java_buffer = vim.api.nvim_get_current_buf()
      else
        vim.notify("Failed to require jdtls module", vim.log.levels.ERROR)
      end
    end

    -- Setup an autocommand to configure jdtls when opening a Java file
    local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_cmds", { clear = true })

    -- Use multiple events and aggressive timing
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "FileType" }, {
      pattern = { "*.java", "java" },
      group = jdtls_augroup,
      callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype

        -- Only proceed if this is actually a Java file
        if ft ~= "java" and not vim.fn.expand("%"):match("%.java$") then
          return
        end

        -- Check if JDTLS is already running for this buffer
        local existing_clients = vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })
        if #existing_clients > 0 then
          return
        end

        -- Use multiple scheduling attempts to ensure startup
        local function attempt_startup(attempt)
          attempt = attempt or 1

          vim.schedule(function()
            -- Double-check that the buffer is still valid and is Java
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end

            local current_ft = vim.bo[bufnr].filetype
            if current_ft ~= "java" then
              -- If filetype isn't set yet, try setting it
              if attempt <= 3 then
                vim.bo[bufnr].filetype = "java"
                vim.defer_fn(function()
                  attempt_startup(attempt + 1)
                end, 100)
              end
              return
            end

            -- Start JDTLS
            setup_jdtls()

            -- Verify it started, if not try again (up to 3 attempts)
            vim.defer_fn(function()
              local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })
              if #clients == 0 and attempt < 3 then
                vim.notify(
                  "JDTLS failed to start, retrying... (attempt " .. (attempt + 1) .. "/3)",
                  vim.log.levels.WARN
                )
                attempt_startup(attempt + 1)
              elseif #clients == 0 then
                vim.notify("JDTLS failed to start after 3 attempts", vim.log.levels.ERROR)
              end
            end, 500)
          end)
        end

        -- Start the first attempt immediately
        attempt_startup()
      end,
    })

    -- Simplified BufEnter handler to track active Java buffers only
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      group = jdtls_augroup,
      callback = function(args)
        vim.g.last_active_java_buffer = args.buf

        -- Only restart if no clients are attached to this specific buffer
        local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "jdtls" })
        if #clients == 0 then
          -- Use vim.schedule to avoid race conditions
          vim.schedule(function()
            setup_jdtls()
          end)
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
            local clients = vim.lsp.get_clients({ name = "jdtls" })
            if #clients == 0 then
              -- jdtls is not running, restore it after a short delay
              -- This delay helps avoid race conditions with garbage-day's wakeup process
              vim.defer_fn(function()
                vim.api.nvim_buf_call(vim.g.last_active_java_buffer, function()
                  vim.notify("Restarting JDTLS after inactivity", vim.log.levels.INFO)
                  setup_jdtls()
                end)
              end, 200) -- Wait 200ms after focus is gained
            end
          end
        end

        -- Also check current buffer if it's Java
        local current_buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[current_buf].filetype
        if ft == "java" then
          local clients = vim.lsp.get_clients({ bufnr = current_buf, name = "jdtls" })
          if #clients == 0 then
            vim.schedule(function()
              setup_jdtls()
            end)
          end
        end
      end,
    })
  end,
}
