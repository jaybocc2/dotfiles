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
end

local function options()
  vim.api.nvim_set_option('shiftwidth', 2)
  vim.api.nvim_set_option('softtabstop', 2)
  vim.api.nvim_set_option('tabstop', 2)
  vim.api.nvim_set_option('expandtab', true)
  vim.api.nvim_set_option('smarttab', true)

  -- coq vars
  vim.api.nvim_set_var('coq_settings', {auto_start=true})
  vim.api.nvim_set_var('python3_host_prog', os.getenv('HOME')..'/bin/nvpython')
end

local config = function()
  if findcolor('NeoSolarized') then
    vim.cmd('colorscheme NeoSolarized')
  else
    vim.cmd('colorscheme slate')
  end

  keybinds()
  options()

  -- require('nvim-tree').setup()
  require('fidget').setup()
  -- require('lspsaga').setup()
end

return config()
