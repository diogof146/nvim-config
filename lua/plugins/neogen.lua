-- Neogen - Documentation Generator Configuration
return {
	"danymat/neogen",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Required dependency
	event = "VeryLazy", -- Load after core plugins

	config = function()
		local neogen = require("neogen")

		neogen.setup({
			enabled = true,
			input_after_comment = true, -- Automatically enter insert mode after generating annotation

			-- Languages configuration
			languages = {
				-- Java config - make sure it's properly set for Javadoc
				java = {
					template = {
						annotation_convention = "javadoc",
					},
				},
				-- Add other languages you commonly use
				python = { template = { annotation_convention = "google_docstrings" } },
				lua = { template = { annotation_convention = "emmylua" } },
				-- Add other languages as needed...
			},
		})

		-- Define global keymappings for Neogen
		-- These will work in any supported language file
		vim.keymap.set("n", "<Leader>df", function()
			neogen.generate({ type = "func" })
		end, { desc = "Generate function documentation" })

		vim.keymap.set("n", "<Leader>dc", function()
			neogen.generate({ type = "class" })
		end, { desc = "Generate class documentation" })

		vim.keymap.set("n", "<Leader>dt", function()
			neogen.generate({ type = "type" })
		end, { desc = "Generate type documentation" })

		vim.keymap.set("n", "<Leader>dF", function()
			neogen.generate({ type = "file" })
		end, { desc = "Generate file documentation" })

		-- Integration with JDTLS
		-- Attach Neogen commands to Java files when JDTLS is attached
		local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_neogen", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			group = jdtls_augroup,
			callback = function(args)
				local bufnr = args.buf

				-- Create buffer-local keymappings specifically for Java
				vim.keymap.set("n", "<Leader>nj", function()
					neogen.generate({ type = "func" })
				end, { buffer = bufnr, desc = "Generate Javadoc for function" })

				vim.keymap.set("n", "<Leader>njc", function()
					neogen.generate({ type = "class" })
				end, { buffer = bufnr, desc = "Generate Javadoc for class" })

				-- Add to your existing JDTLS on_attach if you want
				-- This will be called after your existing on_attach function
				local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })
				if #clients > 0 then
					vim.notify("Neogen ready for Java documentation", vim.log.levels.INFO)
				end
			end,
		})

		-- Debug function to test if Neogen is loaded properly
		vim.api.nvim_create_user_command("NeogenDebug", function()
			if neogen then
				vim.notify("Neogen is loaded successfully", vim.log.levels.INFO)

				-- Check current buffer filetype
				local ft = vim.bo.filetype
				vim.notify("Current filetype: " .. ft, vim.log.levels.INFO)

				-- Check if current filetype is supported
				local supported = false
				for lang, _ in pairs(neogen.config.languages) do
					if lang == ft then
						supported = true
						break
					end
				end

				if supported then
					vim.notify("Current filetype is supported by Neogen", vim.log.levels.INFO)
				else
					vim.notify("Current filetype is NOT supported by Neogen", vim.log.levels.WARN)
				end
			else
				vim.notify("Neogen is NOT loaded properly", vim.log.levels.ERROR)
			end
		end, {})
	end,
}
