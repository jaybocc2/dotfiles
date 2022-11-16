local lsp_servers = {
  "bashls", -- bash
  "jdtls", -- java
  "jsonls", -- json
  "marksman", -- markdown
  -- "misspell", -- english spelling
  -- "protolint", -- protobuff linter
  -- "prosemd-lsp", -- markdown && nlprule processing
  "pyright", -- python
  "rust_analyzer", -- rust
  "sumneko_lua", -- lua
  "terraformls", -- terraform
  "tsserver", -- typescript server
  "yamlls", -- yaml
}

local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

local function setup()
  local status_ok, mason = pcall(require, "mason")
  if not status_ok then
    return
  end

  mason.setup(settings)

  local status_ok1, mason_tool_installer = pcall(require, "mason-tool-installer")
  if not status_ok1 then
    return
  end

  mason_tool_installer.setup({
    ensure_installed = lsp_servers,
    auto_update = true,
    run_on_start = true,
  })

  local status_ok2, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not status_ok2 then
    return
  end

  mason_lspconfig.setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
  })

  local handlers = require("lsp.handlers")

  local lua_status_ok, neodev = pcall(require, "neodev")
  if not lua_status_ok then
    return
  end

  neodev.setup({
    lspconfig = {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
    },
  })

  local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
  if not lsp_status_ok then
    return
  end

  local opts = {}

  for _, server in pairs(lsp_servers) do
    opts = {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
    }

    server = vim.split(server, "@")[1]

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
      local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
      if not rust_tools_status_ok then
        return
      end
      rust_tools.setup(rust_opts)
      goto continue
    end

    lspconfig[server].setup(opts)
    ::continue::
  end
end

return { setup = setup }
