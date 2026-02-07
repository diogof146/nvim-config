-- OmniSharp: C# language server
-- Provides: completions, diagnostics, refactoring, formatting

return {
	cmd = { "omnisharp" },
	filetypes = { "cs", "vb" },
	root_markers = { "*.sln", "*.csproj", "omnisharp.json", "function.json" },

	settings = {
		FormattingOptions = {
			-- Enable formatting support
			EnableEditorConfigSupport = true,
			OrganizeImports = true,
		},
		RoslynExtensionsOptions = {
			-- Enable analyzers
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
}
