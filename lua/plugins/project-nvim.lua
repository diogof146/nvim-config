-- Project Management Configuration

return {
	"ahmedkhalf/project.nvim",
	config = function()
		require("project_nvim").setup({
			manual_mode = true, -- Only add projects when explicitly told
			detection_methods = { "lsp", "pattern" },
			patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
			ignore_lsp = {},
			exclude_dirs = {},
			show_hidden = false,
			silent_chdir = false,
			scope_chdir = "tab",
			datapath = vim.fn.stdpath("data"),
		})

		require("telescope").load_extension("projects")

		-- Native method to find project root
		local function get_git_root()
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir

			if current_file == "" then
				current_dir = vim.fn.getcwd()
			else
				current_dir = vim.fn.fnamemodify(current_file, ":h")
			end

			-- Look for root markers upwards from the current file
			local root_file = vim.fs.find({ ".git", "pom.xml", "package.json", "Makefile" }, {
				path = current_dir,
				upward = true,
				stop = vim.loop.os_homedir(),
			})[1]

			if root_file then
				-- Return the folder containing the marker
				return vim.fn.fnamemodify(root_file, ":h")
			end

			return nil
		end

		-- <localleader>pa - Add the project
		vim.keymap.set("n", "<localleader>pa", function()
			local root = get_git_root()

			if not root then
				vim.notify("No project root found (no .git/pom.xml/etc)", vim.log.levels.WARN)
				return
			end

			local history_module = require("project_nvim.utils.history")
			local history = history_module.recent_projects

			-- Check duplicates
			for _, p in ipairs(history) do
				if p == root then
					vim.notify("Project already exists: " .. root, vim.log.levels.INFO)
					return
				end
			end

			-- Add to memory and sync to disk
			table.insert(history, 1, root)
			history_module.recent_projects = history
			history_module.write_projects_to_history()

			vim.notify("Added project: " .. root, vim.log.levels.INFO)
		end, { noremap = true, silent = true, desc = "Add Project Root" })
	end,
}
