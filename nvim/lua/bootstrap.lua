local PKGS = {
  "savq/paq-nvim";

  -- new solarized truecolor pallete
  {'overcache/NeoSolarized'}; --, opt = false,  cmd = 'colorscheme NeoSolarized' } --, config = 'vim.cmd[[colorscheme NeoSolarized]]' }

  -- show indents with virtual lines
  { 'lukas-reineke/indent-blankline.nvim', opt = false };
  -- {'nathanaelkane/vim-indent-guides'};

  -- required by nvim-tree
  -- nvim colored web icons
  { 'kyazdani42/nvim-web-devicons' };
  -- {
  --   'kyazdani42/nvim-tree.lua',
  --   -- requires = { 'kyazdani42/nvim-web-devicons' },
  --   run = function() require('nvim-tree').setup() end
  -- };

  -- use nvim-lspconfig (default lsp configs for built-in lsp)
  {'neovim/nvim-lspconfig', opt = false};

  -- lsp plugin & ui
  -- { 'tami5/lspsaga.nvim', opt = false };

  -- lsp lines provides lsp diagnostics w/ virtual lines above the offending code
  -- use {
  --  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  --  config = function() require('lsp_lines').register_lsp_virtual_lines() end,
  -- }

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

  -- code signature hints
  -- use 'ray-x/lsp_signature.nvim'

  -- coq completion
  -- {'ms-jpq/coq_nvim', branch = 'coq'};
  -- {'ms-jpq/coq.artifacts', branch = 'artifacts'};
  -- {'ms-jpq/coq.thirdparty', branch = '3p'};
  {'ms-jpq/chadtree', branch = 'chad', run = os.getenv('HOME')..'/bin/nvpython -m chadtree deps'};
  {'neoclide/coc.nvim', branch= 'release'};

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the 'config' key)
  -- use {
  --   'w0rp/ale',
  --   ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --   cmd = 'ALEEnable',
  --   config = 'vim.cmd[[ALEEnable]]'
  -- }

  -- List your packages here!
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
