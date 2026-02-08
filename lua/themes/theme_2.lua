local colors = {
	-- content here will not be touched
	-- PATCH_OPEN
	Normal = { fg = "#E0CFED", bg = "None" },
	["@punctuation.bracket"] = { link = "Normal" },
	["@punctuation.delimiter"] = { link = "Normal" },
	["@punctuation.special"] = { link = "Normal" },
	Boolean = { fg = "#00FFFF" }, -- Teal/Cyan
	Character = { fg = "#00FFFF" }, -- Teal/Cyan
	Comment = { fg = "#66B2B2", italic = true }, -- Light teal for comments
	Conditional = { fg = "#00B3B3" }, -- Teal shade
	["@keyword.conditional"] = { link = "Conditional" },
	Constant = { fg = "#00FFFF" }, -- Teal/Cyan for constants
	CursorLine = { bg = "#003333" }, -- Dark cyan for cursor line
	CursorLineNr = { fg = "#FFFFFF" }, -- Changed to white
	Define = { fg = "#00B3B3" },
	DiagnosticError = { fg = "#FF1A00" }, -- Keep original red for errors
	["@comment.error"] = { link = "DiagnosticError" },
	DiagnosticFloatingError = { fg = "#FF1A00" },
	DiagnosticFloatingHint = { fg = "#00FFFF" }, -- Cyan hint color
	DiagnosticFloatingInfo = { fg = "#00FFFF" }, -- Cyan info color
	DiagnosticFloatingOk = { fg = "#FFFFFF" }, -- Changed to white
	DiagnosticFloatingWarn = { fg = "#B3FF00" }, -- Light yellow warn color
	DiagnosticHint = { fg = "#00FFFF" }, -- Cyan hint
	["@comment.hint"] = { link = "DiagnosticHint" },
	DiagnosticInfo = { fg = "#00FFFF" }, -- Cyan info
	["@comment.info"] = { link = "DiagnosticInfo" },
	DiagnosticOk = { fg = "#FFFFFF" }, -- Changed to white
	DiagnosticSignError = { fg = "#FF1A00" }, -- Keep original red for error
	DiagnosticSignHint = { fg = "#00FFFF" },
	DiagnosticSignInfo = { fg = "#00FFFF" },
	DiagnosticSignOk = { fg = "#FFFFFF" }, -- Changed to white
	DiagnosticSignWarn = { fg = "#B3FF00" }, -- Light yellow warn color
	DiagnosticVirtualTextError = { fg = "#FF1A00" },
	DiagnosticVirtualTextHint = { fg = "#00FFFF" },
	DiagnosticVirtualTextInfo = { fg = "#00FFFF" },
	DiagnosticVirtualTextOk = { fg = "#FFFFFF" }, -- Changed to white
	DiagnosticVirtualTextWarn = { fg = "#B3FF00" },
	DiagnosticWarn = { fg = "#B3FF00" }, -- Light yellow warn color
	["@comment.warning"] = { link = "DiagnosticWarn" },
	EndOfBuffer = { fg = "#FFFFFF" }, -- Changed to white (fixed pink)
	Exception = { fg = "#00B3B3" },
	Float = { fg = "#00FFFF" }, -- Cyan float
	Function = { fg = "#00FFFF" }, -- Cyan for function names
	Identifier = { fg = "#E0CFED" }, -- Keep original light text color
	Include = { fg = "#00B3B3" },
	["@keyword.import"] = { link = "Include" },
	Keyword = { fg = "#00B3B3" }, -- Cyan for keywords
	Label = { fg = "#00B3B3" },
	LineNr = { fg = "#FFFFFF" }, -- Changed to white (fixed pink)
	LineNrAbove = { fg = "#FFFFFF" }, -- Changed to white (fixed pink)
	LineNrBelow = { fg = "#FFFFFF" }, -- Changed to white (fixed pink)
	Macro = { fg = "#00B3B3" },
	ModeMsg = { fg = "#F5B2F0" }, -- Keep original pale purple for mode message
	NormalFloat = { fg = "#E0CFED", bg = "None" }, -- Keep white as it was
	Number = { fg = "#00FFFF" }, -- Cyan number
	Operator = { fg = "#00B3B3" }, -- Cyan operator
	PreCondit = { fg = "#00B3B3" },
	PreProc = { fg = "#00B3B3" },
	Repeat = { fg = "#00B3B3" },
	Search = { fg = "#003333", bg = "#00FFFF" }, -- Cyan search
	SignColumn = { bg = "None" },
	Special = {},
	Statement = { fg = "#00B3B3" }, -- Cyan for statements
	StatusLine = { fg = "#FFFFFF", bg = "None" }, -- Keep white for status line
	StorageClass = { fg = "#00B3B3" },
	String = { fg = "#FFFFFF" }, -- Changed to white
	Structure = { fg = "#00B3B3" },
	Tag = { fg = "#FFFFFF" }, -- Changed to white
	TermCursor = { fg = "#FFFFFF" }, -- Keep white for terminal cursor
	Type = { fg = "#FFFFFF" }, -- Changed to white
	["@type"] = { link = "Type" },
	Typedef = { fg = "#00B3B3" },
	Visual = { fg = "#FFFFFF", bg = "#00FFFF" }, -- Cyan highlight for Visual mode
	["@boolean"] = { fg = "#00FFFF" },
	["@character"] = { fg = "#E0CFED" }, -- Keep original light text color
	["@comment"] = { fg = "#66B2B2", italic = true },
	["@comment.documentation"] = { fg = "#66B2B2", italic = true },
	["@comment.todo"] = { fg = "#FFFFFF", bg = "#00FFFF", bold = true }, -- Cyan todo comments
	["@constant"] = { fg = "#00FFFF" },
	["@constant.builtin"] = { fg = "#00FFFF" },
	["@constant.macro"] = { fg = "#00FFFF" },
	["@float"] = { fg = "#00FFFF" },
	["@function"] = { fg = "#00FFFF" },
	["@function.builtin"] = { fg = "#66B2B2" },
	["@function.call"] = { fg = "#66B2B2" },
	["@function.macro"] = { fg = "#00B3B3" },
	["@keyword"] = { fg = "#00B3B3" },
	["@keyword.coroutine"] = { fg = "#00B3B3" },
	["@keyword.directive"] = { fg = "#66B2B2" },
	["@keyword.directive.define"] = { link = "@keyword.directive" },
	["@keyword.exception"] = { fg = "#66B2B2" },
	["@keyword.function"] = { fg = "#00B3B3" },
	["@keyword.modifier"] = { fg = "#00B3B3" },
	["@keyword.operator"] = { fg = "#66B2B2" },
	["@keyword.repeat"] = { fg = "#00B3B3" },
	["@keyword.return"] = { fg = "#00B3B3" },
	["@keyword.type"] = { fg = "#00B3B3" },
	["@number"] = { fg = "#00FFFF" },
	["@operator"] = { fg = "#00B3B3" },
	["@keyword.conditional.ternary"] = { link = "@operator" },
	["@string"] = { fg = "#FFFFFF" }, -- Changed to white
	["@type.builtin"] = { fg = "#FFFFFF" }, -- Changed to white
	["@type.definition"] = { fg = "#00FFFF" },
	["@variable"] = { fg = "#FFFFFF" }, -- Changed to white
	["@variable.builtin"] = { fg = "#FFFFFF" }, -- Changed to white
	["@variable.member"] = { fg = "#FFFFFF" }, -- Changed to white
	["@variable.parameter"] = { fg = "#FFFFFF" }, -- Changed to white
	["@variable.parameter.builtin"] = { fg = "#FFFFFF" }, -- Changed to white
	-- PATCH_CLOSE
	-- content here will not be touched
}

-- colorschemes generally want to do this
vim.cmd("highlight clear")
vim.cmd("set t_Co=256")
vim.cmd("let g:colors_name='lillilac'")
--[[
vim.api.nvim_set_hl(0, "DiagnosticErrorLn", { bg = "#330000" })
vim.api.nvim_set_hl(0, "DiagnosticWarningLn", { bg = "#727212" })
vim.api.nvim_set_hl(0, "DiagnosticInfoLn", { bg = "#00afaf" })
vim.api.nvim_set_hl(0, "DiagnosticHintLn", { bg = "#00af00" })
--]]
-- apply highlight groups
for group, attrs in pairs(colors) do
	vim.api.nvim_set_hl(0, group, attrs)
end

-- Inspired on https://vimcolorschemes.com/love-pengy/lillilac.nvim
