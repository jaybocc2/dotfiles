local function mapkeybind(mode, lhs, rhs, opts)
  local options = { noremap = true }
  local override = {}
  if opts ~= nil then
    override = opts
  end

  -- options = vim.tbl_extend('force', options, opts or {})
  options = vim.tbl_extend("force", options, override)
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function setup()
  -- mapkeybind("n", "<C-n>", ":CHADopen<CR>")
  mapkeybind("n", "<F2>", ":set nonumber!<CR>:set foldcolumn=0<CR>")
  mapkeybind("n", "tn", ":tabnew<CR>")

  -- CoC keybinds
  -- mapkeybind("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })
  -- mapkeybind(
  --     "i",
  --     "<CR>",
  --     "coc#pum#visible() ? coc#_select_confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'",
  --     { silent = true, expr = true }
  -- )
  -- mapkeybind(
  --     "i",
  --     "<TAB>",
  --     "coc#pum#visible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? \"<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])<CR>\" : v:lua.check_back_space() ? \"<TAB>\" : coc#refresh()",
  --     { silent = true, expr = true }
  -- )
  mapkeybind("n", "K", ": v:lua.show_documentation() <CR>", { silent = true })
  -- rename
  -- mapkeybind("n", "<LEADER>rn", "<Plug>(coc-rename)")
  -- format
  -- mapkeybind("n", "<LEADER>f", "<Plug>(coc-format-selected)")
  -- mapkeybind("n", "<LEADER>gd", ":CocDiagnostics<CR>")
  -- mapkeybind('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  -- mapkeybind("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  -- mapkeybind("n", "gi", "<Plug>(coc-implementation)", { silent = true })
  -- mapkeybind("n", "gr", "<Plug>(coc-references)", { silent = true })
  -- mapkeybind("n", "<space>S", ":CocList outline<CR>", { silent = true })
  mapkeybind("n", "<LEADER>S", ":AerialToggle<CR>")
  -- mapkeybind('n', '<LEADER>S', ':SymbolsOutline<CR>')
  -- mapkeybind('n', '<LEADER>S', ':Vista coc<CR>')
end

return { setup = setup }
