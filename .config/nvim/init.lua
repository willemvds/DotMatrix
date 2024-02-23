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
	{"olical/conjure"},
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

lspconfig.elixirls.setup {
  cmd = {"/usr/local/bin/elixir-ls"}
}

require("nvim-web-devicons").setup({
 color_icons = true,
 default = true,
})


vim.api.nvim_create_autocmd('lspattach', {
  group = vim.api.nvim_create_augroup('userlspconfig', {}),
  callback = function(ev)
    -- enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- buffer local mappings.
    -- see `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>d', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
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


vim.keymap.set('n', '<c-b>', ':NvimTreeFindFileToggle<CR>', { silent = true })
-- vim.keymap.set('n', 'w', '<up>')
-- vim.keymap.set('n', 's', '<down>')
-- vim.keymap.set('n', 'a', '<left>')
-- vim.keymap.set('n', 'd', '<right>')

vim.keymap.set('n', '<c-p>', "<cmd>lua require('fzf-lua').files()<cr>", { silent = true })

