local function findcolor(s)
  local set = {}
  for _, l in ipairs(vim.fn.getcompletion('', 'color')) do set[l] = true end
  if set[s] then return true end
  return false
end

local function mapkeybind(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function keybinds()
  mapkeybind("n", "<C-n>", ':CHADopen<CR>')
  -- nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
  mapkeybind("n", "<F2>", ':set nonumber!<CR>:set foldcolumn=0<CR>')
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
  vim.opt.autoread = true
  vim.opt.incsearch = true

  -- coq vars
  vim.api.nvim_set_var('coq_settings', {auto_start=true})
  vim.api.nvim_set_var('python3_host_prog', os.getenv('HOME')..'/bin/nvpython')
end

local function indent_blankline()
  vim.api.nvim_set_var('indent_guides_enable_on_vim_startup', 1)
  -- local untinted = 'eee8d5'
  -- local tinted = 'ec7c3b2'
  -- vim.cmd('highlight IndentBlanklineIndent1 guibg=#'..untinted..' gui=nocombine')
  -- vim.cmd('highlight IndentBlanklineIndent2 guibg=#'..tinted..' gui=nocombine')

  -- require("indent_blankline").setup({
  --   char = "",
  --   char_highlight_list = {
  --     "IndentBlankLineIndent1",
  --     "IndentBlankLineIndent2",
  --   },
  --   space_char_highlight_list = {
  --     "IndentBlankLineIndent1",
  --     "IndentBlankLineIndent2",
  --   },
  --   show_trailing_blankline_indent = false,
  -- })
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

  -- require('nvim-tree').setup()
  require('fidget').setup()
  -- require('lspsaga').setup()
end

return config()
