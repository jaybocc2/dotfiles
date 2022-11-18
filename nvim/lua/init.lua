-- local function options()
--     vim.api.nvim_set_var("python3_host_prog", vim.fn.expand("~/.pyenv/versions/neovim3/bin/python"))
--
--     -- coc vars
--     vim.api.nvim_set_var("coc_global_extensions", {
--         -- 'coc-flutter',
--         "coc-git",
--         "coc-go",
--         "coc-sumneko-lua",
--         "coc-markdownlint",
--         "coc-pyright",
--         "coc-rust-analyzer",
--         "coc-snippets",
--         "coc-tsserver",
--         "coc-eslint",
--     })
--     vim.api.nvim_set_var("coc_user_config", require("lsp").config())
--     vim.api.nvim_set_var("coc_snippet_next", "<tab>")
-- end

-- configure lualine
-- local function lualine_config()
--     local function modified_buffer()
--         if vim.bo.modified then
--             return [[Modified]]
--         else
--             return [[]]
--         end
--     end
--
--     require("lualine").setup({
--         options = {
--             icons_enabled = true,
--             theme = "auto",
--         },
--         sections = {
--             lualine_a = { "mode" },
--             lualine_b = { "branch", "diff", modified_buffer },
--             lualine_c = { "filename" },
--             lualine_x = { "diagnostics", "g:coc_status" },
--             lualine_y = { "encoding", "fileformat", "filetype" },
--             lualine_z = { "progress", "location" },
--         },
--     })
--     vim.opt.showmode = false -- set to false when / if use lualine
-- end

-- local function chadtree_config()
--     local chadtree_settings = {
--         ignore = {
--             name_glob = {
--                 "*.d.ts",
--                 "*.js",
--             },
--         },
--     }
--
--     vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
-- end

-- local function indent_blankline()
--     vim.opt.list = true
--     vim.opt.listchars:append("eol:↴")
--     require("indent_blankline").setup({
--         space_char_blankline = " ",
--         show_current_context = true,
--         show_current_context_start = true,
--     })
-- end

-- local config = function()
--     options()
--     indent_blankline()
--     chadtree_config()
--     lualine_config()
--
--     require("fidget").setup()
-- end

local setup = function()
  -- load my libs
  -- jaylib = require("jaylib")
  require("jaylib")
  -- load impatient plugin to profile start time
  require("plugins.impatient").setup()
  -- override default vim notification w/ notify plugin
  require("plugins.notify").setup()

  -- load packages
  local plugins = require("plugins")
  -- bootstrap w/ packages
  require("bootstrap").setup(plugins.packages)
  -- require("bootstrap").setup(require("plugins").packages)

  -- load vim options
  require("options").setup()
  -- load globals
  require("globals").setup()
  -- load keybinds
  require("keybinds").setup()
  -- load custom commands
  require("commands").setup()

  require("plugins.cmp").setup()
  require("plugins.inlayhints").setup()
  require("lsp").setup()
  require("plugins.telescope").setup()
  require("plugins.treesitter").setup()
  require("plugins.comment").setup()
  require("plugins.gitsigns").setup()
  -- autopairs
  require("plugins.nvim-tree").setup()
  require("plugins.bufferline").setup()
  require("plugins.lualine").setup()
  -- toggleterm
  -- project
  -- illuminate
  -- indentline
  -- alpha
  -- dap
end

return { setup = setup }
