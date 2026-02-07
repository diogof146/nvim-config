-- nvim-treesitter-textobjects: Smart code text objects

return {
	"nvim-treesitter/nvim-treesitter-textobjects",

	dependencies = { "nvim-treesitter/nvim-treesitter" },

	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				enable = true,
				lookahead = true,
			},
			move = {
				enable = true,
				set_jumps = true,
			},
		})

		local function map(mode, keys, query, desc, ts_func)
			if mode == "x" then
				vim.keymap.set({ mode, "o" }, keys, function()
					ts_func.select_textobject(query, "textobjects")
				end, { desc = desc })
			elseif mode == "n" then
				local direction = desc:match("^%S+") -- Get first word (Next/Previous)
				local is_end = desc:lower():match("end$") -- Check if desc ends with "end"

				if direction == "Next" then
					if is_end then
						vim.keymap.set({ mode, "o" }, keys, function()
							ts_func.goto_next_end(query, "textobjects")
						end, { desc = desc })
					else
						vim.keymap.set({ mode, "o" }, keys, function()
							ts_func.goto_next_start(query, "textobjects")
						end, { desc = desc })
					end
				else -- Previous
					if is_end then
						vim.keymap.set({ mode, "o" }, keys, function()
							ts_func.goto_previous_end(query, "textobjects")
						end, { desc = desc })
					else
						vim.keymap.set({ mode, "o" }, keys, function()
							ts_func.goto_previous_start(query, "textobjects")
						end, { desc = desc })
					end
				end
			end
		end

		-- Keymaps
		local ts_select = require("nvim-treesitter-textobjects.select")
		local ts_move = require("nvim-treesitter-textobjects.move")

		-- Select
		-- Functions
		map("x", "af", "@function.outer", "Select outer function", ts_select)
		map("x", "if", "@function.inner", "Select inner function", ts_select)

		-- Parameters
		map("x", "aa", "@parameter.outer", "Select outer parameter", ts_select)
		map("x", "ia", "@parameter.inner", "Select inner parameter", ts_select)

		-- Conditionals
		map("x", "ac", "@conditional.outer", "Select outer conditional", ts_select)
		map("x", "ic", "@conditional.inner", "Select inner conditional", ts_select)

		-- Loops
		map("x", "al", "@loop.outer", "Select outer loop", ts_select)
		map("x", "il", "@loop.inner", "Select inner loop", ts_select)

		-- Blocks
		map("x", "ab", "@block.outer", "Select outer block", ts_select)
		map("x", "ib", "@block.inner", "Select inner block", ts_select)

		-- Function Calls
		map("x", "ak", "@call.outer", "Select outer function call", ts_select)
		map("x", "ik", "@call.inner", "Select inner function call", ts_select)

		-- Assignments
		map("x", "a=", "@assignment.outer", "Select outer assignment", ts_select)
		map("x", "i=", "@assignment.inner", "Select inner assignment", ts_select)

		-- Returns
		map("x", "ar", "@return.outer", "Select outer return", ts_select)
		map("x", "ir", "@return.inner", "Select inner return", ts_select)

		-- Attributes / Decorators
		map("x", "a@", "@attribute.outer", "Select outer attribute", ts_select)
		map("x", "i@", "@attribute.inner", "Select inner attribute", ts_select)

		-- Misc (Numbers, Statements)
		map("x", "in", "@number.inner", "Select inner number", ts_select)
		map("x", "as", "@statement.outer", "Select outer statement", ts_select)

		-- Move
		-- Functions / Methods
		map("n", "<Leader>jf", "@function.outer", "Next function start", ts_move)
		map("n", "<Leader>kf", "@function.outer", "Previous function start", ts_move)
		map("n", "<Leader>jF", "@function.outer", "Next function end", ts_move)
		map("n", "<Leader>kF", "@function.outer", "Previous function end", ts_move)

		-- Conditionals (if/else/switch)
		map("n", "<Leader>jc", "@conditional.outer", "Next conditional start", ts_move)
		map("n", "<Leader>kc", "@conditional.outer", "Previous conditional start", ts_move)
		map("n", "<Leader>jC", "@conditional.outer", "Next conditional end", ts_move)
		map("n", "<Leader>kC", "@conditional.outer", "Previous conditional end", ts_move)

		-- Loops (for/while)
		map("n", "<Leader>jl", "@loop.outer", "Next loop start", ts_move)
		map("n", "<Leader>kl", "@loop.outer", "Previous loop start", ts_move)
		map("n", "<Leader>jL", "@loop.outer", "Next loop end", ts_move)
		map("n", "<Leader>kL", "@loop.outer", "Previous loop end", ts_move)

		-- Parameters/Arguments
		map("n", "<Leader>ja", "@parameter.inner", "Next parameter start", ts_move)
		map("n", "<Leader>ka", "@parameter.inner", "Previous parameter start", ts_move)

		-- Return statements
		map("n", "<Leader>jr", "@return.outer", "Next return start", ts_move)
		map("n", "<Leader>kr", "@return.outer", "Previous return start", ts_move)
		map("n", "<Leader>jR", "@return.outer", "Next return end", ts_move)
		map("n", "<Leader>kR", "@return.outer", "Previous return end", ts_move)
	end,
}
