-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set({ "n", "v" }, ";", ":", { remap = true })
vim.keymap.set({ "n" }, "<CR>", ":noh<CR><CR>", { silent = true }) -- clear highlight
vim.keymap.set({ "n", "i" }, "<Up>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Down>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Left>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Right>", "<NOP>", { silent = true })

-- vim.keymap.set("n", "<leader>d", "<NOP>", { noremap = true, silent = true, desc = "+debug" })
-- vim.keymap.set(
--   "n",
--   "<leader>dt",
--   "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
--   { noremap = true, silent = true, desc = "Toggle Breakpoint" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>db",
--   "<cmd>lua require'dap'.step_back()<cr>",
--   { noremap = true, silent = true, desc = "Step Back" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dc",
--   "<cmd>lua require'dap'.continue()<cr>",
--   { noremap = true, silent = true, desc = "Continue" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dC",
--   "<cmd>lua require'dap'.run_to_cursor()<cr>",
--   { noremap = true, silent = true, desc = "Run To Cursor" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dd",
--   "<cmd>lua require'dap'.disconnect()<cr>",
--   { noremap = true, silent = true, desc = "Disconnect" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dg",
--   "<cmd>lua require'dap'.session()<cr>",
--   { noremap = true, silent = true, desc = "Get Session" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>di",
--   "<cmd>lua require'dap'.step_into()<cr>",
--   { noremap = true, silent = true, desc = "Step Into" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>do",
--   "<cmd>lua require'dap'.step_over()<cr>",
--   { noremap = true, silent = true, desc = "Step Over" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>du",
--   "<cmd>lua require'dap'.step_out()<cr>",
--   { noremap = true, silent = true, desc = "Step Out" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dp",
--   "<cmd>lua require'dap'.pause()<cr>",
--   { noremap = true, silent = true, desc = "Pause" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>dr",
--   "<cmd>lua require'dap'.repl.toggle()<cr>",
--   { noremap = true, silent = true, desc = "Toggle Repl" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>ds",
--   "<cmd>lua require'dap'.continue()<cr>",
--   { noremap = true, silent = false, desc = "Start" }
-- )
-- vim.keymap.set("n", "<leader>dq", "<cmd>lua require'dap'.close()<cr>", { noremap = true, silent = true, desc = "Quit" })
-- vim.keymap.set(
--   "n",
--   "<leader>dU",
--   "<cmd>lua require'dapui'.toggle({reset = true})<cr>",
--   { noremap = true, silent = false, desc = "Toggle UI" }
-- )

-- Refactoring keymaps
vim.api.nvim_set_keymap(
  "v",
  "<leader>re",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rv",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>ri",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>rb",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>rbf",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ri",
  [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
)
