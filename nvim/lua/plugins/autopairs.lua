local config = {
  ---@usage check bracket in same line
  enable_check_bracket_line = false,
  ---@usage check treesitter
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  ---@usage disable when recording or executing a macro
  disable_in_macro = false,
  ---@usage add bracket pairs after quote
  enable_afterquote = true,
  ---@usage map the <BS> key
  map_bs = true,
  ---@usage map <c-w> to delete a pair if possible
  map_c_w = false,
  ---@usage disable when insert after visual block mode
  disable_in_visualblock = false,
  ---@usage  change default fast_wrap
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment",
  },
}

local function setup()
  local autopairs = jaylib.loadpkg("nvim-autopairs")
  if autopairs == nil then
    return
  end
  local rule = jaylib.loadpkg("nvim-autopairs.rule")

  autopairs.setup(config)

  local ts_configs = jaylib.loadpkg("nvim-treesitter.configs")
  if ts_configs ~= nil then
    ts_configs.setup({ autopairs = { enable = true } })
  end

  local ts_conds = jaylib.loadpkg("nvim-autopairs.ts-conds")
  if ts_conds ~= nil and rule ~= nil then
    autopairs.add_rules({
      rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
      rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    })
  end

  local ap_cmp = jaylib.loadpkg("nvim-autopairs.completion.cmp")
  local cmp = jaylib.loadpkg("cmp")
  if ap_cmp ~= nil and cmp ~= nil then
    cmp.event:off("confirm_done", ap_cmp.on_confirm_done())
    cmp.event:on("confirm_done", ap_cmp.on_confirm_done())
  end
end

return { setup = setup }
