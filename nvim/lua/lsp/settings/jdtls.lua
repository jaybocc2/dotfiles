local enabled = true

local root_markers = {
  "WORKSPACE",
  "BUILD",
  ".gradle",
  "gradlew",
  "build.gradle",
  "settings.gradle",
  ".git",
}

local opts = {
  autostart = true,
  capabilities = {},
  cmd = {},
  init_options = {
    bundles = { }
  },
  on_attach = function() end,
  -- settings can be seen at https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {},
      },
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
      format = {
        enabled = true,
      },
      import = {
        bazel = {
          enabled = true,
          src = {
            path = "/src/main/java"
          }
        },
        gradle = {
          enabled = true
        },
        maven = {
          enabled = true
        },
      },
      project = {
        sourcePaths = {
          "src",
        },
        outPath = "bazel-out",
      },
      saveActions = {
        organizeImports = true,
      },
      signatureHelp = { enabled = true },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}

local function get_jdk_runtimes()
  local runtimes = {}
  local dir_prefix = "/Library/Java/JavaVirtualMachines/"
  local dir_affix = "/Contents/Home"

  if vim.fn.isdirectory(dir_prefix) <= 0 then
    dir_prefix = "/usr/lib/java/"
    dir_affix = ""
    if vim.fn.isdirectory(dir_prefix) <= 0 then
      return runtimes
    end
  end

  for value, _ in vim.fs.dir(dir_prefix) do
    local version = value:match(".*-(%d+).")
    if version == "8" then
      version = "1.8"
    end

    runtimes[version] = dir_prefix .. value .. dir_affix
  end

  return runtimes
end

local function set_jdk_runtimes()
  local runtimes = get_jdk_runtimes()
  for version, path in pairs(runtimes) do
    table.insert(
      opts.settings.java.configuration.runtimes,
      {
        name = "JavaSE-" .. version,
        path = path,
      }
    )
  end
end

local function build_cmd()
  local runtimes =  get_jdk_runtimes()
  if runtimes == nil then return {} end
  -- local java = runtimes["17"] .. "/bin/java"
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local shared_config_path = ""
  local os_name = os.execute("uname")
  if string.lower(os_name) == "darwin" then
    shared_config_path = jdtls_path .. "/config_mac"
  else
    shared_config_path = jdtls_path .. "/config_linux"
  end

  -- local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local home = os.getenv("HOME")
  local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

  local cmd = {
    "java",
    "-javaagent:" .. vim.fn.glob(home .. "/.local/libs/jdtls/lombok/lombok*.jar"),
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. shared_config_path,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Xms4G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", shared_config_path,
    "-data", workspace_dir,
  }

  return cmd
end

local function find_file_in_dir(dir, search)
  if vim.fn.isdirectory(dir) <= 0 then return "" end
  for value, _ in vim.fs.dir(dir) do
    local file = value:match(search)
    return file
  end
end

local function find_files_in_dir(dir, search)
  local files = {}
  if vim.fn.isdirectory(dir) <= 0 then return files end
  for value, type in vim.fs.dir(dir) do
    if type == "file" then
      local file = value:match(search)
      table.insert(files, dir .. file)
    end
  end
  return files
end

local function setup()
  local jdtls = jaylib.loadpkg("jdtls")
  if jdtls == nil then
    return {}
  end

  set_jdk_runtimes()

  local root_dir = jdtls.setup.find_root(root_markers)
  opts.root_dir = root_dir

  local bundles = find_files_in_dir(os.getenv("HOME") .. "/.local/libs/jdtls/bazel", "(*.jar)")
  for _, v in ipairs(bundles) do
    table.insert(opts.init_options.bundles, v)
  end

  local dap_plugin_jar_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/"
  local dap_plugin_jar = find_file_in_dir(dap_plugin_jar_path, "(com.microsoft.java.debug.plugin-.*.jar)")
  if dap_plugin_jar ~= nil then
    table.insert(opts.init_options.bundles, dap_plugin_jar_path .. dap_plugin_jar)
  end

  opts.cmd = build_cmd()

  local common_opts = require("lsp").get_common_options()

  local on_attach = function(client, bufnr)
    vim.notify("jdtls on_attach called")
    vim.lsp.codelens.refresh()
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require('jdtls.dap').setup_dap_main_class_configs()
    require('jdtls.setup').add_commands()
    common_opts.on_attach(client, bufnr)
  end

  opts.on_attach = on_attach
  opts.capabilities = common_opts.capabilities
  return opts
end

return { setup = setup, enabled = enabled }
