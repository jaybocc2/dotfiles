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

function _G.check_back_space()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
end

function _G.show_documentation()
  local ft = vim.bo.filetype
  local cword = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, ft) then
    vim.fn.execute('help ' .. cword)
  elseif vim.fn['coc#rpc#ready']() then
    vim.fn.call('CocActionAsync', {'doHover'})
  else
    vim.fn.execute(vim.o.keywordprg .. ' ' .. cword)
  end
end

local function keybinds()
  mapkeybind('n', '<C-n>', ':CHADopen<CR>')
  mapkeybind('n', '<F2>', ':set nonumber!<CR>:set foldcolumn=0<CR>')
  mapkeybind('n', 'tn', ':tabnew<CR>')

  -- CoC keybinds
  mapkeybind('i', "<C-Space>", "coc#refresh()", { silent = true, expr = true })
  mapkeybind('i', '<CR>', "pumvisible() ? coc#_select_confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'", { silent = true, expr = true })
  mapkeybind('i', '<TAB>', 'pumvisible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? "<C-r>=coc#rpc#request(\'doKeymap\', [\'snippets-expand-jump\',\'\'])<CR>" : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', { silent = true, expr = true })
  mapkeybind('n', 'K', ': v:lua.show_documentation() <CR>', { silent = true })
  -- rename
  mapkeybind('n', '<LEADER>rn', '<Plug>(coc-rename)')
  -- format
  mapkeybind('n', '<LEADER>f', '<Plug>(coc-format-selected)')
  mapkeybind('n', '<LEADER>gd', ':CocDiagnostics<CR>')
  mapkeybind('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  mapkeybind('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
  mapkeybind('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
  mapkeybind('n', 'gr', '<Plug>(coc-references)', { silent = true })
  mapkeybind('n', '<space>S', ':CocList outline<CR>', {silent = true})
  mapkeybind('n', '<LEADER>S', ':AerialToggle<CR>')
  -- mapkeybind('n', '<LEADER>S', ':SymbolsOutline<CR>')
  -- mapkeybind('n', '<LEADER>S', ':Vista coc<CR>')
end

local function custom_commands()
  -- " Add `:Format` command to format current buffer.
  -- command! -nargs=0 Format :call CocActionAsync('format')
  vim.api.nvim_create_user_command('Format', 'call CocActionAsync("format")', {nargs = 0})

  -- " Add `:Fold` command to fold current buffer.
  -- command! -nargs=? Fold :call     CocAction('fold', <f-args>)
  vim.api.nvim_create_user_command('Fold', 'call CocAction("fold", <f-args>)', {nargs = "?"})

  -- " Add `:OR` command for organize imports of the current buffer.
  -- command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
  vim.api.nvim_create_user_command('OR', 'call CocActionAsync("runCommand", "editor.action.organizeImport")', {nargs = 0})
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
  vim.opt.cursorline = true
  vim.opt.autoread = true
  vim.opt.incsearch = true
  vim.opt.scrolloff = 5
  vim.opt.numberwidth = 3
  vim.opt.colorcolumn = '120'
  vim.opt.showmode = true -- set to false when / if use lualine
  vim.opt.mouse = 'a'

  vim.api.nvim_set_var('python3_host_prog', vim.fn.expand('~/.pyenv/versions/neovim3/bin/python'))

  -- coc vars
  vim.api.nvim_set_var('coc_global_extensions', {
    -- 'coc-flutter',
    'coc-git',
    'coc-go',
    'coc-sumneko-lua',
    'coc-markdownlint',
    'coc-pyright',
    'coc-rust-analyzer',
    'coc-snippets',
    'coc-tsserver',
    'coc-eslint',
  })
  vim.api.nvim_set_var('coc_user_config', require('lsp').config())
  vim.api.nvim_set_var('coc_snippet_next', '<tab>')
end

-- configure lualine
local function lualine_config()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics', 'modified'},
      lualine_c = {'filename'},
      lualine_x = {'g:coc_status', 'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'},
    },
  }
  vim.opt.showmode = false -- set to false when / if use lualine
end

local function chadtree_config()
  local chadtree_settings = {
    ignore = {
      name_glob = {
        "*.d.ts",
        "*.js",
      },
    }
  }

  vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
end

local function indent_blankline()
  vim.opt.list = true
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
    ensure_installed = {
      "bash",
      "dockerfile",
      "go",
      "hcl",
      "javascript",
      "lua",
      "make",
      "python",
      "rust",
      "tsx",
      "typescript",
      "vim",
    },
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
  elseif findcolor('solarized') then
    vim.cmd('colorscheme solarized')
    vim.opt.background = 'light'
  else
    vim.cmd('colorscheme slate')
  end

  keybinds()
  options()
  custom_commands()
  indent_blankline()
  telescope()
  nvim_treesitter()
  chadtree_config()
  lualine_config()

  require('fidget').setup()
end

return config()
