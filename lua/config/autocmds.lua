-- Autocommands and Quality of Life Features

-- Disabling comment auto insert
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
})

-- Cwd save for Ghostty cmd
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		vim.fn.writefile({ vim.fn.getcwd() }, "/tmp/last_ghostty_cwd")
	end,
})

-- Highlight trailing whitespace
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter", "InsertLeave" }, {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.bo.modifiable then
			vim.fn.clearmatches()
			vim.fn.matchadd("TrailingSpace", [[\s\+$]])
		end
	end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Restore cursor to last position when opening file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- Auto-resize splits when terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- LSP: Highlight references under cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- Clear LSP highlights when entering insert mode
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = false }),
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

-- Auto-enable spell check for Markdown and LaTeX files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "tex" },
	callback = function()
		vim.wo.spell = true
		vim.wo.wrap = true
	end,
})

-- Auto-create directory when saving file if it doesn't exist
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Make 'c' yank to system clipboard and delete without entering insert mode
_G.ChangeNoInsert = function()
	vim.cmd('normal! `[v`]"+y')
	vim.cmd("normal! gvd")
end

vim.keymap.set("n", "c", function()
	vim.o.operatorfunc = "v:lua.ChangeNoInsert"
	return "g@"
end, { expr = true, silent = true })
vim.keymap.set("n", "cc", function()
	local count = vim.v.count1
	vim.cmd('normal! "+y' .. count .. "y")
	vim.cmd("normal! " .. count .. "dd")
end, { silent = true })
vim.keymap.set("n", "C", '"+y$d$', { silent = true })
vim.keymap.set("x", "c", '"+ygvd', { silent = true })
