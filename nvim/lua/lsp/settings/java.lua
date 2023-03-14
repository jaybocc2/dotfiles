local opts = {
  cmd = {
    "java-language-server",
  },
  filetypes = {
    "java",
  },
}

local util = jaylib.loadpkg('lspconfig.util')
if util ~= nil then
  opts.root_dir = util.root_pattern(
    "WORKSPACE",
    "BUILD",
    "build.gradle",
    "pom.xml"
  )
end


return opts
