return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- nls.builtins.diagnostics.pydocstyle,
          nls.builtins.hover.printenv,
          nls.builtins.hover.dictionary,

          nls.builtins.formatting.trim_newlines,
          nls.builtins.formatting.trim_whitespace,
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_setup = true,
        automatic_installation = false,
        ensure_installed = {
          "actionlint",
          "ansiblelint",
          "beautysh",
          "fish",
          "fish_indent",
          "gofumpt",
          "goimports",
          "golangci_lint",
          -- "golines",
          "gopls",
          "isort",
          "prettier",
          "python-black",
          "rust_analyzer",
          "rustfmt",
          "shellharden",
          "sql_formatter",
          "stylua",
          "taplo",
        },
        handlers = {},
      })
    end,
  },
  -- Add/change/delete surrounding delimiter pairs
  {
    "kylechui/nvim-surround",
    version = "*",
    config = true,
    event = "VeryLazy",
  },
}
