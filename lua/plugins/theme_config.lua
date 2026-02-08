-- Neovim Color Scheme Setup

return {
	dir = vim.fn.stdpath("config") .. "/lua/themes", -- Theme directory

	name = "my_theme",

	priority = 1000, -- High priority ensures theme loads early

	config = function()
		vim.cmd("colorscheme my_theme")
		-- local ok, theme = pcall(require, "/themes/theme_4")
		-- if ok then
		-- 	theme.setup()
		-- else
		-- 	vim.notify("Could not load theme: " .. theme, vim.log.levels.WARN)
		-- end
	end,
}
