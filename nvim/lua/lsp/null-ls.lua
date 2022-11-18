local null_ls = jaylib.loadpkg("null-ls")
if null_ls == nil then return end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
local function setup()
  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier.with({
        extra_filetypes = {
          "toml",
          "solidity",
        },
        extra_args = {
          "--no-semi",
          "--single-quore",
          "--jsx-single-quote",
        },
      }),
      formatting.black.with({ extra_args = { "--fast" } }),
      formatting.stylua,
      formatting.shfmt,
      formatting.google_java_format,
      diagnostics.flake8,
      diagnostics.shellcheck,
    },
  })

  -- TODO: add unwrapper for null_ls if needed
end

return { setup = setup }
