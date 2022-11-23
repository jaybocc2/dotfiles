local icons = require("icons")
-- local comparators = require("plugins.cmp.comparators")
-- local servers = require("plugins.cmp.servers")

local buffer_fts = {
  "markdown",
  "toml",
  "yaml",
  "json",
}

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  calc = "(Calc)",
  cmp_tabnine = "(Tabnine)",
  vsnip = "(Snippet)",
  luasnip = "(Snippet)",
  buffer = "(Buffer)",
  tmux = "(TMUX)",
  copilot = "(Copilot)",
  treesitter = "(TreeSitter)",
}

local custom_sources = {
  copilot = {
    name = "copilot",
    -- keyword_length = 0,
    max_item_count = 3,
    trigger_characters = {
      {
        ".",
        ":",
        "(",
        "'",
        '"',
        "[",
        ",",
        "#",
        "*",
        "@",
        "|",
        "=",
        "-",
        "{", -- have to put this here for syntax weirdness }
        "/",
        "\\",
        "+",
        "?",
        " ",
        -- '\t',
        -- '\n',
      },
    },
  },
  nvim_lsp = {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
      if kind == "Snippet" and ctx.prev_context.filetype == "java" then
        return false
      end

      if kind == "Text" then
        return false
      end
      return true
    end,
  },
}

local duplicates = {
  buffer = 1,
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}

local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local function format(entry, vim_item)
  local max_width = 0 -- lvim.builtin.cmp.formatting.max_width
  if max_width ~= 0 and #vim_item.abbr > max_width then
    vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
  end
  vim_item.kind = icons.kind[vim_item.kind]

  if entry.source.name == "copilot" then
    vim_item.kind = icons.git.Octoface
    vim_item.kind_hl_group = "CmpItemKindCopilot"
  end

  if entry.source.name == "cmp_tabnine" then
    vim_item.kind = icons.misc.Robot
    vim_item.kind_hl_group = "CmpItemKindTabnine"
  end

  if entry.source.name == "crates" then
    vim_item.kind = icons.misc.Package
    vim_item.kind_hl_group = "CmpItemKindCrate"
  end

  if entry.source.name == "lab.quick_data" then
    vim_item.kind = icons.misc.CircuitBoard
    vim_item.kind_hl_group = "CmpItemKindConstant"
  end

  if entry.source.name == "emoji" then
    vim_item.kind = icons.misc.Smiley
    vim_item.kind_hl_group = "CmpItemKindEmoji"
  end

  vim_item.menu = source_names[entry.source.name]
  vim_item.dup = duplicates[entry.source.name] or 0

  return vim_item
end

local function setup()
  local cmp = jaylib.loadpkg("cmp")
  if cmp == nil then
    return
  end

  local luasnip = jaylib.loadpkg("luasnip")
  if luasnip == nil then
    return
  end

  local under_comparator = function(entry1, entry2)
    local under = jaylib.loadpkg("cmp-under-comparator")
    if under == nil then
      return cmp.config.compare.score(entry1, entry2)
    end
    return under.under(entry1, entry2)
  end

  local copilot_prioritize = function(entry1, entry2)
        -- require("copilot_cmp.comparators").prioritize,
    local copilot_comp_prioritize = jaylib.loadpkg("copilot_cmp.comparators")
    if copilot_comp_prioritize == nil then
      return cmp.config.compare.offset(entry1, entry2)
    end
    return copilot_comp_prioritize.prioritize(entry1, entry2)
  end

  local copilot_score = function(entry1, entry2)
    -- require("copilot_cmp.comparators").score,
    local copilot_comp_score = jaylib.loadpkg("copilot_cmp.comparators")
    if copilot_comp_score == nil then
      return cmp.config.compare.offset(entry1, entry2)
    end
    return copilot_comp_score.score(entry1, entry2)
  end

  require("luasnip.loaders.from_vscode").lazy_load()
  require("plugins.tabnine").setup()

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
    -- preselect = cmp.PreselectMode.None,
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
        elseif jaylib.check_backspace() then
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
      format = format,
    },
    sources = {
      custom_sources.copilot,
      custom_sources.nvim_lsp,
      { name = "path" },
      { name = "luasnip" },
      { name = "cmp_tabnine" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "calc" },
      { name = "emoji" },
      { name = "treesitter" },
      { name = "crates" },
      { name = "tmux" },
      -- { name = "lab.quick_data", keyword_length = 4, group_index = 2 }, maybe enable if i like https://github.com/0x100101/lab.nvim
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        -- require("copilot_cmp.comparators").prioritize,
        -- require("copilot_cmp.comparators").score,
        copilot_prioritize,
        copilot_score,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        -- cmp.config.compare.scopes,
        cmp.config.compare.score,
        under_comparator,
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
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
      -- documentation = false,
      -- documentation = {
      --   border = "rounded",
      --   winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      -- },
      -- completion = {
      --   border = "rounded",
      --   winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      -- },
    },
    experimental = {
      ghost_text = true,
    },
  })
end

return { setup = setup }
