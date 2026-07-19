return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	opts = {

		filewatching = "roslyn",

		-- Automatically pick the Unity project .sln
		-- Falls back to a picker prompt if it can't decide.
		choose_target = function(targets)
			-- If only one .sln exists, use it directly (common case for Unity)
			if #targets == 1 then
				return targets[1]
			end
			-- Otherwise prefer the one that is NOT Assembly-CSharp.sln
			return vim.iter(targets):find(function(t)
				return not string.match(t, "Assembly%-CSharp")
			end)
		end,

		-- Search parent directories for .sln files.
		broad_search = true,
		lock_target = true,
	},

	config = function(_, opts)
		require("roslyn").setup(opts)

		-- LSP server-level settings (sent to the Roslyn server itself, not the plugin)
		vim.lsp.config("roslyn", {
			settings = {
				-- Completions
				["csharp|completion"] = {
					dotnet_provide_regex_completions = true,
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
				-- Inlay hints (toggle with <leader>ih)
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
					csharp_enable_inlay_hints_for_types = true,
					dotnet_enable_inlay_hints_for_indexer_parameters = true,
					dotnet_enable_inlay_hints_for_literal_parameters = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
					dotnet_enable_inlay_hints_for_other_parameters = true,
					dotnet_enable_inlay_hints_for_parameters = true,
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				},
				-- Code lens (shows reference counts above methods etc.)
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
				-- Analysis scope: "openFiles" is fast; use "fullSolution" for
				-- errors across the whole project
				["csharp|background_analysis"] = {
					dotnet_analyzer_diagnostics_scope = "openFiles",
					dotnet_compiler_diagnostics_scope = "openFiles",
				},
				-- Formatting
				["csharp|formatting"] = {
					dotnet_organize_imports_on_format = true,
					csharp_new_line_before_open_brace = "none",
				},
			},

			-- Auto-create .editorconfig with K&R brace style at the Unity project root
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "cs",
				once = true,
				callback = function()
					local sln = vim.fs.find(function(name)
						return name:match("%.sln$")
					end, { upward = true, type = "file" })[1]

					if not sln then
						return
					end

					local root = vim.fs.dirname(sln)
					local editorconfig = root .. "/.editorconfig"

					if vim.fn.filereadable(editorconfig) == 0 then
						local f = io.open(editorconfig, "w")
						if f then
							f:write("root = true\n\n[*.cs]\ncsharp_new_line_before_open_brace = none\n")
							f:close()
							vim.notify(".editorconfig created at " .. root, vim.log.levels.INFO)
						end
					end
				end,
			}),
		})
	end,
}
