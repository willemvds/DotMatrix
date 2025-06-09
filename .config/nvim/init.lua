vim.opt.cursorline = true
vim.opt.showcmd = true
vim.o.background = "dark"
vim.o.winborder = "rounded"
vim.wo.number = true
vim.g.mapleader = ","

vim.diagnostic.config({
	-- Use the default configuration
	-- virtual_lines = true,

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-tree/nvim-tree.lua" },
	{ "neovim/nvim-lspconfig" },
	--{"olical/conjure"},
	{ "ggandor/leap.nvim" },
	{ "nvim-treesitter/nvim-treesitter", lazy = false, branch = "master", build = ":TSUpdate" },
	{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
}
local opts = {}
require("lazy").setup(plugins, opts)

--habamax
vim.cmd([[colorscheme gruvbox]])

require("nvim-web-devicons").setup({
	color_icons = true,
	default = true,
})

require("leap").create_default_mappings()

require("nvim-tree").setup({
	view = {
		adaptive_size = true,
	},
})
vim.keymap.set("n", "<c-b>", ":NvimTreeFindFileToggle<CR>", { silent = true })

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"clojure",
		"go",
		"lua",
		"markdown",
		"markdown_inline",
		"query",
		"rust",
		"vim",
		"vimdoc",
	},
	highlight = {
		enable = true,
	},
	auto_install = true,
})

require("fzf-lua").setup()
vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<cr>", { silent = true })

require("lualine").setup({})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {},
	},
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			vulncheck = "Imports",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
		end
	end,
})

vim.lsp.enable({
	"gopls",
	"rust_analyzer",
})

vim.keymap.set("n", "<C-j>", ":bprev<CR>")
vim.keymap.set("n", "<C-k>", ":bnext<CR>")
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("v", "<C-v>", '"+p')
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- vim.keymap.set('n', 'w', '<up>')
-- vim.keymap.set('n', 's', '<down>')
-- vim.keymap.set('n', 'a', '<left>')
-- vim.keymap.set('n', 'd', '<right>')
