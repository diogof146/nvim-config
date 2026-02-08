package.loaded["themes.my_theme"] = nil
vim.cmd("highlight clear")
vim.cmd("set termguicolors")
vim.g.colors_name = "my_theme"

require("lush")(require("themes.my_theme"))
