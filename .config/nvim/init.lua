vim.opt.cursorline = false
vim.opt.showcmd = true

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
	{"ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
	{"nvim-lualine/lualine.nvim"},
	{"nvim-tree/nvim-web-devicons"},
	{"nvim-tree/nvim-tree.lua"},
	{"neovim/nvim-lspconfig"},
	{"Olical/conjure"},
}

local opts = {}

require("lazy").setup(plugins, opts)

require("nvim-tree").setup()

--habamax
vim.o.background = "dark" 
vim.cmd([[colorscheme gruvbox]])


local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {},
  },
}

lspconfig.clojure_lsp.setup {
}

require("nvim-web-devicons").setup({
 color_icons = true,
 default = true,
})

require("lualine").setup({
  sections = {
    lualine_x = {
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = { fg = "#ff9e64" },
      },
    },
  },
})

vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>')

