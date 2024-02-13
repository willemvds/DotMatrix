vim.opt.cursorline = true
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
	{"ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }},
}

local opts = {}

require("lazy").setup(plugins, opts)

require("nvim-tree").setup()

require("fzf-lua").setup()

--habamax
vim.o.background = "dark" 
vim.cmd([[colorscheme gruvbox]])

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {},
  },
}

lspconfig.gopls.setup {
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


vim.keymap.set('n', '<C-b>', ':NvimTreeFindFileToggle<CR>', { silent = true })
-- vim.keymap.set('n', 'w', '<Up>')
-- vim.keymap.set('n', 's', '<Down>')
-- vim.keymap.set('n', 'a', '<Left>')
-- vim.keymap.set('n', 'd', '<Right>')

vim.keymap.set('n', '<C-p>', "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })

