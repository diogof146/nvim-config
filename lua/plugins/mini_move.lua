return {
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
      
      -- Setting mappings manually as they weren't being registered properly using mini.move's internal mapping system
      local map = vim.keymap.set
      map('n', '<C-j>', function() require('mini.move').move_line('down') end, {})
      map('n', '<C-k>', function() require('mini.move').move_line('up') end, {})
      map('n', '<C-h>', function() require('mini.move').move_line('left') end, {})
      map('n', '<C-l>', function() require('mini.move').move_line('right') end, {})
      
      map('v', '<C-j>', function() require('mini.move').move_selection('down') end, {})
      map('v', '<C-k>', function() require('mini.move').move_selection('up') end, {})
      map('v', '<C-h>', function() require('mini.move').move_selection('left') end, {})
      map('v', '<C-l>', function() require('mini.move').move_selection('right') end, {})
    end,
  },
}
