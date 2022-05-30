local packages = function(use)
  use 'wbthomason/packer.nvim'

  -- new solarized truecolor pallete
  use {'overcache/NeoSolarized'} --, opt = false,  cmd = 'colorscheme NeoSolarized' } --, config = 'vim.cmd[[colorscheme NeoSolarized]]' }

  -- show indents with virtual lines
  use { 'lukas-reineke/indent-blankline.nvim', opt = false }

  -- nvim colored web icons
  use { 'kyazdani42/nvim-web-devicons' }

  -- LSP progress eye candy in bottom right
  use {'j-hui/fidget.nvim', opt = false}

  -- vscode style code actions
  -- use 'kosayoda/nvim-lightbulb'

  -- required by telescope
  use {'nvim-lua/plenary.nvim'}
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  -- suggested to telescope & aerial && neat / improved syntax highlighting and more?
  use {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd('TSUpdate') end}
  -- telescope
  use {'nvim-telescope/telescope.nvim'}

  -- comment stuff out easily...
  use {'tpope/vim-commentary'}
  -- handle comments for multi-language-file-types
  use {'JoosepAlviste/nvim-ts-context-commentstring'}

  -- TypeScript Plugins
  -- { 'jose-elias-alvarez/null-ls.nvim' };
  -- { 'jose-elias-alvarez/nvim-lsp-ts-utils' };

  use {'ms-jpq/chadtree', branch = 'chad', run = os.getenv('HOME')..'/bin/nvpython -m chadtree deps'}
  -- coc is like coq but has its own lsp so i don't have to waste time configuring neovim-lsp's
  use {'neoclide/coc.nvim', branch= 'release'}

  require('packer').sync()
end

local echohl = vim.schedule_wrap(function(msg, hl)
  local emsg = vim.fn.escape(msg, '"')
  vim.cmd('echohl ' .. hl .. ' | echom "' .. emsg .. '" | echohl None')
end)

local info = function(msg) echohl(msg, 'None') end
local err = function(msg) echohl(msg, 'ErrorMsg') end

local function init(success)
  if not success then
    err('[packer]: Failed setup')
    return
  end

  info('[packer]: Loading package list')
  vim.cmd('packadd packer.nvim')

  require('packer').startup(packages)
end

local function bootstrap()
  -- Bootstrap `packer` installation to manage packages
  local packer = {
    path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim',
    url = 'https://github.com/wbthomason/packer.nvim'
  }

  if vim.fn.executable('git') ~= 1 then
    err('[packer] Bootstrap failed, git not installed')
    return
  end

  if vim.fn.empty(vim.fn.glob(packer.path)) > 0 then
    info('[packer]: Installing...')

    local handle
    handle = vim.loop.spawn(
    'git',
    {
      args = {
        'clone',
        packer.url,
        packer.path,
      },
    },
    vim.schedule_wrap(
    function(code, _)
      -- Wrapper to call `init` based on the success of the above `git` operation
      handle:close()
      init(code == 0)
    end
    )
    )
  else
    -- `packer` already installed, continue to load package list
    init(true)
  end
end

return {bootstrap = bootstrap}