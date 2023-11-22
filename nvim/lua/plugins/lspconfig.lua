return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "bashls",
        "flake8",
        -- "gopls",
        -- "gradle_ls",
        -- "groovyls",
        -- "jsonls",
        -- "lua_ls",
        "marksman",
        "misspell",
        -- "prosemd_lsp",
        "protolint",
        -- "pylint8",
        -- "pyright",
        -- "rust_analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        -- "terraformls",
        -- "tsserver",
        -- "yamlls",
      },
    },
  },

  -- extend treesitter config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add terraform to treesitter
      vim.list_extend(opts.ensure_installed, {
        "terraform",
      })
    end,
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- gopls = {},
        pyright = {},
        terraformls = {},
      },
    },
  },
}
