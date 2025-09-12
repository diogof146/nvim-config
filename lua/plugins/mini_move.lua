return {
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
      
      -- Setting mappings manually as they weren't being registered properly using mini.move's internal mapping system
      local map = vim.keymap.set
      map('n', '<M-j>', function() require('mini.move').move_line('down') end, {})
      map('n', '<M-k>', function() require('mini.move').move_line('up') end, {})
      map('n', '<M-h>', function() require('mini.move').move_line('left') end, {})
      map('n', '<M-l>', function() require('mini.move').move_line('right') end, {})
      
      map('v', '<M-j>', function() require('mini.move').move_selection('down') end, {})
      map('v', '<M-k>', function() require('mini.move').move_selection('up') end, {})
      map('v', '<M-h>', function() require('mini.move').move_selection('left') end, {})
      map('v', '<M-l>', function() require('mini.move').move_selection('right') end, {})
    end,
  },
}
