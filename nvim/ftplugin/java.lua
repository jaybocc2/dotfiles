local jdtls_config = require("lsp.settings.jdtls").setup()

jaylib.loadpkg("jdtls").start_or_attach(jdtls_config)
