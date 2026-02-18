-- Clangd: C/C++ language server

return {
	cmd = {
		"clangd",
		"--background-index", -- Index project in background for better performance
		"--clang-tidy", -- Enable clang-tidy linting
		"--header-insertion=iwyu", -- Include-what-you-use style header insertion
		"--completion-style=detailed", -- Detailed completion items
		"--function-arg-placeholders", -- Show argument placeholders
		"--fallback-style=llvm", -- Default to LLVM style if no .clang-format
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { "compile_commands.json", ".clangd", ".git" },

	init_options = {
		usePlaceholders = true,
		completeUnimported = true, -- Complete symbols from unimported headers
		clangdFileStatus = true, -- Show file parsing status
	},

	settings = {
		clangd = {
			InlayHints = {
				Designators = true, -- Show struct field names
				Enabled = true,
				ParameterNames = true, -- Show parameter names
				DeducedTypes = true, -- Show auto-deduced types
			},
			-- Default to C++17 when no compile_commands.json exists
			fallbackFlags = { "-std=c++17" },
		},
	},
}
