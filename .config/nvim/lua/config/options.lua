-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.display = "lastline"
vim.opt.wrap = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.clipboard = ""
-- vim.opt.tabstop = 8
-- vim.opt.shiftwidth = 8
-- vim.opt.expandtab = true
