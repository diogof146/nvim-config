return {
	"apyra/nvim-unity-sync",
	ft = "cs",
	config = function()
		require("unity.plugin").setup()
	end,
}
