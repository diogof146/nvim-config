-- Neovim Color Scheme Setup

return {
	dir = vim.fn.stdpath("config") .. "/lua", -- Theme directory

	name = "theme_5",

	priority = 1000, -- High priority ensures theme loads early

	config = function()
		local ok, theme = pcall(require, "theme_5")

		if ok then
			theme.setup()
		else

			vim.notify("Could not load theme: " .. theme, vim.log.levels.WARN)
		end
	end,
}
