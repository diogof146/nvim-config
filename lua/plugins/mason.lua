-- Mason: Package manager for LSP servers, formatters, linters, and DAP servers

return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup({

			registries = {
				"github:mason-org/mason-registry", -- official registry
				"github:Crashdummyy/mason-registry", -- custom registry
			},
			ui = {
				border = "rounded",
				check_outdated_packages_on_open = true,
			},
		})
	end,
}
