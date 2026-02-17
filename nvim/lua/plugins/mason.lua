return {
  -- add any tools you want to have installed below
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "bashls",
        "flake8",
        -- "gopls",
        -- "gradle_ls",
        -- "groovyls",
        -- "jsonls",
        "lua-language-server",
        "markdownlint",
        "marksman",
        "misspell",
        -- "prosemd_lsp",
        "protolint",
        -- "pylint8",
        "pyright",
        -- "rust_analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        -- "terraform-ls", -- disabled as it currently appears to crash my macbook
        -- "tsserver",
        -- "yamlls",
      },
    },
  },
}
