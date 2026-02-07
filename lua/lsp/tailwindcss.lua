-- tailwindcss-language-server: Tailwind CSS LSP
-- Provides: class name completions, color previews, hover docs for Tailwind classes

return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"html",
		"htmldjango",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts",
	},

	settings = {
		tailwindCSS = {
			-- Enable features
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},

			-- Class completion
			classAttributes = {
				"class",
				"className",
				"classList",
				"ngClass",
			},

			-- Experimental features
			experimental = {
				classRegex = {
					-- Support for class names in template literals
					"class[:]\\s*['\"`]([^'\"`]*)['\"`]",
				},
			},
		},
	},
}
