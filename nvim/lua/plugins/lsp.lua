return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      ---@type lspconfig.options
      servers = {
        ts_ls = {
          enabled = true,
        },
        -- gopls = {},
        -- pyright = {},
        -- terraformls = {},
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    ---@class PluginLspOpts
    opts = {
      disable_max_lines = 25000,
    },
  },
}
