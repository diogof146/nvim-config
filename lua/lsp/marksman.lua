-- Marksman: Markdown language server
-- Provides: completions, navigation, link validation for Markdown files

return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".git", ".marksman.toml" },

	-- Marksman has minimal configuration, works well with defaults
}
