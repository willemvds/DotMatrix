vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.tabstop = 4
vim.o.background = "dark"
vim.o.winborder = "rounded"
vim.wo.number = true
vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.diagnostic.config({
	-- Use the default configuration
	virtual_lines = false,

	-- Alternatively, customize specific options
	-- virtual_lines = {
	-- Only show virtual line diagnostics for the current cursor line
	-- current_line = false,
	--},
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

local gb_options = {
	overrides = {
		Keyword = { fg = "#8ec07c" },
		Statement = { fg = "#8ec07c" },
		Conditional = { fg = "#8ec07c" },
		Repeat = { fg = "#8ec07c" },
		Label = { fg = "#8ec07c" },
		-- ["@lsp.type.method"] = { bg = "#8ec07c" },
	},
}

local plugins = {
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = gb_options },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-tree/nvim-tree.lua" },
	{ "neovim/nvim-lspconfig" },
	-- { "ggandor/leap.nvim" },
	{ "nvim-treesitter/nvim-treesitter", lazy = false, branch = "master", build = ":TSUpdate" },
	-- { "nvim-treesitter/nvim-treesitter-context" },
	{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "mcauley-penney/visual-whitespace.nvim", config = true, opts = {} },
	{ "tpope/vim-dispatch" },
	{ "radenling/vim-dispatch-neovim" },
	{ "clojure-vim/vim-jack-in" },
	{ "Olical/conjure" },
}
local opts = {}
require("lazy").setup(plugins, opts)

-- habamax
vim.cmd([[colorscheme gruvbox]])

require("nvim-web-devicons").setup({
	color_icons = true,
	default = true,
})

-- require("leap").create_default_mappings()

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
		"html",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"ruby",
		"rust",
		"sql",
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

vim.lsp.config("clojure-lsp", {
	cmd = { "clojure-lsp" },
	filetypes = { "clojure", "clojurescript", "edn" },
	root_markers = { "deps.edn", ".git" },
	settings = {},
})

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

vim.lsp.config("pylsp", {
	cmd = { ".venv/bin/pylsp" },
	settings = {},
})

vim.lsp.config("zls", {
	settings = {
		zls = {
			semantic_tokens = "partial",
		},
	},
})

vim.g.no_ruby_maps = true
vim.lsp.config("ruby_lsp", {
	cmd = { "ruby-lsp" },
	filetypes = { "ruby", "rb", "eruby" },
	root_markers = { "Gemfile", ".gemspec", ".git" },
	settings = {
		initializationOptions = {
			enabledFeatures = {
				codeActions = true,
				codeLens = true,
				completion = true,
				definition = true,
				diagnostics = true,
				documentHighlights = true,
				documentLink = true,
				documentSymbols = true,
				foldingRanges = true,
				formatting = true,
				hover = true,
				inlayHint = true,
				onTypeFormatting = true,
				selectionRanges = true,
				semanticHighlighting = true,
				signatureHelp = true,
				typeHierarchy = true,
				workspaceSymbol = true,
			},
			formatter = "auto",
			linters = {},
			experimentalFeaturesEnabled = false,
		},
	},
})

vim.lsp.config("solargraph", {
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby", "rb", "eruby" },
	root_markers = { "Gemfile", ".gemspec", ".git" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
		end
	end,
})

-- https://github.com/kristoff-it/superhtml
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "html", "shtml", "htm" },
	callback = function()
		vim.lsp.start({
			name = "superhtml",
			cmd = { "superhtml", "lsp" },
			root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
		})
	end,
})

vim.lsp.enable({
	"clojure-lsp",
	"gopls",
	"rust_analyzer",
	"pylsp",
	"zls",
})

if vim.fn.filereadable(".solargraph.lsp") > 0 then
	vim.lsp.enable({
		"solargraph",
	})
else
	vim.lsp.enable({ "ruby_lsp" })
end

vim.keymap.set("n", "<C-j>", ":bprev<CR>")
vim.keymap.set("n", "<C-k>", ":bnext<CR>")
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("v", "<C-v>", '"+p')
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>h", ":noh<CR>")

-- vim.keymap.set('n', 'w', '<up>')
-- vim.keymap.set('n', 's', '<down>')
-- vim.keymap.set('n', 'a', '<left>')
-- vim.keymap.set('n', 'd', '<right>')
