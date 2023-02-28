-- Set colorscheme
vim.o.termguicolors = true

vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Make comments italic
-- vim.highlight.create('Comment', { cterm = 'italic', gui = 'italic' }, false)

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
