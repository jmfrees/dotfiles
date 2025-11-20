return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
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
          -- "rustfmt",
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
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        accept = "<M-l>",
        enabled = true,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = true,
      },
      model = "claude-sonnet-4",
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "claude-sonnet-4",
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        functions = {
          files = {
            group = "copilot",
            uri = "files://multi/{pattern}",
            description = "Reads content from multiple files matching a glob pattern.",

            schema = {
              type = "object",
              required = { "pattern" },
              properties = {
                pattern = {
                  type = "string",
                  description = "Glob pattern to match files",
                  default = "**/*.lua",
                },
                max_files = {
                  type = "number",
                  description = "Maximum number of files to read",
                  default = 10,
                },
              },
            },

            resolve = function(input, source)
              local utils = require("CopilotChat.utils")
              local resources = require("CopilotChat.resources")

              if utils.empty(input.pattern) then
                error("Pattern is required")
              end

              local files = utils.glob(source.cwd(), {
                pattern = input.pattern,
                max_count = input.max_files or 10,
              })

              if #files == 0 then
                return {
                  {
                    uri = "files://multi/" .. input.pattern,
                    mimetype = "text/plain",
                    data = "No files found matching: " .. input.pattern,
                  },
                }
              end

              local results = {}
              local max_size = 100000 -- 100KB per file

              for _, file_path in ipairs(files) do
                local stat = vim.loop.fs_stat(file_path)
                if stat and stat.size <= max_size then
                  local data, mimetype = resources.get_file(file_path)
                  if data then
                    table.insert(results, {
                      uri = "file://" .. file_path,
                      name = file_path, -- This becomes the header
                      mimetype = mimetype,
                      data = data, -- Raw content - CopilotChat will format it!
                    })
                  end
                end
              end

              return results
            end,
          },
        },
      }
    end,
  },
}
