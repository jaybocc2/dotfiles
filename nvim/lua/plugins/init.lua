local treesitter_run = function()
  local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
  ts_update()
end

local packages = {
  -- template
  -- { '' }, -- description - https://github.com/

  -- core / general plugins
  { "wbthomason/packer.nvim" }, -- the neovim package manger we are using here - https://github.com/wbthomason/packer.nvim
  { "nvim-lua/plenary.nvim" }, -- helpful lua library - used by many plugins - https://github.com/nvim-lua/plenary.nvim
  { "lewis6991/impatient.nvim" }, -- faster neovim load times - https://github.com/lewis6991/impatient.nvim

  -- syntax / treesitter
  { "windwp/nvim-autopairs" }, -- automatic pairs IE quoting, parens, etc. - https://github.com/windwp/nvim-autopairs
  { "numToStr/Comment.nvim", requires = { "nvim-treesitter/nvim-treesitter" } }, -- commenting plugin - https://github.com/numToStr/Comment.nvim
  { "JoosepAlviste/nvim-ts-context-commentstring", requires = { "nvim-treesitter/nvim-treesitter" } }, -- context aware comment plugin (ie, mixed language comments, - https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  { "nvim-treesitter/nvim-treesitter", run = treesitter_run }, -- treesitter configurations and abstraction layer - https://github.com/nvim-treesitter/nvim-treesitter
  { "p00f/nvim-ts-rainbow", requires = { "nvim-treesitter/nvim-treesitter" } }, -- rainbow colors for nested brackets/braces etc - https://github.com/p00f/nvim-ts-rainbow
  { "kylechui/nvim-surround", requires = { "nvim-treesitter/nvim-treesitter" } }, -- macro's for wrapping text w/ arbitrary text/symbols etc - https://github.com/kylechui/nvim-surround
  { "folke/todo-comments.nvim" }, -- highlight / search TODO comments - https://github.com/folke/todo-comments.nvim
  { "lewis6991/gitsigns.nvim" }, -- git integration - https://github.com/lewis6991/gitsigns.nvim
  { "lukas-reineke/indent-blankline.nvim" }, -- tabs/spaces indent indicators - https://github.com/lukas-reineke/indent-blankline.nvim

  -- UI/UX
  { "nvim-tree/nvim-web-devicons" }, -- unicode text/icon plugin - https://github.com/nvim-tree/nvim-web-devicons
  { "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" }, tag = "nightly" }, -- file tree plugin - https://github.com/nvim-tree/nvim-tree.lua
  { "akinsho/bufferline.nvim" }, -- buffer line/tab plugin - https://github.com/akinsho/bufferline.nvim
  { "moll/vim-bbye" }, -- impvoed vim buffer management - https://github.com/moll/vim-bbye
  { "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons" } }, -- vim status line - https://github.com/nvim-lualine/lualine.nvim
  { "akinsho/toggleterm.nvim" }, -- pop open a terminal in nvim - https://github.com/akinsho/toggleterm.nvim
  { "ahmedkhalf/project.nvim" }, -- neovim projects functionality - https://github.com/ahmedkhalf/project.nvim
  { "goolord/alpha-nvim" }, -- greets from the lord and savior neovim - https://github.com/goolord/alpha-nvim
  { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } }, -- multitool fuzzy finder ui - https://github.com/nvim-telescope/telescope.nvim
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }, -- c port of fzf - https://github.com/nvim-telescope/telescope-fzf-native.nvim
  { "j-hui/fidget.nvim" }, -- pretty - https://github.com/j-hui/fidget.nvim
  { "rcarriga/nvim-notify" }, -- notification popups - https://github.com/rcarriga/nvim-notify
  { "stevearc/dressing.nvim" }, -- extensible neovim UI hooks - https://github.com/stevearc/dressing.nvim
  { "lalitmee/browse.nvim", requires = { "stevearc/dressing.nvim", "nvim-telescope/telescope.nvim" } }, -- search the web from vim - https://github.com/lalitmee/browse.nvim
  -- { "rmagatti/auto-session" }, -- automatically create && restore vim sessions for working dirs - https://github.com/rmagatti/auto-session
  -- {
  --   "rmagatti/session-lens",
  --   requires = { "nvim-lua/plenary.nvim", "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
  -- }, -- telescope session plugin - https://github.com/rmagatti/session-lens
  { "kevinhwang91/nvim-bqf", requires = { "nvim-treesitter/nvim-treesitter" } }, -- quickfix window replacement - https://github.com/kevinhwang91/nvim-bqf
  { "folke/which-key.nvim" }, -- search UI for looking up commands / keybinds - https://github.com/folke/which-key.nvim
  { 'simrat39/symbols-outline.nvim' }, -- symbol outline tree for lsp - https://github.com/simrat39/symbols-outline.nvim

  -- utils
  { "monaqa/dial.nvim" }, -- inc/decriment util - https://github.com/monaqa/dial.nvim
  {
    "pwntester/octo.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  }, -- gh cli interface - https://github.com/pwntester/octo.nvim

  -- color schemes
  { "ishan9299/nvim-solarized-lua" }, -- lua configurable solarized color scheme - https://github.com/ishan9299/nvim-solarized-lua

  -- completion plugins
  { "hrsh7th/nvim-cmp" }, -- the core completion plugin - https://github.com/hrsh7th/nvim-cmp
  { "hrsh7th/cmp-buffer", requires = { "hrsh7th/nvim-cmp" } }, -- completion source for buffer words - https://github.com/hrsh7th/cmp-buffer
  { "hrsh7th/cmp-path", requires = { "hrsh7th/nvim-cmp" } }, -- filesystem path completion - https://github.com/hrsh7th/cmp-path
  { "saadparwaiz1/cmp_luasnip", requires = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" } }, -- luasnip compltion source - https://github.com/saadparwaiz1/cmp_luasnip
  { "hrsh7th/cmp-nvim-lsp", requires = { "hrsh7th/nvim-cmp" } }, -- use neovim lsp protocol for completion - https://github.com/hrsh7th/cmp-nvim-lsp
  { "hrsh7th/cmp-nvim-lua", requires = { "hrsh7th/nvim-cmp" } }, -- completion for neovim api - https://github.com/hrsh7th/cmp-nvim-lua
  { "lukas-reineke/cmp-under-comparator", requires = { "hrsh7th/nvim-cmp" } }, -- completion for neovim api - https://github.com/lukas-reineke/cmp-under-comparator
  { "tzachar/cmp-tabnine", requires = { "hrsh7th/nvim-cmp" }, run = "./install.sh" }, -- tabnine cmp integration - https://github.com/tzachar/cmp-tabnine
  -- use { 'zbirenbaum/copilot-cmp', requires = { "hrsh7th/nvim-cmp" } } -- cmp integration for copilot.lua - https://github.com/zbirenbaum/copilot-cmp

  -- snippet sources / plugins
  { "L3MON4D3/LuaSnip", run = "make install_jsregexp" }, -- used by cmp_luasnip - https://github.com/L3MON4D3/LuaSnip
  { "rafamadriz/friendly-snippets" }, -- collection of snippets - https://github.com/rafamadriz/friendly-snippets

  -- LSP plugins
  { "neovim/nvim-lspconfig" }, -- collection of lsp configs - https://github.com/neovim/nvim-lspconfig
  { "williamboman/mason.nvim" }, -- LSP installer/manager - https://github.com/williamboman/mason.nvim
  { "williamboman/mason-lspconfig.nvim", requires = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" } }, -- integrates nvim-lspconfig and mason - https://github.com/williamboman/mason-lspconfig.nvim
  { "WhoIsSethDaniel/mason-tool-installer.nvim", requires = { "williamboman/mason.nvim" } }, -- auto installs and updates mason tools -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
  { "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } }, -- non-lsp integration with neovim LSP client - https://github.com/jose-elias-alvarez/null-ls.nvim
  { "RRethy/vim-illuminate" }, -- lsp & tree based word highlighting - https://github.com/RRethy/vim-illuminate
  { "ray-x/lsp_signature.nvim" }, -- method/function signature hints while typing - https://github.com/ray-x/lsp_signature.nvim
  { "b0o/SchemaStore.nvim" }, -- lsp access to json schema catalog (SchemaStore, - https://github.com/b0o/SchemaStore.nvim
  { "lvimuser/lsp-inlayhints.nvim" }, -- wip/partial implementation of LSP inlay hints - https://github.com/lvimuser/lsp-inlayhints.nvim
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }, --  - https://git.sr.ht/~whynothugo/lsp_lines.nvim
  -- use { 'zbirenbaum/copilot.lua' } -- lua implementation of github copilot integration - https://github.com/zbirenbaum/copilot.lua

  -- Language specific
  -- java
  { "mfussenegger/nvim-jdtls" }, -- java lsp - https://github.com/mfussenegger/nvim-jdtls
  -- lua
  { "folke/neodev.nvim" }, -- neovim lua lsp && type completion for neovim api - https://github.com/folke/neodev.nvim
  -- markdown
  { "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = "markdown" }, -- markdown in browser w/ hot reload - https://github.com/iamcco/markdown-preview.nvim
  -- rust
  { "Saecki/crates.nvim", requires = { "nvim-lua/plenary.nvim" } }, -- crate dependency helper - https://github.com/Saecki/crates.nvim
  {
    "simrat39/rust-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
  }, -- installs && configures rust-analyzer for lsp - https://github.com/simrat39/rust-tools.nvim
  -- typescript
  { "jose-elias-alvarez/typescript.nvim", requires = { "neovim/nvim-lspconfig" } }, -- typescript lsp - https://github.com/jose-elias-alvarez/typescript.nvim

  -- DAP plugins (debug adapter protocol)
  { "mfussenegger/nvim-dap" }, -- DAP client implementation for neovim - https://github.com/mfussenegger/nvim-dap
  { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }, -- UI for nvim-dap - https://github.com/rcarriga/nvim-dap-ui
  { "ravenxrz/DAPInstall.nvim" }, -- install debuggers from neovim for nvim-dap - https://github.com/ravenxrz/DAPInstall.nvim
}

return { packages = packages }
