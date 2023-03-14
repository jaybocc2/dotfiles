local function setup()
  -- " Add `:Format` command to format current buffer.
  -- command! -nargs=0 Format :call CocActionAsync('format')
  -- vim.api.nvim_create_user_command("Format", 'call CocActionAsync("format")', { nargs = 0 })

  -- " Add `:Fold` command to fold current buffer.
  -- command! -nargs=? Fold :call     CocAction('fold', <f-args>)
  -- vim.api.nvim_create_user_command("Fold", 'call CocAction("fold", <f-args>)', { nargs = "?" })
  -- vim.opt.foldmethod     = 'expr'
  -- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  ---WORKAROUND
  --[[ vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),

    callback = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  }) ]]

  -- " Add `:OR` command for organize imports of the current buffer.
  -- command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
  -- vim.api.nvim_create_user_command(
  --     "OR",
  --     'call CocActionAsync("runCommand", "editor.action.organizeImport")',
  --     { nargs = 0 }
  -- )
end

return { setup = setup }
