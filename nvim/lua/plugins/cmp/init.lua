local buffer_fts = {
  "markdown",
  "toml",
  "yaml",
  "json",
}

local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local icons = require("icons")

local function setup()
  local status_ok, cmp = pcall(require, "cmp")
  if not status_ok then
    vim.notify("failed to load cmp in plugins/cmp.lua", "error")
    return
  end

  local status_ok2, luasnip = pcall(require, "luasnip")
  if not status_ok2 then
    vim.notify("failed to load luasnip in plugins/cmp.lua", "error")
    return
  end

  require("luasnip.loaders.from_vscode").lazy_load()

  local status_ok3, tabnine = pcall(require, "plugins.tabnine")
  if not status_ok3 then
    vim.notify("failed to load tabnine in plugins/cmp.lua", "error")
    return
  else
    tabnine.setup()
  end

  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
  vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
  vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
  vim.g.cmp_active = true

  cmp.setup({
    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      if buftype == "prompt" then
        return false
      end
      return vim.g.cmp_active
    end,
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<m-o>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-c>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-j>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-k>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<m-c>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<S-CR>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<Right>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif _G.check_backspace() then
          -- cmp.complete()
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = icons.kind[vim_item.kind]

        if entry.source.name == "cmp_tabnine" then
          vim_item.kind = icons.misc.Robot
          vim_item.kind_hl_group = "CmpItemKindTabnine"
        end
        if entry.source.name == "copilot" then
          vim_item.kind = icons.git.Octoface
          vim_item.kind_hl_group = "CmpItemKindCopilot"
        end

        if entry.source.name == "emoji" then
          vim_item.kind = icons.misc.Smiley
          vim_item.kind_hl_group = "CmpItemKindEmoji"
        end

        if entry.source.name == "crates" then
          vim_item.kind = icons.misc.Package
          vim_item.kind_hl_group = "CmpItemKindCrate"
        end

        if entry.source.name == "lab.quick_data" then
          vim_item.kind = icons.misc.CircuitBoard
          vim_item.kind_hl_group = "CmpItemKindConstant"
        end

        -- NOTE: order matters
        vim_item.menu = ({
          nvim_lsp = "",
          nvim_lua = "",
          luasnip = "",
          buffer = "",
          path = "",
          emoji = "",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = "crates", group_index = 1 },
      {
        name = "copilot",
        -- keyword_length = 0,
        max_item_count = 3,
        trigger_characters = {
          {
            ".",
            ":",
            "(",
            "'",
            "'",
            "[",
            ",",
            "#",
            "*",
            "@",
            "|",
            "=",
            "-",
            "{",
            "/",
            "\\",
            "+",
            "?",
            " ",
            -- '\t',
            -- '\n',
          },
        },
        group_index = 2,
      },
      {
        name = "nvim_lsp",
        filter = function(entry, ctx)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return true
          end

          if kind == "Text" then
            return true
          end
        end,
        group_index = 2,
      },
      { name = "nvim_lua", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      {
        name = "buffer",
        group_index = 2,
        filter = function(entry, ctx)
          if not contains(buffer_fts, ctx.prev_context.filetype) then
            return true
          end
        end,
      },
      { name = "cmp_tabnine", group_index = 2 },
      { name = "path", group_index = 2 },
      { name = "emoji", group_index = 2 },
      { name = "lab.quick_data", keyword_length = 4, group_index = 2 },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        -- require("copilot_cmp.comparators").prioritize,
        -- require("copilot_cmp.comparators").score,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        -- cmp.config.compare.scopes,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        -- cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        -- require("copilot_cmp.comparators").prioritize,
        -- require("copilot_cmp.comparators").score,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      documentation = false,
      -- documentation = {
      --   border = "rounded",
      --   winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      -- },
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    },
    experimental = {
      ghost_text = true,
    },
  })
end

return { setup = setup }
