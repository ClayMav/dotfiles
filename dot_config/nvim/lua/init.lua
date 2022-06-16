local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
	execute 'packadd packer.nvim'
end
vim.cmd('packadd packer.nvim')
local packer = require 'packer'
local util = require 'packer.util'
packer.init({
	package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
	local use = use
	use {
		'VonHeikemen/lsp-zero.nvim', -- Allows for 0 config lsp setup
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/nvim-lsp-installer' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		}
	}

	-- Treesitter
	use 'nvim-treesitter/nvim-treesitter'
	-- Additional textobjects for treesitter
	use 'nvim-treesitter/nvim-treesitter-textobjects'

	-- Theme
	use 'folke/tokyonight.nvim'

	-- Other stuff
	use 'tpope/vim-fugitive' -- Git commands in nvim
	use 'tpope/vim-commentary' -- Comment with gcc or gc
	use "ethanholz/nvim-lastplace"
	use "windwp/nvim-autopairs"

end
)

-- Set colorscheme
vim.o.termguicolors = true

vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

vim.cmd [[colorscheme tokyonight]]

-- Make comments italic
vim.highlight.create('Comment', { cterm = 'italic', gui = 'italic' }, false)

-- TODO: add lightline

vim.o.encoding = "utf-8"
vim.o.mouse = "a"

-- TODO: If wrong backspace character fix

vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.colorcolumn = "80"

vim.o.ruler = true

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

--- Set up undo files, backup files, swap files, and tags files
local function is_directory(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "file" or false
end

-- Undo files
vim.o.undofile = true
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if not is_directory(undo_dir) then
	vim.fn.mkdir(undo_dir, "p")
end
vim.o.undodir = undo_dir

-- Backup files
vim.o.backup = true
local backup_dir = vim.fn.stdpath("data") .. "/backup"
if not is_directory(backup_dir) then
	vim.fn.mkdir(backup_dir, "p")
end
vim.o.backupdir = backup_dir

-- Swap files
local swap_dir = vim.fn.stdpath("data") .. "/swap"
if not is_directory(swap_dir) then
	vim.fn.mkdir(swap_dir, "p")
end
vim.o.directory = swap_dir

-- gutentags files
local tags_path = vim.fn.stdpath("data") .. "/tags"
if not is_directory(tags_path) then
	vim.fn.mkdir(tags_path, "p")
end
vim.g.gutentags_cache_dir = tags_path

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'gnn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
	},
}

local lsp = require('lsp-zero')
require 'nvim-lastplace'.setup {}
require 'nvim-autopairs'.setup {}

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()
vim.diagnostic.config({ virtual_text = true })
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
