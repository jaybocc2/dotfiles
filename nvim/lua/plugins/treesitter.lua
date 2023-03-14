local function setup()
  local ts_configs = jaylib.loadpkg("nvim-treesitter.configs")
  if ts_configs == nil then
    return
  end

  ts_configs.setup({
    ensure_installed = "all",
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" },
    highlight = {
      enable = true,
      disable = { "markdown" },
    },
    autopairs = {
      enabled = true,
    },
    indent = {
      enable = true,
      disable = { "python", "css", "rust" },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = true,
    },
    autotag = {
      enable = true,
      disable = { "xml", "markdown" },
    },
    rainbow = {
      enable = true,
      extended_mode = false,
      disable = { "html" },
    },
  })
end

return { setup = setup }
