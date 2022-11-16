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
  { "numToStr/Comment.nvim" }, -- commenting plugin - https://github.com/numToStr/Comment.nvim
  { "JoosepAlviste/nvim-ts-context-commentstring" }, -- context aware comment plugin (ie, mixed language comments, - https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  { "nvim-treesitter/nvim-treesitter", run = treesitter_run }, -- treesitter configurations and abstraction layer - https://github.com/nvim-treesitter/nvim-treesitter
  { "p00f/nvim-ts-rainbow" }, -- rainbow colors for nested brackets/braces etc - https://github.com/p00f/nvim-ts-rainbow
  { "kylechui/nvim-surround" }, -- macro's for wrapping text w/ arbitrary text/symbols etc - https://github.com/kylechui/nvim-surround
  { "folke/todo-comments.nvim" }, -- highlight / search TODO comments - https://github.com/folke/todo-comments.nvim
  { "lewis6991/gitsigns.nvim" }, -- git integration - https://github.com/lewis6991/gitsigns.nvim
  { "lukas-reineke/indent-blankline.nvim" }, -- tabs/spaces indent indicators - https://github.com/lukas-reineke/indent-blankline.nvim

  -- UI/UX
  { "nvim-tree/nvim-web-devicons" }, -- unicode text/icon plugin - https://github.com/nvim-tree/nvim-web-devicons
  { "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" }, tag = "nightly" }, -- file tree plugin - https://github.com/nvim-tree/nvim-tree.lua
  { "akinsho/bufferline.nvim" }, -- buffer line/tab plugin - https://github.com/akinsho/bufferline.nvim
  { "moll/vim-bbye" }, -- impvoed vim buffer management - https://github.com/moll/vim-bbye
  { "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons" } }, -- vim status line - https://github.com/nvim-lualine/lualine.nvim
  { "akinsho/toggleterm.nvim" }, -- pop open a terminal in nvim - https://github.com/akinsho/toggleterm.nvim_out_write
  { "ahmedkhalf/project.nvim" }, -- neovim projects functionality - https://github.com/ahmedkhalf/project.nvim
  { "goolord/alpha-nvim" }, -- greets from the lord and savior neovim - https://github.com/goolord/alpha-nvim
  { "nvim-telescope/telescope.nvim" }, -- multitool fuzzy finder ui - https://github.com/nvim-telescope/telescope.nvim
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }, -- c port of fzf - https://github.com/nvim-telescope/telescope-fzf-native.nvim
  { "j-hui/fidget.nvim" }, -- pretty - https://github.com/j-hui/fidget.nvim
  { "rcarriga/nvim-notify" }, -- notification popups - https://github.com/rcarriga/nvim-notify
  { "stevearc/dressing.nvim" }, -- extensible neovim UI hooks - https://github.com/stevearc/dressing.nvim
  { "lalitmee/browse.nvim" }, -- search the web from vim - https://github.com/lalitmee/browse.nvim
  { "rmagatti/auto-session" }, -- automatically create && restore vim sessions for working dirs - https://github.com/rmagatti/auto-session
  { "rmagatti/session-lens" }, -- telescope session plugin - https://github.com/rmagatti/session-lens
  { "kevinhwang91/nvim-bqf" }, -- quickfix window replacement - https://github.com/kevinhwang91/nvim-bqf
  { "folke/which-key.nvim" }, -- search UI for looking up commands / keybinds - https://github.com/folke/which-key.nvim

  -- utils
  { "monaqa/dial.nvim" }, -- inc/decriment util - https://github.com/monaqa/dial.nvim
  { "pwntester/octo.nvim" }, -- gh cli interface - https://github.com/pwntester/octo.nvim

  -- color schemes
  { "ishan9299/nvim-solarized-lua" }, -- lua configurable solarized color scheme - https://github.com/ishan9299/nvim-solarized-lua

  -- completion plugins
  { "hrsh7th/nvim-cmp" }, -- the core completion plugin - https://github.com/hrsh7th/nvim-cmp
  { "hrsh7th/cmp-buffer" }, -- completion source for buffer words - https://github.com/hrsh7th/cmp-buffer
  { "hrsh7th/cmp-path" }, -- filesystem path completion - https://github.com/hrsh7th/cmp-path
  { "saadparwaiz1/cmp_luasnip" }, -- luasnip compltion source - https://github.com/saadparwaiz1/cmp_luasnip
  { "hrsh7th/cmp-nvim-lsp" }, -- use neovim lsp protocole for completion - https://github.com/hrsh7th/cmp-nvim-lsp
  { "hrsh7th/cmp-nvim-lua" }, -- completion for neovim api - https://github.com/hrsh7th/cmp-nvim-lua
  { "tzachar/cmp-tabnine", run = "./install.sh" }, -- tabnine cmp integration - https://github.com/tzachar/cmp-tabnine
  -- use { 'zbirenbaum/copilot-cmp' } -- cmp integration for copilot.lua - https://github.com/zbirenbaum/copilot-cmp

  -- snippet sources / plugins
  { "L3MON4D3/LuaSnip" }, -- used by cmp_luasnip - https://github.com/L3MON4D3/LuaSnip
  { "rafamadriz/friendly-snippets" }, -- collection of snippets - https://github.com/rafamadriz/friendly-snippets

  -- LSP plugins
  { "neovim/nvim-lspconfig" }, -- collection of lsp configs - https://github.com/neovim/nvim-lspconfig
  { "williamboman/mason.nvim" }, -- LSP installer/manager - https://github.com/williamboman/mason.nvim
  { "williamboman/mason-lspconfig.nvim" }, -- integrates nvim-lspconfig and mason - https://github.com/williamboman/mason-lspconfig.nvim
  { "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- auto installs and updates mason tools -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
  { "jose-elias-alvarez/null-ls.nvim" }, -- non-lsp integration with neovim LSP client - https://github.com/jose-elias-alvarez/null-ls.nvim
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
  { "Saecki/crates.nvim" }, -- crate dependency helper - https://github.com/Saecki/crates.nvim
  { "simrat39/rust-tools.nvim" }, -- installs && configures rust-analyzer for lsp - https://github.com/simrat39/rust-tools.nvim
  -- typescript
  { "jose-elias-alvarez/typescript.nvim" }, -- typescript lsp - https://github.com/jose-elias-alvarez/typescript.nvim

  -- DAP plugins (debug adapter protocol)
  { "mfussenegger/nvim-dap" }, -- DAP client implementation for neovim - https://github.com/mfussenegger/nvim-dap
  { "rcarriga/nvim-dap-ui" }, -- UI for nvim-dap - https://github.com/rcarriga/nvim-dap-ui
  { "ravenxrz/DAPInstall.nvim" }, -- install debuggers from neovim for nvim-dap - https://github.com/ravenxrz/DAPInstall.nvim
}

return { packages = packages }
