local jdtls_enabled = require("lsp.settings.jdtls").enabled

if jdtls_enabled then
  local jdtls_config = require("lsp.settings.jdtls").setup()
  jaylib.loadpkg("jdtls").start_or_attach(jdtls_config)
end
