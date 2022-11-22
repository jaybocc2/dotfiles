local _M = {}

local config = require('lsp.config')

local function add_buffer_options(bufnr)
  for k, v in pairs(config.buffer_options) do
    vim.api.nvim_buf_set_option(bufnr, k, v)
  end
end

-- TODO: keybinds sould be in keybinds.lua, no?
local function add_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(config.buffer_mappings[mode_name]) do
      local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
      vim.keymap.set(mode_char, key, remap[1], opts)
    end
  end
end

function _M.common_capabilities()
  local cmp_nvim_lsp = jaylib.loadpkg("cmp_nvim_lsp")
  if cmp_nvim_lsp ~= nil then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

function _M.common_on_attach(client, bufnr)
  add_buffer_options(bufnr)
  add_buffer_keybindings(bufnr)
end

function _M.get_common_options()
  return {
    on_attach = _M.common_on_attach,
    capabilities = _M.common_capabilities,
  }
end

function _M.server_capabilities()
  local active_clients = vim.lsp.get_active_clients()
  local active_client_map = {}

  for index, value in ipairs(active_clients) do
    active_client_map[value.name] = index
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Seclect client:",
    format_item = function(item)
      return "capabilities for: " .. item
    end,
  }, function(choice)
    print(
      vim.inspect(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities.executeCommandProvider)
    )
    vim.pretty_print(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
  end)
end

function _M.setup()
  -- TODO: lspconfig is loaded by lsp.mason, what is loading it here do?
  local lspconfig = jaylib.loadpkg("lspconfig")
  if lspconfig == nil then return end

  for _, sign in ipairs(config.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require("lsp.signature").setup()
  require("lsp.handlers").setup()
  require("lsp.mason").setup()
  require("lsp.null-ls").setup()

  local lsp_lines = jaylib.loadpkg("lsp_lines")
  if lsp_lines == nil then return end
  lsp_lines.setup()

  -- autocmd format on save?
end

return _M
