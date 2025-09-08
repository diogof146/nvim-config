-- Xcode Build Integration for iOS/macOS Development
-- This plugin provides comprehensive Xcode project management within Neovim,
-- including building, running, testing, and debugging capabilities.

return {
  "wojciech-kulik/xcodebuild.nvim",
  -- Note: Dependencies removed since you already have these plugins elsewhere
  config = function()
    require("xcodebuild").setup({
      -- Show build logs automatically when building
      show_build_progress_bar = true,

      -- Automatically save files before building
      prepare_snapshot_test_previews = true,

      -- Code coverage settings
      code_coverage = {
        enabled = true, -- Enable code coverage reports
      },

      -- Test settings
      tests = {
        show_success_notification = true, -- Show notification when tests pass
      },

      -- Log settings
      logs = {
        -- Use xcbeautify for prettier logs (install with: brew install xcbeautify)
        auto_open_on_success_tests = false,                 -- Don't auto-open logs on successful tests
        auto_open_on_failed_tests = true,                   -- Auto-open logs on failed tests
        auto_open_on_success_build = false,                 -- Don't auto-open logs on successful builds
        auto_open_on_failed_build = true,                   -- Auto-open logs on failed builds
        auto_focus = true,                                  -- Auto focus the log window when opened
        filetype = "objc",                                  -- Syntax highlighting for logs
        open_command = "silent botright 20split {path}",    -- How to open log window
        logs_formatter = "xcbeautify --disable-colored-output", -- Log formatter
      },
    })

    -- Key mappings for Xcodebuild functionality
    local opts = { noremap = true, silent = true }

    -- Main action picker - shows all available commands
    vim.keymap.set(
      "n",
      "<localleader>X",
      "<cmd>XcodebuildPicker<cr>",
      vim.tbl_extend("force", opts, { desc = "Show Xcodebuild Actions" })
    )

    -- Building and Running
    vim.keymap.set(
      "n",
      "<localleader>xb",
      "<cmd>XcodebuildBuild<cr>",
      vim.tbl_extend("force", opts, { desc = "Build Project" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xr",
      "<cmd>XcodebuildBuildRun<cr>",
      vim.tbl_extend("force", opts, { desc = "Build & Run Project" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xR",
      "<cmd>XcodebuildRun<cr>",
      vim.tbl_extend("force", opts, { desc = "Run Without Building" })
    )

    -- Testing
    vim.keymap.set(
      "n",
      "<localleader>xt",
      "<cmd>XcodebuildTest<cr>",
      vim.tbl_extend("force", opts, { desc = "Run Tests" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xT",
      "<cmd>XcodebuildTestClass<cr>",
      vim.tbl_extend("force", opts, { desc = "Run This Test Class" })
    )
    vim.keymap.set(
      "n",
      "<localleader>x.",
      "<cmd>XcodebuildTestSelected<cr>",
      vim.tbl_extend("force", opts, { desc = "Run Selected Tests" })
    )

    -- Project Management
    vim.keymap.set(
      "n",
      "<localleader>xd",
      "<cmd>XcodebuildSelectDevice<cr>",
      vim.tbl_extend("force", opts, { desc = "Select Device/Simulator" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xs",
      "<cmd>XcodebuildSelectScheme<cr>",
      vim.tbl_extend("force", opts, { desc = "Select Build Scheme" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xp",
      "<cmd>XcodebuildSelectTestPlan<cr>",
      vim.tbl_extend("force", opts, { desc = "Select Test Plan" })
    )

    -- Logs and Output
    vim.keymap.set(
      "n",
      "<localleader>xl",
      "<cmd>XcodebuildToggleLogs<cr>",
      vim.tbl_extend("force", opts, { desc = "Toggle Build Logs" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xL",
      "<cmd>XcodebuildOpenLogs<cr>",
      vim.tbl_extend("force", opts, { desc = "Open Build Logs" })
    )

    -- Code Coverage
    vim.keymap.set(
      "n",
      "<localleader>xc",
      "<cmd>XcodebuildToggleCodeCoverage<cr>",
      vim.tbl_extend("force", opts, { desc = "Toggle Code Coverage" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xC",
      "<cmd>XcodebuildShowCodeCoverageReport<cr>",
      vim.tbl_extend("force", opts, { desc = "Show Code Coverage Report" })
    )

    -- Utilities
    vim.keymap.set(
      "n",
      "<localleader>xq",
      "<cmd>Telescope quickfix<cr>",
      vim.tbl_extend("force", opts, { desc = "Show QuickFix List" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xa",
      "<cmd>XcodebuildCodeActions<cr>",
      vim.tbl_extend("force", opts, { desc = "Show Code Actions" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xu",
      "<cmd>XcodebuildBootSimulator<cr>",
      vim.tbl_extend("force", opts, { desc = "Boot Selected Simulator" })
    )

    -- Project Setup (for new projects)
    vim.keymap.set(
      "n",
      "<localleader>xi",
      "<cmd>XcodebuildInstallApp<cr>",
      vim.tbl_extend("force", opts, { desc = "Install App on Device" })
    )
    vim.keymap.set(
      "n",
      "<localleader>xU",
      "<cmd>XcodebuildUninstallApp<cr>",
      vim.tbl_extend("force", opts, { desc = "Uninstall App from Device" })
    )

    -- Clean and Reset
    vim.keymap.set(
      "n",
      "<localleader>xk",
      "<cmd>XcodebuildCleanProject<cr>",
      vim.tbl_extend("force", opts, { desc = "Clean Project" })
    )

    -- Auto-setup xcode-build-server (detects project type automatically)
    vim.keymap.set("n", "<localleader>xS", function()
      local function run_setup()
        -- Get the current scheme (Gotta select it first with <localleader>xs)
        local scheme = vim.fn.input("Enter scheme name (or press Enter to auto-detect): ")
        if scheme == "" then
          -- Try to auto-detect scheme from project
          local project_files = vim.fn.glob("*.xcodeproj", false, true)
          if #project_files > 0 then
            -- Extract scheme name from project file (usually matches project name)
            scheme = vim.fn.fnamemodify(project_files[1], ":t:r")
          else
            vim.notify("Could not auto-detect scheme. Please enter manually.", vim.log.levels.ERROR)
            return
          end
        end

        -- Check if workspace exists (takes priority)
        local workspace_files = vim.fn.glob("*.xcworkspace", false, true)
        local project_files = vim.fn.glob("*.xcodeproj", false, true)

        local cmd
        if #workspace_files > 0 then
          cmd = string.format("xcode-build-server config -scheme %s -workspace *.xcworkspace", scheme)
          vim.notify("Setting up for workspace project with scheme: " .. scheme, vim.log.levels.INFO)
        elseif #project_files > 0 then
          cmd = string.format("xcode-build-server config -scheme %s -project *.xcodeproj", scheme)
          vim.notify("Setting up for single project with scheme: " .. scheme, vim.log.levels.INFO)
        else
          vim.notify("No .xcodeproj or .xcworkspace found in current directory!", vim.log.levels.ERROR)
          return
        end

        -- Run the command
        vim.fn.system(cmd)
        local exit_code = vim.v.shell_error

        if exit_code == 0 then
          vim.notify("✅ xcode-build-server setup complete! LSP should work now.", vim.log.levels.INFO)
          vim.notify("💡 Restart LSP with :LspRestart if needed", vim.log.levels.INFO)
        else
          vim.notify(
            "❌ Setup failed. Check if xcode-build-server is installed: brew install xcode-build-server",
            vim.log.levels.ERROR
          )
        end
      end

      run_setup()
    end, vim.tbl_extend("force", opts, { desc = "Setup xcode-build-server for LSP" }))
  end,
}
