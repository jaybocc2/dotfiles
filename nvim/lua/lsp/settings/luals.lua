local opts = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = {
          'vim'
        }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
}

return opts
