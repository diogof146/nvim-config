return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		local surround = require("nvim-surround")
		surround.setup({
			-- Keep default configuration here
		})

		vim.keymap.set("n", "<leader>s", "ysiw", { remap = true, silent = true }) -- Shortcut to select one word
		vim.keymap.set("n", "<leader>S", "ys$", { remap = true, silent = true }) -- Shortcut to select to the end of the line
	end,
}

-- Base keybinds:
-- keymaps = {
-- insert = "<C-g>s",
-- insert_line = "<C-g>S",
-- normal = "ys",
-- normal_cur = "yss",
-- normal_line = "yS",
-- normal_cur_line = "ySS",
-- visual = "S",
-- visual_line = "gS",
-- delete = "ds",
-- change = "cs",
-- change_line = "cS",

-- Example:
--     Old text                    Command         New text
-- --------------------------------------------------------------------------------
--     surr*ound_words             ysiw)           (surround_words)
--     *make strings               ys$"            "make strings"
--     [delete ar*ound me!]        ds]             delete around me!
--     remove <b>HTML t*ags</b>    dst             remove HTML tags
--     'change quot*es'            cs'"            "change quotes"
--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
--     delete(functi*on calls)     dsf             function calls
