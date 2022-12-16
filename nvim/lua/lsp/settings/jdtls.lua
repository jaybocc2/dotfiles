local opts = {
  cmd = {},
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {},
        filteredTypes = {
          -- "com.sun.*",
          -- "io.micrometer.shaded.*",
          -- "java.awt.*",
          -- "jdk.*",
          -- "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home",
            default = true,
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home",
          },
          {
            name = "JavaSE-19",
            path = "/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home",
          },
        },
      },
    },
  },
}

local function setup()
  local jdtls = jaylib.loadpkg("jdtls")
  if jdtls == nil then
    return {}
  end

  -- local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

  local root_markers = { ".gradle", "gradlew", ".git" }
  local root_dir = jdtls.setup.find_root(root_markers)
  local home = os.getenv("HOME")
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

  opts.cmd = {
    jdtls_bin,
    "-data",
    workspace_dir,
  }
  local common_opts = require("lsp").get_common_options()

  local on_attach = function(client, bufnr)
    jdtls.setup.add_commands()
    -- vim.lsp.codelens.refresh()
    -- if JAVA_DAP_ACTIVE then
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.dap.setup_dap_main_class_configs()
    -- end
    common_opts.on_attach(client, bufnr)
  end

  opts.on_attach = on_attach
  opts.capabilities = common_opts.capabilities
  return opts
end

return { setup = setup }
