-- SourceKit-LSP: Swift and C-family language server from Apple
-- Provides: completions, diagnostics, refactoring for Swift

return {
	cmd = { "sourcekit-lsp" },
	filetypes = { "swift", "objective-c", "objective-cpp" },
	root_markers = { "Package.swift", ".git" },
}
