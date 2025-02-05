-- Define custom theme colors with swapped color scheme and adjustments
local colors = {
	background = "#101010", -- Slightly lighter than fully black
	foreground = "#F9F9F9", -- Light white/gray for foreground text
	comment = "#9B6BFF", -- Bright purple for comments (also used for class names like 'Ball')
	constant = "#B55FB2", -- Muted purple for constants (e.g., pygame.K_a)
	string = "#FF79C6", -- Light pink for strings
	identifier = "#00A4A6", -- Teal for identifiers
	keyword = "#7FDBFF", -- Teal/cyan for keywords like `if`, `not`
	function_def = "#00B5B8", -- Dark cyan for 'def' keyword
	conditional = "#9E59B6", -- Purple for conditional keywords like 'if'
	loop_keyword = "#FFCC66", -- Light yellow for loop keywords ('for', 'while')
	in_keyword = "#FF73FA", -- Light purple for 'in' keyword
	preproc = "#5FB2B2", -- Light teal for preprocessor
	type = "#808080", -- Light gray for types
	special = "#66D9EF", -- Light blue for special keywords
	todo = "#98C6B8", -- Light cyan for TODOs
	search_bg = "#7FDBFF", -- Light teal background for search
	search_fg = "#333333", -- Dark foreground for search
	incsearch_bg = "#FF79C6", -- Purple background for incremental search
	incsearch_fg = "#FFFFFF", -- White foreground for incremental search
	cursorline = "#2e2e2e", -- Darker background for cursor line
	line_nr = "#808080", -- Light gray for line numbers
}

-- Set background color for Neovim
vim.cmd("set background=dark")

-- Function to apply highlight groups
local function highlight(group, fg, bg, attr)
	local cmd = string.format("highlight %s guifg=%s guibg=%s", group, fg, bg)
	if attr then
		cmd = cmd .. " gui=" .. attr
	end
	vim.cmd(cmd)
end

-- Basic highlights with swapped colors and adjustments...
highlight("Normal", colors.foreground, colors.background)
highlight("Comment", colors.comment, colors.background) -- Comments now use class color
highlight("Constant", colors.constant, colors.background)
highlight("String", colors.string, colors.background)
highlight("Identifier", colors.identifier, colors.background)
highlight("PreProc", colors.preproc, colors.background)
highlight("Type", colors.type, colors.background)
highlight("Special", colors.special, colors.background)
highlight("Todo", colors.todo, colors.background)
highlight("Search", colors.search_fg, colors.search_bg)
highlight("IncSearch", colors.incsearch_fg, colors.incsearch_bg)
highlight("CursorLine", colors.foreground, colors.cursorline, "underline")
highlight("LineNr", colors.line_nr, colors.background)
highlight("CursorLineNr", colors.foreground, colors.background)

-- TreeSitter specific highlights with adjusted colors
highlight("@keyword.function", colors.function_def, colors.background) -- For 'def' keyword
highlight("@keyword.conditional", colors.conditional, colors.background) -- For 'if', 'else', etc.
highlight("@keyword.loop", colors.loop_keyword, colors.background) -- For loop keywords ('for', 'while')
highlight("@keyword", colors.keyword, colors.background) -- For other keywords

-- Additional TreeSitter groups for better Python support
highlight("@function", colors.identifier, colors.background) -- Function names
highlight("@variable", colors.identifier, colors.background) -- Variables
highlight("@constant", colors.constant, colors.background) -- Constants
highlight("@string", colors.string, colors.background) -- Strings
highlight("@type", colors.type, colors.background) -- Types
highlight("@conditional", colors.conditional, colors.background) -- Conditional statements
highlight("@loop", colors.loop_keyword, colors.background) -- Loop statements

-- Handling the 'in' keyword
highlight("TSKeyword", colors.in_keyword, colors.background) -- 'in' keyword now has a unique color

-- Legacy groups (keep these for compatibility)
highlight("TSKeywordFunction", colors.function_def, colors.background)
highlight("TSKeyword", colors.keyword, colors.background)
highlight("TSConditional", colors.conditional, colors.background)
highlight("TSFunction", colors.identifier, colors.background)
highlight("TSVariable", colors.identifier, colors.background)
highlight("TSConstant", colors.constant, colors.background)
highlight("TSString", colors.string, colors.background)
highlight("TSType", colors.type, colors.background)

-- Set cursor style
vim.cmd("set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20")

-- Enable highlight for the current line
vim.opt.cursorline = true

-- Set up number settings
vim.opt.number = true
vim.opt.relativenumber = true
