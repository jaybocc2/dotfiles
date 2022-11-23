local icons = require("icons")

-- install list for lsp for mason
local lsp_servers = {
  "bashls", -- bash
  "jdtls", -- java
  "jsonls", -- json
  "marksman", -- markdown
  "prosemd_lsp", -- markdown && nlprule processing
  "pyright", -- python
  "rust_analyzer", -- rust
  "sumneko_lua", -- lua
  "terraformls", -- terraform
  "tsserver", -- typescript server
  "yamlls", -- yaml
}

local mason_server_mappings = jaylib.loadpkg("mason-lspconfig.mappings.server")
if mason_server_mappings == nil then return end
local lsp_servers_translated = {}
for _, s in ipairs(lsp_servers) do
  table.insert(lsp_servers_translated, mason_server_mappings.lspconfig_to_package[s])
end

-- install list for non lsp binaries
local auto_mason_install = {
  "marksman", -- markdown
  "misspell", -- english spelling
  "protolint", -- protobuff linter
  "pylint8",
  "shellcheck", -- shell checker for null-ls
  "shfmt", -- shell formatter
  "stylua", -- lua style
}



local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = icons.ui.Check,
      package_pending = icons.ui.ArrowRight,
      package_uninstalled = icons.ui.Close,
    },
  },
}

local function setup()
  local mason = jaylib.loadpkg("mason")
  if mason == nil then return end
  mason.setup(settings)

  local mason_tool_installer = jaylib.loadpkg("mason-tool-installer")
  if mason_tool_installer == nil then return end
  mason_tool_installer.setup({
    ensure_installed = vim.tbl_deep_extend("force", auto_mason_install, lsp_servers_translated),
    auto_update = true,
    run_on_start = true,
  })

  local mason_lspconfig = jaylib.loadpkg("mason-lspconfig")
  if mason_lspconfig == nil then return end
  mason_lspconfig.setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
  })

  local lsp = require("lsp")

  local neodev = jaylib.loadpkg("neodev")
  if neodev == nil then return end
  neodev.setup({
    lspconfig = lsp.get_common_options(),
  })

  local lspconfig = jaylib.loadpkg("lspconfig")
  if lspconfig == nil then return end

  local opts = {}

  for _, server in pairs(lsp_servers) do
    opts = lsp.get_common_options()

    --server = vim.split(server, "@", {})[1]

    if server == "jsonls" then
      local server_opts = require("lsp.settings.jsonls")
      opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    if server == "yamlls" then
      local server_opts = require("lsp.settings.yamlls")
      opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    if server == "sumneko_lua" then
      lspconfig.sumneko_lua.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })

      goto continue
    end

    if server == "tsserver" then
      local server_opts = require("lsp.settings.tsserver")
      opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    if server == "pyright" then
      local server_opts = require("lsp.settings.pyright")
      opts = vim.tbl_deep_extend("force", server_opts, opts)
    end

    if server == "jdtls" then
      goto continue
    end

    if server == "rust_analyzer" then
      local rust_opts = require("lsp.settings.rust")
      local rust_tools = jaylib.loadpkg("rust-tools")
      if rust_tools == nil then return end
      rust_tools.setup(rust_opts)
      goto continue
    end

    lspconfig[server].setup(opts)
    ::continue::
  end
end

return { setup = setup }
