-- rainbow-delimiters: Color-code matching brackets/parentheses

return {
	"HiPhish/rainbow-delimiters.nvim",

	config = function()
		local rainbow = require("rainbow-delimiters")

		-- Defining Custom Colours
		vim.api.nvim_set_hl(0, "Color1", { fg = "#6FE2ED" })
		vim.api.nvim_set_hl(0, "Color2", { fg = "#7781E0" })
		vim.api.nvim_set_hl(0, "Color3", { fg = "#11CCD6" })
		vim.api.nvim_set_hl(0, "Color4", { fg = "#009BFF" })

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow.strategy["global"],
				vim = rainbow.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			priority = {
				[""] = 110,
			},
			highlight = {
				"Color1",
				"Color2",
				"Color3",
				"Color4",
			},
		}
	end,
}
