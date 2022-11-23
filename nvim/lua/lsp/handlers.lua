local _M = {}

local config = require("lsp.config")

local cmp_nvim_lsp = jaylib.loadpkg("cmp_nvim_lsp")
if cmp_nvim_lsp == nil then
  return
end

_M.capabilities = cmp_nvim_lsp.default_capabilities()
_M.capabilities.textDocument.completion.completionItem.snippetSupport = true

_M.setup = function()
  vim.diagnostic.config({
    virtual_text = config.diagnostics.virtual_text,
    signs = config.diagnostics.signs,
    update_in_insert = config.diagnostics.update_in_insert,
    underline = config.diagnostics.underline,
    severity_sort = config.diagnostics.severity_sort,
    float = config.diagnostics.float,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local navic = jaylib.loadpkg("nvim-navic")
  if navic == nil then
    return
  end
  navic.attach(client, bufnr)
end

-- TODO: keybinds sould be in keybinds.lua, no?
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]])
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-f>", "<cmd>Format<cr>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-a>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

_M.on_attach = function(client, bufnr)
  vim.notify("handler on attach was called", "error")
  lsp_keymaps(bufnr)
  attach_navic(client, bufnr)

  if client.name == "tsserver" then
    require("lsp-inlayhints").on_attach(client, bufnr)
  end

  -- if client.name == "jdt.ls" then
  --   vim.lsp.codelens.refresh()
  --   if JAVA_DAP_ACTIVE then
  --     require("jdtls").setup_dap({ hotcodereplace = "auto" })
  --     require("jdtls.dap").setup_dap_main_class_configs()
  --   end
  -- end
end

function _M.enable_format_on_save()
  vim.cmd([[
    augroup format_on_save
      autocmd! 
      autocmd BufWritePre * lua vim.lsp.buf.format({ async = false }) 
    augroup end
  ]])
  vim.notify("Enabled format on save")
end

function _M.disable_format_on_save()
  _M.remove_augroup("format_on_save")
  vim.notify("Disabled format on save")
end

function _M.toggle_format_on_save()
  if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
    _M.enable_format_on_save()
  else
    _M.disable_format_on_save()
  end
end

function _M.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require('user.lsp.handlers').toggle_format_on_save()' ]])

return _M
