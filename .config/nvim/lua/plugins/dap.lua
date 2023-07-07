local M = {
  "mfussenegger/nvim-dap",
  ft = {
    "go",
    "javascript",
    "javascriptreact",
    "python",
    "typescript",
    "typescriptreact",
  },
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
  },
}

M.config = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local dap_vt = require("nvim-dap-virtual-text")
  local dap_python = require("dap-python")
  local dap_go = require("dap-go")

  dap_vt.setup({
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
    all_references = false, -- show virtual text on all all references of the variable (not only definitions)
    filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)

    -- Experimental Features:
    virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  })

  -- DAP UI
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7"),
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    windows = { indent = 1 },
    render = {
      max_type_length = nil, -- Can be integer or nil.
    },
  })

  vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

  dap.set_log_level("TRACE")

  -- Enable virtual text
  vim.g.dap_virtual_text = true

  dap_go.setup({
    -- Additional dap configurations can be added.
    -- dap_configurations accepts a list of tables where each entry
    -- represents a dap configuration. For more details do:
    -- :help dap-configuration
    dap_configurations = {
      {
        -- Must be "go" or it will be ignored by the plugin
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },
    -- delve configurations
    delve = {
      -- the path to the executable dlv which will be used for debugging.
      -- by default, this is the "dlv" executable on your PATH.
      path = "dlv",
      -- time to wait for delve to initialize the debug session.
      -- default to 20 seconds
      initialize_timeout_sec = 30,
      -- a string that defines the port to start delve debugger.
      -- default to string "${port}" which instructs nvim-dap
      -- to start the process in a random available port
      port = "${port}",
      -- additional args to pass to dlv
      args = {},
    },
  })
  dap_python.setup(vim.fn.system("which python"))
end

return M
