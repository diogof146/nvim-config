-- Neovim Color Scheme Setup

return {
	dir = vim.fn.stdpath("config") .. "/lua", -- Theme directory

	name = "theme_5", -- Theme name

	priority = 1000, -- High priority ensures theme loads early

	config = function()
		-- Use a protected call (`pcall`) to load the theme safely.
		local ok, theme = pcall(require, "theme_5")

		if ok then
			theme.setup() -- Set up the theme's configuration
		else
			-- If the theme couldn't be loaded, show a warning message with the error.
			vim.notify("Could not load theme: " .. theme, vim.log.levels.WARN)
		end
	end,
}
