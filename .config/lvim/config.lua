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
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- lvim
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
-- lvim.lsp.installer.setup.automatic_installation = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}

lvim.builtin.alpha.active = false
lvim.builtin.nvimtree.active = false
lvim.builtin.lir.active = false
lvim.builtin.illuminate.active = false
lvim.builtin.dap.active = true
lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = "<c-t>"

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
		filetypes = { "typescript", "typescriptreact", "javascript", "html", "css", "markdown", "yaml" },
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

-- nvim-dap
local dap = require("dap")
dap.adapters.python = {
	type = "executable",
	command = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/debugpy/venv/bin/python"),
	args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${file}", -- This configuration will launch the current file if used.
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return "/usr/bin/python"
			end
		end,
	},
}

-- Additional Plugins
lvim.plugins = {
	{ "folke/tokyonight.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{ "tpope/vim-surround" },
	{ "tpope/vim-repeat" },
}

vim.api.nvim_create_autocmd(
	"BufReadPost",
	{ pattern = "*", command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]] }
)
vim.api.nvim_create_autocmd("FileType", { pattern = "md,markdown,svn,*commmit*", command = [[setlocal spell]] })
