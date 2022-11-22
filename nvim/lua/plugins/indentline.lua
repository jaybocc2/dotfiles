local icons = require("icons")
local config = {
  enabled = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "text",
  },
  char = icons.ui.LineLeft,
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = false,
  show_current_context = false,
}

local function setup()
  local indent_blankline = jaylib.loadpkg("indent_blankline")
  if indent_blankline == nil then return end

  indent_blankline.setup(config)
end

return { setup = setup }
