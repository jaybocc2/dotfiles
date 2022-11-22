local setup = function()
  -- load my libs
  require("jaylib")
  -- load impatient plugin to profile start time
  require("plugins.impatient").setup()
  -- override default vim notification w/ notify plugin
  require("plugins.notify").setup()

  -- bootstrap w/ packages
  require("bootstrap").setup(require("plugins").packages)

  -- load vim options
  require("options").setup()
  -- load globals
  require("globals").setup()
  -- load keybinds
  require("plugins.whichkey").setup()
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
  require("plugins.symbols").setup()
  -- dap
end

return { setup = setup }
