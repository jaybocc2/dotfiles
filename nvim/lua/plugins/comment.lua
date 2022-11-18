local function setup()
  local comment = jaylib.loadpkg("Comment")
  if comment == nil then return end

  local hints = jaylib.loadpkg("lsp-inlayhints")
  if hints == nil then return end

  local ts_context = jaylib.loadpkg("ts_context_commentstring")
  if ts_context == nil then return end

  comment.setup({
    ignore = "^$",
    pre_hook = function(ctx)
      -- inlay hints
      local line_start = (ctx.srow or ctx.range.srow) - 1
      local line_end = ctx.erow or ctx.range.erow
      hints.clear(0, line_start, line_end)

      ts_context.create_pre_hook()

      if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
        local U = comment.utils

        -- line or block comments
        local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

        -- find start of comment
        local location = nil
        if ctx.ctype == U.ctype.blockwise then
          location = ts_context.utils.get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = ts_context.utils.get_visual_start_location()
        end

        return ts_context.calculate_commentstring({
          key = type,
          location = location,
        })
      end
    end,
  })
end

return { setup = setup }
