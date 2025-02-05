local colors = {
	-- Base text and background colors - Muted but clear
	Normal = { fg = "#A8C7C7", bg = "None" }, -- Softer base text
	["@punctuation.bracket"] = { fg = "#A8C7C7" },
	["@punctuation.delimiter"] = { fg = "#A8C7C7" },
	["@punctuation.special"] = { fg = "#A8C7C7" },

	-- Core language constants and values - Deeper tones
	Boolean = { fg = "#2CB5B5" }, -- Deep cyan for booleans
	Character = { fg = "#2CB5B5" },
	Comment = { fg = "#567777", italic = true }, -- Muted comments
	Constant = { fg = "#2CB5B5" },

	-- Editor UI elements - Subtle but visible
	CursorLine = { bg = "#1A2A2F" }, -- Darker, less blue background
	CursorLineNr = { fg = "#4AC0C0" }, -- Visible but not bright
	LineNr = { fg = "#406B6B" }, -- Darker line numbers
	LineNrAbove = { fg = "#406B6B" },
	LineNrBelow = { fg = "#406B6B" },
	EndOfBuffer = { fg = "#406B6B" },
	SignColumn = { bg = "None" },
	StatusLine = { fg = "#B8D5D5", bg = "None" },

	-- Syntax highlighting - Deep teals
	Identifier = { fg = "#94B5B5" }, -- Muted identifiers
	Function = { fg = "#4AC0C0" }, -- Clear but not bright functions
	Keyword = { fg = "#269E9E" }, -- Deep teal keywords
	Statement = { fg = "#269E9E" },
	Type = { fg = "#3AAEAE" }, -- Softer types
	String = { fg = "#5CAEAE" }, -- Muted strings
	Number = { fg = "#2CB5B5" }, -- Deep cyan numbers
	Operator = { fg = "#2CB5B5" },
	Special = { fg = "#3AAEAE" },

	-- Tree-sitter specific highlights
	["@variable"] = { fg = "#94B5B5" },
	["@variable.builtin"] = { fg = "#3AAEAE" },
	["@function"] = { fg = "#4AC0C0" },
	["@function.builtin"] = { fg = "#3AAEAE" },
	["@function.call"] = { fg = "#4AC0C0" },
	["@keyword"] = { fg = "#269E9E" },
	["@keyword.function"] = { fg = "#269E9E" },
	["@keyword.return"] = { fg = "#269E9E" },
	["@keyword.operator"] = { fg = "#2CB5B5" },
	["@string"] = { fg = "#5CAEAE" },
	["@number"] = { fg = "#2CB5B5" },
	["@boolean"] = { fg = "#2CB5B5" },
	["@type"] = { fg = "#3AAEAE" },
	["@type.builtin"] = { fg = "#3AAEAE" },
	["@comment"] = { fg = "#567777", italic = true },
	["@variable.member"] = { fg = "#94B5B5" },
	["@constructor"] = { fg = "#3AAEAE" },

	-- Diagnostics - Muted but clear
	DiagnosticError = { fg = "#CC3333" }, -- Softer red
	DiagnosticWarn = { fg = "#CCCC00" }, -- Muted yellow
	DiagnosticInfo = { fg = "#4AC0C0" }, -- Matching theme
	DiagnosticHint = { fg = "#4AC0C0" }, -- Matching theme

	-- Visual selection and search - Subtle but distinct
	Visual = { bg = "#264A4A" }, -- Deep teal background
	Search = { fg = "#000000", bg = "#4AC0C0" }, -- Clear but not harsh
}

-- Clear any existing highlights
vim.cmd("highlight clear")

-- If syntax has been enabled, reset it
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

-- Set colorscheme name
vim.opt.termguicolors = true
vim.g.colors_name = "tealtide"

-- Apply highlight groups
for group, settings in pairs(colors) do
	vim.api.nvim_set_hl(0, group, settings)
end

-- Inspired on https://vimcolorschemes.com/love-pengy/lillilac.nvim
