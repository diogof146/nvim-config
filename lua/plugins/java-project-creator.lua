return {
  'diogof146/java-project-creator.nvim',
  config = function()
    require('java-project-creator').setup({
      -- Optionally customize settings here
      default_java_version = "21",  -- Use your preferred Java version
    })
  end
}

