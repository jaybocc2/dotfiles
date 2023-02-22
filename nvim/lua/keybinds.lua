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
      rn = { ":IncRename ", "LSP Rename/refactor word under cursor"}
    },
    b = {
      name = "Buffer",
      c = { "<cmd>bd<CR>", "Close active buffer" },
      n = { "<cmd>bn<CR>", "switch to next buffer" },
      p = { "<cmd>bp<CR>", "switch to previous buffer" },
      w = { "<cmd>w<CR>", "write/save buffer" },
      D = { "<cmd>%bd|e#|bd#<CR>", "close all buffers" },
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
  insert_mode = {},
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
    wk.register(map, { mode = mode })
  end
end

---@param mode string -- vim mode for keybind map
---@param map table -- which-key compatible bindings table
local function mapkeys(mode, map)
  local wk = jaylib.loadpkg("which-key")
  if wk == nil then
    jaylib.notify("keybinds are not setup!", "warn")
    return
  end
  wk_mapping(wk, mode, map)
end

local function setup()
  for mode_key, mode in pairs(modes) do
    mapkeys(mode, mappings[mode_key])
  end
end

return { setup = setup }
