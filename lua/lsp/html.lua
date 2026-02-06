-- HTML Language Server

return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "htmldjango" },
	root_markers = { "package.json", ".git" },

	settings = {
		html = {
			format = {
				templating = true, -- Support templating languages (Django, Jinja)
				wrapLineLength = 120,
				wrapAttributes = "auto",
			},
			hover = {
				documentation = true, -- Show MDN docs on hover
				references = true,
			},
			completion = {
				attributeDefaultValue = "doublequotes",
			},
		},
	},
}
