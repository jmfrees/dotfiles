return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      open_mapping = "<c-t>",
      direction = "float",

      execs = {
        { nil, "<M-1>", "Horizontal Terminal", "horizontal", 0.3 },
        { nil, "<M-2>", "Vertical Terminal", "vertical", 0.4 },
        { nil, "<M-3>", "Float Terminal", "float", nil },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
