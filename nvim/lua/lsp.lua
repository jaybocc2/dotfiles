local function config()
  local config = {
    coc = {
      preferences = {
        snippets = {
          enable = true,
        },
        extenstionUpdateCheck = "daily",
      },
    },
    flutter = {
      provider = {
        enableSnippet = true,
      },
    },

    languageserver = {
      golang = {
        command = "gopls",
        rootPatterns = {"go.mod", ".vim/", ".git/", ".hg/"},
        filetypes = {"go"},
        initializationOptions = {
          gofumpt = true,
          usePlaceholders = true,
        },
      },
      terraform = {
        command = "terraform-ls",
        args = {"serve"},
        filetypes = {"terraform", "tf"},
        initializationOptions = {},
        settings = {},
      },
    },
    go = {
      goplsOptions = {
        gofumpt = true
      },
    },
    python = {
      pythonPath = "cocpython",
      blackPath = "cocblack",
      blackdPath = "cocblackd",
    },
  }
  return config
end

return { config = config }
