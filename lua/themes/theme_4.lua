local M = {}

function M.setup()
	-- Define all colors used in the theme
	local colors = {
		-- Base colors
		black = "#000000",
		white = "#FFFFFF",

		-- Greyscale palette
		grey = "#585858", -- Dark grey to reduce white prominence
		grey_dark = "#1a1a1a", -- Darker grey for better contrast
		grey_light = "#A0A0A0", -- Lighter grey for some readability

		-- Main color scheme
		teal = "#006F6F", -- Darker teal for better contrast
		teal_bright = "#00CED1", -- Bright teal (cyan)
		teal_light = "#40E0D0", -- Turquoise
		cyan = "#00FFFF", -- Pure cyan
		cyan_light = "#C0FFFF", -- Darker light cyan for better contrast
		cyan_dark = "#008B8B", -- Dark cyan (unchanged)

		-- Supporting colors
		turquoise = "#48D1CC", -- Medium turquoise
		azure = "#00B2EE", -- Deep azure
		blue = "#87CEEB", -- Sky blue
		blue_light = "#B0E2FF", -- Light blue
		blue_dark = "#4169E1", -- Royal blue with slight purple tinge
		mint = "#98F5FF", -- Mint color
		steel = "#6CA6A8", -- Steel blue, brighter for contrast
		red = "#FF6B6B", -- Error color

		-- Background colors
		bg = "NONE", -- Transparency for terminal background
		bg_dark = "NONE", -- Transparency
		bg_warning = "#102147", -- Slightly darkened blue
		bg_error = "#2b1211", -- Error background

		-- Foreground colors
		fg = "#B0B0B0", -- Reduced white (lighter grey with teal hint)
		fg_dark = "#8B8B8B", -- Dimmed text (lightened slightly with teal hint)

		-- Lighter foreground color for better readability
		fg_bright = "#D4D4D4", -- Slightly brighter grey for more contrast
	}

	-- Highlight groups with updated contrast
	local highlights = {
		-- Editor UI elements
		ColorColumn = { bg = colors.teal }, -- Highlighted column for guides
		Conceal = { fg = colors.teal_bright }, -- Hidden text (conceal feature)
		CurSearch = { fg = colors.black, bg = colors.cyan_light, bold = true }, -- Search highlight
		Cursor = { fg = colors.black, bg = colors.cyan }, -- Cursor styling
		CursorIM = { bg = colors.teal_bright }, -- Cursor in Insert Mode
		CursorColumn = { bg = colors.grey_dark }, -- Highlighted column where the cursor is
		CursorLine = { bg = "#12272b" }, -- Highlight the current line
		Directory = { fg = colors.turquoise }, -- Color for directories

		-- Diff highlighting
		DiffAdd = { fg = colors.black, bg = colors.teal_light }, -- Added lines in diff
		DiffChange = { fg = colors.black, bg = colors.cyan }, -- Changed lines in diff
		DiffDelete = { fg = colors.red }, -- Deleted lines in diff
		DiffText = { fg = colors.black, bg = colors.cyan, bold = true }, -- Highlighted text in diff

		-- Editor marks and messages
		EndOfBuffer = { fg = colors.teal }, -- Styling for the end-of-buffer marker
		ErrorMsg = { fg = colors.red, bg = colors.bg_error, bold = true }, -- Error message styling
		VertSplit = { fg = colors.teal }, -- Vertical split line
		Folded = { fg = colors.teal, bg = colors.grey_dark, bold = true }, -- Folded text
		FoldColumn = { fg = colors.teal, bold = true }, -- Column for folded lines
		SignColumn = {}, -- Column for signs (e.g., diagnostics, git changes)

		-- Search and selection
		IncSearch = { fg = colors.black, bg = colors.cyan, bold = true }, -- Incremental search
		LineNr = { fg = colors.teal }, -- Line numbers (removed bg for transparency)
		CursorLineNr = { fg = colors.teal_bright, bold = true }, -- Current line number
		MatchParen = { fg = colors.white, bg = colors.grey, bold = true }, -- Matching parentheses

		-- Messages and prompts
		ModeMsg = { fg = colors.teal_bright, bold = true }, -- Mode message (e.g., -- INSERT --)
		MoreMsg = { fg = colors.teal_bright, bold = true }, -- More messages (e.g., pagination)
		NonText = { fg = colors.steel }, -- Non-text characters
		Normal = { fg = colors.fg }, -- Normal text (removed bg for transparency)

		-- Floating windows
		NormalFloat = { fg = colors.fg, bg = colors.bg_dark }, -- Floating window text
		FloatBorder = { fg = colors.teal_bright }, -- Border for floating windows
		FloatTitle = { fg = colors.teal_bright }, -- Title for floating windows

		-- Popup menu
		Pmenu = { fg = colors.cyan, bg = colors.bg_dark }, -- Popup menu
		PmenuSel = { fg = colors.black, bg = colors.cyan }, -- Selected item in popup menu
		PmenuSbar = {}, -- Scrollbar in popup menu
		PmenuThumb = { bg = colors.cyan }, -- Thumb in popup scrollbar

		-- UI elements
		Question = { fg = colors.teal_bright, underline = true }, -- Questions in prompts
		Search = { fg = colors.black, bg = colors.azure, bold = true }, -- Search highlight
		SpecialKey = { fg = colors.teal }, -- Special keys
		SpellBad = { sp = colors.red, undercurl = true }, -- Spelling mistakes
		SpellCap = { fg = colors.red, underline = true }, -- Capitalization issues
		SpellLocal = { fg = colors.red, underline = true }, -- Spelling in local context
		SpellRare = { fg = colors.red, underline = true }, -- Rare word usage

		-- Status line and tabs
		StatusLine = { fg = colors.teal_bright }, -- Active status line (removed bg for transparency)
		StatusLineNC = { fg = colors.fg_dark }, -- Inactive status line (removed bg for transparency)
		TabLine = { fg = colors.fg_dark }, -- Tab line (removed bg for transparency)
		TabLineFill = { fg = colors.fg_dark }, -- Fill in tab line
		TabLineSel = { fg = colors.teal_bright }, -- Selected tab (removed bg for transparency)

		-- Various UI elements
		Title = { fg = colors.mint }, -- Title text
		Visual = { bg = colors.teal, bold = true }, -- Visual selection
		WarningMsg = { fg = colors.blue_dark, bg = colors.bg_warning, bold = true }, -- Warnings
		Whitespace = { fg = colors.steel }, -- Whitespace characters
		WildMenu = { fg = colors.cyan }, -- Wild menu
		WinBar = { fg = colors.turquoise }, -- Active window bar
		WinBarNC = { fg = colors.steel }, -- Inactive window bar

		-- Syntax highlighting
		Comment = { fg = "#6fa0a0", italic = true }, -- Comments
		Constant = { fg = colors.mint }, -- Constants
		String = { fg = colors.cyan_light }, -- Strings
		Number = { fg = colors.blue_dark }, -- Numbers
		PreProc = { fg = colors.teal }, -- Preprocessor directives
		Include = { fg = colors.cyan }, -- Include statements
		Identifier = { fg = colors.blue }, -- Variables
		Function = { fg = "#00B3B3" }, -- Functions
		Statement = { fg = colors.azure }, -- Statements
		Type = { fg = colors.azure }, -- Types
		Typedef = { fg = colors.blue_light }, -- Typedefs
		Special = { fg = colors.mint }, -- Special identifiers
		Underlined = { fg = colors.teal_bright, underline = true }, -- Underlined text
		Error = { fg = colors.red, underline = true }, -- Errors
		Todo = { fg = colors.cyan, bold = true }, -- TODO comments (removed bg for transparency)
		SpecialComment = { fg = colors.steel }, -- Special comments

		-- Git integration
		GitGutterAdd = { fg = colors.teal_light, bold = true }, -- Added lines in Git
		GitGutterChange = { fg = colors.steel, bold = true }, -- Changed lines in Git
		GitGutterDelete = { fg = colors.red, bold = true }, -- Deleted lines in Git

		-- LSP highlighting
		LspErrorText = { fg = colors.red }, -- LSP error text
		LspWarnText = { fg = colors.red }, -- LSP warning text
		LspHintText = { fg = colors.mint }, -- LSP hints
	}

	-- Set highlights
	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

return M

-- Inspired on https://vimcolorschemes.com/hachy/eva01.vim
