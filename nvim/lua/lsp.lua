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

    go = {
      goplsOptions = {
        gofumpt = true
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

    java = {
      home = '/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home',
      configuration = {
        runtimes = {
          {
            name = 'Corretto-8',
            path = '/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home',
            default = true
          }
        }
      }
    },

    python = {
      pythonPath = "cocpython",
      blackPath = "cocblack",
      blackdPath = "cocblackd",
    },
    -- rust = {
    -- },

    ["sumneko-lua.enableNvimLuaDev"] = true,
  }
  return config
end

return { config = config }
