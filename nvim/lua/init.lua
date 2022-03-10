local function findcolor(s)
  local set = {}
  for _, l in ipairs(vim.fn.getcompletion('', 'color')) do set[l] = true end
  if set[s] then return true end
  return false
end

local function mapkeybind(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function keybinds()
  mapkeybind('n', '<C-n>', ':CHADopen<CR>')
  mapkeybind('n', '<F2>', ':set nonumber!<CR>:set foldcolumn=0<CR>')
  mapkeybind('n', 'tn', ':tabnew')

  -- CoC keybinds
  mapkeybind('i', "<C-Space>", "coc#refresh()", { silent = true, expr = true })
  mapkeybind('i', '<CR>', "pumvisible() ? coc#_select_confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'", { silent = true, expr = true })
  vim.cmd([[
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]])
  mapkeybind('i', '<TAB>', 'pumvisible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? "<C-r>=coc#rpc#request(\'doKeymap\', [\'snippets-expand-jump\',\'\'])<CR>" : <SID>check_back_space() ? "<TAB>" : coc#refresh()', { silent = true, expr = true })
  mapkeybind('n', 'K', ':call <SID>show_documentation()<CR>', { silent = true })
  -- rename
  mapkeybind('n', '<LEADER>rn', '<Plug>(coc-rename)')
  -- format
  mapkeybind('n', '<LEADER>f', '<Plug>(coc-format-selected)')
  mapkeybind('n', '<LEADER>gd', ':CoCDiagnostics<CR>')
  mapkeybind('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  mapkeybind('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
  mapkeybind('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
  mapkeybind('n', 'gr', '<Plug>(coc-references)', { silent = true })
end

local function coc_user_config()
  local config = {
    coc = {
      preferences = {
        snippets = {
          enable = true,
        },
        extenstionUpdateCheck = "daily",
      },
    },
    flutter = {
      provider = {
        enableSnippet = true,
      },
    },

    languageserver = {
      golang = {
        command = "gopls",
        rootPatterns = {"go.mod", ".vim/", ".git/", ".hg/"},
        filetypes = {"go"},
        initializationOptions = {
          gofumpt = true,
          usePlaceholders = true,
        },
      }
    },
    go = {
      goplsOptions = {
        gofumpt = true
      },
    },
    python = {
      pythonPath = "cocpython",
      blackPath = "cocblack",
      blackdPath = "cocblackd",
    },
  }
  return config
end

local function options()
  vim.opt.termguicolors = true
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.smarttab = true
  vim.opt.tabstop = 2
  vim.opt.et = true
  vim.opt.number = true
  vim.opt.relativenumber = true -- might disable this.
  vim.opt.autoread = true
  vim.opt.incsearch = true
  vim.opt.scrolloff = 5
  vim.opt.numberwidth = 3
  vim.opt.colorcolumn = '120'
  vim.opt.showmode = true -- set to false when / if use lualine
  -- vim.opt.showcolumn = 'yes'
  vim.opt.mouse = 'a'

  -- coq vars
  -- vim.api.nvim_set_var('coq_settings', {auto_start=true})
  -- vim.api.nvim_set_var('python3_host_prog', os.getenv('HOME')..'/bin/nvpython')
  -- coc vars
  vim.api.nvim_set_var('coc_global_extensions', {
    'coc-markdownlint',
    -- 'coc-flutter',
    'coc-pyright',
    'coc-snippets',
    'coc-go',
    'coc-git',
    'coc-lua',
    'coc-tsserver',
  })
  vim.api.nvim_set_var('coc_user_config', coc_user_config())
  vim.api.nvim_set_var('coc_snippet_next', '<tab>')
end

local function indent_blankline()
  -- solarized light tints
  -- local untinted = 'eee8d5'
  -- local tinted = 'ec7c3b2'
  vim.opt.list = true
  -- vim.opt.listchars:append("space:⋅")
  vim.opt.listchars:append("eol:↴")
  require('indent_blankline').setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  })
end

local function telescope()
  require('telescope').setup({
    pickers = {
      find_files = {
        theme = 'ivy'
      }
    }
  })
end

local function nvim_treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained',
    context_commentstring = {
      enable = true
    },
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
  })
end

local config = function()
  if findcolor('NeoSolarized') then
    vim.cmd('colorscheme NeoSolarized')
    vim.opt.background = 'light'
  else
    vim.cmd('colorscheme slate')
  end

  keybinds()
  options()
  indent_blankline()
  telescope()
  nvim_treesitter()

  -- require('nvim-tree').setup()
  require('fidget').setup()
  -- require('lspsaga').setup()
end

return config()
