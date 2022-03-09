local function config()
  local lspconfig = require('lspconfig')
  local coq = require('coq')

  -- local function saga()
  --   local saga = require('lspsaga')
  --   saga.init_lsp_saga()
  --   --- In lsp attach function
  --   local map = vim.api.nvim_buf_set_keymap
  --   map(0, "n", "gr", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
  --   map(0, "n", "gx", "<cmd>Lspsaga code_action<cr>", {silent = true, noremap = true})
  --   map(0, "x", "gx", ":<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true})
  --   map(0, "n", "K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
  --   map(0, "n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
  --   map(0, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", {silent = true, noremap = true})
  --   map(0, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", {silent = true, noremap = true})
  --   map(0, "n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
  --   map(0, "n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})
  -- end

  local function tsserver()
    lspconfig.tsserver.setup(coq.lsp_ensure_capabilities())
  end

  local function luaserver()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities({
      cmd = { "lua-language-server" },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path
          },
          diagnostics = {
            globals = {'vim'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        }
      }
      }))
  end

  -- saga()
  tsserver()
  luaserver()
end

return config()
