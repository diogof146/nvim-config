-- Enhanced Statusline for Neovim with Custom Styling
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Fix the gap issue
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 3 -- Global statusline

    -- Toggle lualine function
    local lualine_visible = true
    local function toggle_lualine()
      if lualine_visible then
        vim.opt.laststatus = 0
        lualine_visible = false
        print("Lualine hidden")
      else
        vim.opt.laststatus = 3
        lualine_visible = true
        print("Lualine shown")
      end
    end

    -- Set up the toggle keybind
    vim.keymap.set("n", "<leader>ll", toggle_lualine, { desc = "Toggle lualine" })

    -- Function to shorten file paths like in your screenshot
    local function shorten_path()
      local path = vim.fn.expand("%:p")
      local filename = vim.fn.expand("%:t")

      if path == "" or filename == "" then
        return "[No Name]"
      end

      -- Get relative path from cwd
      local relative_path = vim.fn.expand("%:~:.")

      -- If path is too long, show only filename and one parent
      if string.len(relative_path) > 35 then
        local parent = vim.fn.expand("%:h:t")
        if parent ~= "." and parent ~= "" then
          return parent .. "/" .. filename
        else
          return filename
        end
      end

      return relative_path
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        -- Clean separators
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
        },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1) -- Show only first letter of mode
            end,
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { fg = "#40E0D0" }, -- Using your teal_light color
            padding = { left = 1, right = 1 },
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = "#00CED1" }, -- teal_bright
              modified = { fg = "#48D1CC" }, -- turquoise
              removed = { fg = "#FF6B6B" }, -- red
            },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_c = {
          {
            shorten_path, -- Custom shortened path function
            file_status = true,
            newfile_status = false,
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
            color = { fg = "#B0E2FF" }, -- light blue from your theme
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic", "nvim_lsp" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = "󰌵 ",
            },
            diagnostics_color = {
              error = { fg = "#FF6B6B" }, -- red
              warn = { fg = "#87CEEB" }, -- blue
              info = { fg = "#98F5FF" }, -- mint
              hint = { fg = "#00CED1" }, -- teal_bright
            },
            padding = { left = 1, right = 1 },
          },
          {
            "filetype",
            colored = true,
            icon_only = false,
            icon = { align = "right" },
            color = { fg = "#00FFFF" }, -- cyan
            padding = { left = 1, right = 1 },
          },
        },
        lualine_y = {
          {
            "progress",
            fmt = function()
              return "%P"
            end,
            color = { fg = "#6CA6A8" }, -- steel
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          {
            "location",
            fmt = function(str)
              return str:gsub("^%s*(.-)%s*$", "%1")
            end,
            color = { fg = "#000000" }, -- black
            padding = { left = 1, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            shorten_path,
            file_status = true,
            color = { fg = "#8B8B8B" }, -- dimmed
          },
        },
        lualine_x = {
          {
            "location",
            color = { fg = "#8B8B8B" },
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "nvim-tree", "toggleterm", "quickfix", "lazy" },
    })
  end,
}
