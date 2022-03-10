local PKGS = {
  "savq/paq-nvim";

  -- new solarized truecolor pallete
  {'overcache/NeoSolarized'}; --, opt = false,  cmd = 'colorscheme NeoSolarized' } --, config = 'vim.cmd[[colorscheme NeoSolarized]]' }

  -- show indents with virtual lines
  { 'lukas-reineke/indent-blankline.nvim', opt = false };

  -- nvim colored web icons
  { 'kyazdani42/nvim-web-devicons' };

  -- LSP progress eye candy in bottom right
  {'j-hui/fidget.nvim', opt = false};

  -- vscode style code actions
  -- use 'kosayoda/nvim-lightbulb'

  -- required by telescope
  {'nvim-lua/plenary.nvim'};
  {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'};
  -- suggested to telescope & aerial && neat / improved syntax highlighting and more?
  {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd('TSUpdate') end};
  -- telescope
  {'nvim-telescope/telescope.nvim'};

  -- comment stuff out easily...
  {'tpope/vim-commentary'};
  -- handle comments for multi-language-file-types
  {'JoosepAlviste/nvim-ts-context-commentstring'};

  -- TypeScript Plugins
  -- { 'jose-elias-alvarez/null-ls.nvim' };
  -- { 'jose-elias-alvarez/nvim-lsp-ts-utils' };

  {'ms-jpq/chadtree', branch = 'chad', run = os.getenv('HOME')..'/bin/nvpython -m chadtree deps'};
  -- coc is like coq but has its own lsp so i don't have to waste time configuring neovim-lsp's
  {'neoclide/coc.nvim', branch= 'release'};
}

local function clone_paq()
  local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system {
      'git',
      'clone',
      '--depth=1',
      'https://github.com/savq/paq-nvim.git',
      path
    }
  end
end

local function bootstrap_paq()
  clone_paq()
  -- Load Paq
  vim.cmd('packadd paq-nvim')
  local paq = require('paq')
  -- Exit nvim after installing plugins
  vim.cmd('autocmd User PaqDoneInstall quit')
  -- Read and install packages
  paq(PKGS)
  paq.install()
  print('')
end

local function run_paq()
  vim.cmd('packadd paq-nvim')
  local paq = require('paq')
  paq(PKGS)
  paq.install()
  paq.update()
  paq.clean()
end

return { bootstrap_paq = bootstrap_paq, run_paq = run_paq }
