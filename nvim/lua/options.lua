local function findcolor(s)
  local set = {}
  for _, l in ipairs(vim.fn.getcompletion("", "color")) do
    set[l] = true
  end
  if set[s] then
    return true
  end
  return false
end

local function setup()
  vim.api.nvim_set_var("python3_host_prog", vim.fn.expand("~/.pyenv/versions/neovim/bin/python"))
  vim.api.nvim_set_var("ruby_host_prog", vim.fn.expand("~/.rbenv/versions/3.1.2/bin/neovim-ruby-host"))
  vim.api.nvim_set_var("node_host_prog", vim.fn.expand("~/.nodenv/versions/18.12.1/bin/neovim-node-host"))
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
  vim.opt.colorcolumn = "120"
  vim.opt.showmode = true -- set to false when / if use lualine
  vim.opt.mouse = "a"


  local primary = "neogruvbox"
  local bg = "dark"

  if findcolor(primary) then
    vim.cmd("colorscheme " .. primary)
    vim.opt.background = bg
  elseif findcolor("NeoSolarized") then
    vim.cmd("colorscheme NeoSolarized")
    vim.opt.background = "light"
  elseif findcolor("solarized") then
    vim.cmd("colorscheme solarized")
    vim.opt.background = "light"
  else
    vim.cmd("colorscheme slate")
  end
end

return { setup = setup }
