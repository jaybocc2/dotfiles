local mappings = {
  normal_mode = {
    -- ["C-"] = {
    --   -- nvim-tree
    --   n = { ":NvimTreeToggle<CR>", "toggle nvim-tree" },
    --   q = { ":call QuickFixToggle()<CR>", "tottle quickfix" },
    -- },
    ["C-q"] = { ":call QuickFixToggle()<CR>", "tottle quickfix" },
    ["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "toggle nvim-tree" },
    -- leader key binds
    ["<LEADER>"] = {
      S = { "<cmd>SymbolsOutline<CR>", "toggle symbols outline" },
    },
    -- new TAB
    ["tn"] = { "<cmd>tabnew<CR>", "open new tab" },
    -- misc
    -- ["<F2>"] = ":set nonumber!<CR>:set foldcolumn=0<CR>",
    -- whichkey
    ["wk"] = ":WhichKey<CR>",
    -- quick fix
    ["]q"] = { ":cnext<CR>", "next fix" },
    ["[q"] = { ":cprev<CR>", "previous fix" },
  },
  insert_mode = {
  },
}

local modes = {
  normal_mode = "n",
  insert_mode = "i",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

local function wk_mapping(wk, mode, map)
  if mode == "n" then
    wk.register(map)
  else
    wk.register(map, {mode = mode})
  end
end

local function mapkeys(mode_key, mode)
  local wk = jaylib.loadpkg("which-key")
  if wk == nil then
    vim.notify("which-key plugin missing - keybinds are not setup!", "error")
    return
  end
  wk_mapping(wk, mode, mappings[mode_key])
end

local function setup()
  for mode_key, mode in pairs(modes) do
    mapkeys(mode_key, mode)
  end
end

return { setup = setup }
