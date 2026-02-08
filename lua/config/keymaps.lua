-- General Keybindings
-- Plugin-specific keybindings stay in their respective plugin files

-- Key mappings for indentation in visual mode
-- "<Tab>": Indents the selected text and keeps the selection active
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true }) -- Indent
-- "<S-Tab>": Unindents the selected text and keeps the selection active
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true }) -- Unindent

-- Swapping redo with undo-line for convenience
-- U: Redoes changes
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = true })
-- C-r: Undoes changes in a single line
vim.keymap.set("n", "<C-r>", "U", { desc = "Undo line changes", noremap = true })

-- Swap the functionality of 'b' and 'q' keys in normal mode
-- 'b': Normally moves backward by one word, now used for recording macros
vim.keymap.set("n", "b", "q", { noremap = true })
-- 'q': Normally starts recording macros, now moves backward by one word
vim.keymap.set("n", "q", "b", { noremap = true })

-- Remap gg and G to include start/end of line movements
vim.keymap.set("n", "gg", "gg0", { noremap = true, desc = "Go to first line and start" })
vim.keymap.set("n", "G", "G$", { noremap = true, desc = "Go to last line and end" })

-- Map <Leader>db to open the dashboard
vim.keymap.set("n", "<Leader>db", ":Dashboard<CR>", { noremap = true, silent = true })
-- Map <Leader>b to go to the previous buffer (:bp)
vim.keymap.set("n", "<Leader>b", ":bp<CR>", { noremap = true, silent = true })

-- Making :Q and :W case insensitive because I have fat fingers
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq", { bang = true })
vim.api.nvim_create_user_command("Wqa", "wqa", { bang = true })
vim.api.nvim_create_user_command("WQa", "wqa", { bang = true })
vim.api.nvim_create_user_command("WQA", "wqa", { bang = true })

-- Mapping global word replacement with confirmation
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>//gc<left><left><left>", { noremap = true })

-- Mapping spell check with input spelllang
vim.keymap.set(
	"n",
	"<localleader>s",
	':execute "setlocal spell spelllang=" . input("Enter spelllang: ")<CR>',
	{ noremap = true, silent = true }
)

-- Make delete operations not affect the clipboard
-- The "void register" (_) is used to discard deleted text
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { noremap = true, desc = "Delete to end without yanking" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true, desc = "Delete character without yanking" })
vim.keymap.set("n", "S", '"_cc', { noremap = true, desc = "Substitute line without yanking" })
vim.keymap.set("n", "C", '"_C', { noremap = true, desc = "Change to end without yanking" })
vim.keymap.set("n", "s", '"_s', { noremap = true, desc = "Substitute character without yanking" })

-- Inspect (for themes)
vim.keymap.set("n", "<LocalLeader>i", "<cmd>Inspect<cr>", { desc = "Inspect Highlight" })

-- Reload Theme
vim.keymap.set("n", "<Leader>tr", function()
	package.loaded["themes.my_theme"] = nil
	vim.cmd("colorscheme my_theme")
end, { desc = "Reload Theme" })
