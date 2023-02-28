-- ensure that packer is installed or install packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer
local packer_status, packer = pcall(require, 'packer')
if not packer_status then
    -- print('Something went wrong:', packer)
    return
end

--- startup and add configure plugins
return packer.startup(function(use)
    use("wbthomason/packer.nvim") -- packer will manage itself
    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
    use({
        'VonHeikemen/lsp-zero.nvim', -- Allows for 0 config lsp setup
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' }, -- Optional
            { "jose-elias-alvarez/null-ls.nvim" }, -- configure formatters & linters
            { "jayp0521/mason-null-ls.nvim" }, -- bridges gap b/w mason & null-ls

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    })
    -- Additional textobjects for treesitter
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- Theme
    use('folke/tokyonight.nvim')

    -- Other stuff
    use('tpope/vim-fugitive') -- Git commands in nvim
    use('tpope/vim-commentary') -- Comment with gcc or gc
    use("ethanholz/nvim-lastplace")
    use("windwp/nvim-autopairs")
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end
)

-- vim.diagnostic.config({ virtual_text = true })
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
