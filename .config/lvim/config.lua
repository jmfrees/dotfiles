-- visuals
vim.opt.wrap = true

-- information
vim.opt.relativenumber = true

-- functional
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf8"
vim.opt.history = 10000
vim.opt.mouse = "a"
vim.opt.shell = "/bin/fish"
vim.opt.wildmode = "longest,full"
vim.cmd([[filetype plugin indent on]])

-- buffers
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- mappings
vim.keymap.set({ "n", "v" }, ";", ":", { remap = true })
vim.keymap.set({ "n" }, "<CR>", ":noh<CR><CR>", { silent = true })
vim.keymap.set({ "n" }, "<Leader>,", ":set invlist<CR>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Up>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Down>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Left>", "<NOP>", { silent = true })
vim.keymap.set({ "n", "i" }, "<Right>", "<NOP>", { silent = true })

-- lvim
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
-- lvim.lsp.installer.setup.automatic_installation = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"css",
	"fish",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"python",
	"rust",
	"tsx",
	"typescript",
	"yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python" } },
	{ command = "isort", filetypes = { "python" } },
	{
		command = "prettier",
		extra_args = { "--print-width", "80" },
		filetypes = { "typescript", "typescriptreact", "html", "css", "markdown", "yaml" },
	},
	{ command = "rustfmt", filetypes = { "rust" } },
	{ command = "shfmt", filetypes = { "sh", "bash" } },
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "sql-formatter", filetypes = { "sql" } },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "shellcheck", filetypes = { "sh", "bash" } },
	{ command = "checkmake", filetypes = { "Makefile" } },
	{ command = "hadolint", filetypes = { "docker" } },
})

-- Additional Plugins
lvim.plugins = {
	{ "folke/tokyonight.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		cmd = "MarkdownPreview",
	},
	{
		"ggandor/lightspeed.nvim",
		event = "BufEnter",
		config = function()
			require("lightspeed")
		end,
	},
	{
		"echasnovski/mini.nvim",
		-- after = "nvim-web-devicons",
		config = function()
			require("mini.indentscope").setup()
			require("mini.sessions").setup()
			-- require("mini.surround").setup()
			require("mini.trailspace").setup()
		end,
	},
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	},
	{ "hrsh7th/cmp-cmdline", after = "cmp-path" },
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
		setup = function()
			vim.o.timeoutlen = 500
		end,
	},
	{ "tpope/vim-repeat" },
}

vim.api.nvim_create_autocmd(
	"BufReadPost",
	{ pattern = "*", command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]] }
)
vim.api.nvim_create_autocmd("FileType", { pattern = "md,markdown,svn,*commmit*", command = [[setlocal spell]] })
