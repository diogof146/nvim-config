local M = {}

function M.setup()
	local colors = {
		-- Base colors
		black = "#000000",
		white = "#FFFFFF",
		
		-- Greyscale palette
		grey = "#585858",
		grey_dark = "#1a1a1a",
		grey_light = "#A0A0A0",
		
		-- Primary cyan/teal scheme
		teal = "#007B8A",
		teal_bright = "#00C4D1",
		teal_light = "#3DD8E0",
		cyan = "#00F0FF",
		cyan_light = "#B8F0FF",
		cyan_dark = "#008595",
		turquoise_bright = "#7DE0E8",
		
		-- Supporting colors
		turquoise = "#45C8D1",
		azure = "#00A8EE",
		blue = "#7AC8EB",
		blue_light = "#A8E0FF",
		blue_dark = "#3E69E1",
		mint = "#8BF0FF",
		steel = "#6AA0B8",
		aquamarine = "#70F0D4",
		pale_turquoise = "#A5E8EE",
		light_cyan = "#B0E8FF",
		dark_turquoise = "#1BA8AA",
		medium_aqua = "#5CC8AA",
		steel_blue = "#4080B4",
		electric_cyan = "#00D8FF",
		bright_cyan = "#40C8FF",
		distinct_teal = "#00C8AA",
		variable_blue = "#58A8E2",
		gold = "#FFD700",
		dark_slate = "#2F4F4F",
		red = "#FF6B6B",
		
		-- Background colors
		bg = "NONE",
		bg_dark = "NONE",
		bg_warning = "#102147",
		bg_error = "#2b1211",
		cursor_line = "#052459",
		-- cursor_line = "#0b3135",
		
		-- Foreground colors
		fg = "#B0B0B0",
		fg_dark = "#8B8B8B",
		fg_bright = "#D4D4D4",
		comment = "#6fa0a0",
	}

	local highlights = {
		-- Editor UI elements
		ColorColumn = { bg = colors.teal },
		Conceal = { fg = colors.teal_bright },
		CurSearch = { fg = colors.black, bg = colors.cyan_light, bold = true },
		Cursor = { fg = colors.black, bg = colors.cyan },
		CursorIM = { bg = colors.teal_bright },
		CursorColumn = { bg = colors.grey_dark },
		CursorLine = { bg = colors.cursor_line },
		Directory = { fg = colors.turquoise },

		-- Diff highlighting
		DiffAdd = { fg = colors.black, bg = colors.teal_light },
		DiffChange = { fg = colors.black, bg = colors.cyan },
		DiffDelete = { fg = colors.red },
		DiffText = { fg = colors.black, bg = colors.cyan, bold = true },

		-- Editor marks and messages
		EndOfBuffer = { fg = colors.teal },
		ErrorMsg = { fg = colors.red, bg = colors.bg_error, bold = true },
		VertSplit = { fg = colors.teal },
		Folded = { fg = colors.teal, bg = colors.grey_dark, bold = true },
		FoldColumn = { fg = colors.teal, bold = true },
		SignColumn = {},

		-- Search and selection
		IncSearch = { fg = colors.black, bg = colors.cyan, bold = true },
		LineNr = { fg = colors.teal },
		CursorLineNr = { fg = colors.teal_bright, bold = true },
		MatchParen = { fg = colors.white, bg = colors.grey, bold = true },

		-- Messages and prompts
		ModeMsg = { fg = colors.teal_bright, bold = true },
		MoreMsg = { fg = colors.teal_bright, bold = true },
		NonText = { fg = colors.steel },
		Normal = { fg = colors.fg },

		-- Floating windows
		NormalFloat = { fg = colors.fg, bg = colors.bg_dark },
		FloatBorder = { fg = colors.teal_bright },
		FloatTitle = { fg = colors.teal_bright },

		-- Popup menu
		Pmenu = { fg = colors.cyan, bg = colors.bg_dark },
		PmenuSel = { fg = colors.black, bg = colors.cyan },
		PmenuSbar = {},
		PmenuThumb = { bg = colors.cyan },

		-- UI elements
		Question = { fg = colors.teal_bright, underline = true },
		Search = { fg = colors.black, bg = colors.azure, bold = true },
		SpecialKey = { fg = colors.teal },
		SpellBad = { sp = colors.red, undercurl = true },
		SpellCap = { fg = colors.red, underline = true },
		SpellLocal = { fg = colors.red, underline = true },
		SpellRare = { fg = colors.red, underline = true },

		-- Status line and tabs
		StatusLine = { fg = colors.teal_bright },
		StatusLineNC = { fg = colors.fg_dark },
		TabLine = { fg = colors.fg_dark },
		TabLineFill = { fg = colors.fg_dark },
		TabLineSel = { fg = colors.teal_bright },

		-- Various UI elements
		Title = { fg = colors.mint },
		Visual = { bg = colors.teal, bold = true },
		WarningMsg = { fg = colors.blue_dark, bg = colors.bg_warning, bold = true },
		Whitespace = { fg = colors.steel },
		WildMenu = { fg = colors.cyan },
		WinBar = { fg = colors.turquoise },
		WinBarNC = { fg = colors.steel },

		-- Syntax highlighting
		Comment = { fg = colors.comment, italic = true },
		Constant = { fg = colors.aquamarine },
		String = { fg = colors.cyan_light },
		Number = { fg = colors.distinct_teal },
		PreProc = { fg = colors.teal },
		Include = { fg = colors.cyan },
		Identifier = { fg = colors.blue },
		Function = { fg = colors.dark_turquoise },
		Statement = { fg = colors.turquoise_bright },
		Type = { fg = colors.teal_bright },
		Typedef = { fg = colors.blue_light },
		Special = { fg = colors.mint },
		Underlined = { fg = colors.teal_bright, underline = true },
		Error = { fg = colors.red, underline = true },
		Todo = { fg = colors.gold, bg = colors.dark_slate, bold = true },
		SpecialComment = { fg = colors.steel_blue },

		-- Git integration
		GitGutterAdd = { fg = colors.teal_light, bold = true },
		GitGutterChange = { fg = colors.steel, bold = true },
		GitGutterDelete = { fg = colors.red, bold = true },

		-- LSP highlighting
		LspErrorText = { fg = colors.red },
		LspWarnText = { fg = colors.red },
		LspHintText = { fg = colors.mint },
	}

	-- Set highlights
	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

return M
