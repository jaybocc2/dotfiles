local function setup()
  local hints = jaylib.loadpkg("lsp-inlayhints")
  if hints == nil then return end

  local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      hints.on_attach(client, args.buf)
    end,
  })

  hints.setup({
    inlay_hints = {
      parameter_hints = {
        show = true,
        separator = ", ",
      },
      type_hints = {
        show = true,
        prefix = "",
        separator = ", ",
        remove_colon_end = false,
        remove_colon_start = false,
      },
      labels_separator = "  ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment",
    },
    debug_mode = false,
  })
end

return { setup = setup }
