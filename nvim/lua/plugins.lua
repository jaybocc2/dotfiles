local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local startup = function(use)
  -- manage itself
  use 'wbthomason/packer.nvim'

  -- use nvim-lspconfig (default lsp configs for built-in lsp)
  use 'neovim/nvim-lspconfig'

  -- vscode style code actions
  use 'kosayoda/nvim-lightbulb'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- required for telescope
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- suggested to telescope & aerial && neat / improved syntax highlighting and more?
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- code signature hints
  use 'ray-x/lsp_signature.nvim'

  -- coq completion
  use { 'ms-jpq/coq_nvim', branch = 'coq'}
  use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
  use { 'ms-jpq/coq.thirdparty', branch = '3p' }

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  if Packer_bootstrap then
    require('packer').sync()
  end
end

return require('packer').startup(startup)
