-- local function options()
--     vim.api.nvim_set_var("python3_host_prog", vim.fn.expand("~/.pyenv/versions/neovim3/bin/python"))
--
--     -- coc vars
--     vim.api.nvim_set_var("coc_global_extensions", {
--         -- 'coc-flutter',
--         "coc-git",
--         "coc-go",
--         "coc-sumneko-lua",
--         "coc-markdownlint",
--         "coc-pyright",
--         "coc-rust-analyzer",
--         "coc-snippets",
--         "coc-tsserver",
--         "coc-eslint",
--     })
--     vim.api.nvim_set_var("coc_user_config", require("lsp").config())
--     vim.api.nvim_set_var("coc_snippet_next", "<tab>")
-- end

local setup = function()
  -- load my libs
  require("jaylib")
  -- load impatient plugin to profile start time
  require("plugins.impatient").setup()
  -- override default vim notification w/ notify plugin
  require("plugins.notify").setup()

  -- load packages
  local plugins = require("plugins")
  -- bootstrap w/ packages
  require("bootstrap").setup(plugins.packages)
  -- require("bootstrap").setup(require("plugins").packages)

  -- load vim options
  require("options").setup()
  -- load globals
  require("globals").setup()
  -- load keybinds
  require("keybinds").setup()
  -- load custom commands
  require("commands").setup()

  require("plugins.cmp").setup()
  require("plugins.inlayhints").setup()
  require("lsp").setup()
  require("plugins.telescope").setup()
  require("plugins.treesitter").setup()
  require("plugins.comment").setup()
  require("plugins.gitsigns").setup()
  -- autopairs
  require("plugins.nvim-tree").setup()
  require("plugins.bufferline").setup()
  require("plugins.lualine").setup()
  -- toggleterm
  require("plugins.project").setup()
  require("plugins.illuminate").setup()
  require("plugins.indentline").setup()
  require("plugins.alpha").setup()
  -- dap
end

return { setup = setup }
