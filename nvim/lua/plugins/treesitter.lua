local function setup()
  local status_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end
  require("nvim-treesitter.configs").setup({
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
