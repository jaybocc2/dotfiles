local icons = require("icons")

local function modified_buffer()
  if vim.bo.modified then
    return [[Modified]]
  else
    return [[]]
  end
end

local function get_null_ls_registered_providers(ft)
  local package = jaylib.loadpkg("null-ls.sources")
  if package == nil then
    return
  end

  local available_sources = package.get_available(ft)
  local registered = {}

  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

local function get_null_ls_formatters(ft)
  local package = jaylib.loadpkg("null-ls.methods")
  if package == nil then
    return
  end

  local providers = get_null_ls_registered_providers(ft)
  if providers ~= nil then
    return providers[package.FORMATTING] or {}
  end
  return {}
end

local function get_null_ls_linters(ft)
  local package = jaylib.loadpkg("null-ls.methods")
  if package == nil then
    return
  end

  local providers = get_null_ls_registered_providers(ft)
  local methods = vim.tbl_flatten(vim.tbl_map(function(m)
    if providers ~= nil then
      return providers[m] or {}
    end
    return {}
  end, {
    package.DIAGNOSTICS,
    package.DIAGNOSTICS_ON_OPEN,
    package.DIAGNOSTICS_ON_SAVE,
  }))
  return methods
end

local components = {
  diff = {
    "diff",
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    symbols = {
      added = icons.git.Add .. " ",
      modified = icons.git.Mod .. " ",
      removed = icons.git.Remove .. " ",
    },
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic", "nvim_lsp" },
    symbols = {
      error = icons.diagnostics.BoldError .. " ",
      warn = icons.diagnostics.BoldWarning .. " ",
      info = icons.diagnostics.BoldInformation .. " ",
      hint = icons.diagnostics.BoldHint .. " ",
    },
  },
  treesitter = {
    function()
      return icons.ui.Tree
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and "#98be65" or "#ec5f67" }
    end,
  },
  lsp = {
    function(msg)
      msg = msg or "LS Inactive"
      local buf_clients = vim.lsp.buf_get_clients()
      if next(buf_clients) == nil then
        -- TODO: clean up this if statement
        if type(msg) == "boolean" or #msg == 0 then
          return "LS Inactive"
        end
        return msg
      end
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      -- add formatter
      local supported_formatters = get_null_ls_formatters(buf_ft)
      vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      local supported_linters = get_null_ls_linters(rbuf_ft)
      vim.list_extend(buf_client_names, supported_linters)

      local unique_client_names = vim.fn.uniq(buf_client_names)

      local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

      if copilot_active then
        language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
      end

      return language_servers
    end,
    color = { gui = "bold" },
    -- cond = conditions.hide_in_width,
  },
}

local function setup()
  local lualine = jaylib.loadpkg("lualine")
  if lualine == nil then
    return
  end

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "auto",
    },
    sections = {
      lualine_a = {
        -- mode
        {
          function()
            return " " .. icons.ui.Target .. " "
          end,
        },
      },
      lualine_b = {
        -- branch
        {
          "b:gitsigns_head",
          -- icon = "%#SLGitIcon#" .. icons.git.Branch .. "%*" .. "%#SLBranchName#",
          icon = icons.git.Branch,
          color = { gui = "bold" },
        },
        "filename",
      },
      lualine_c = { components.diff },
      lualine_x = {
        components.diagnostics,
        components.lsp,
        components.treesitter,
      },
      lualine_y = { "encoding", "fileformat", "filetype" },
      lualine_z = {
        {
          "progress",
          fmt = function()
            return "%P/%L"
          end,
          color = {},
        },
        "location",
      },
    },
  })
end

return { setup = setup }
