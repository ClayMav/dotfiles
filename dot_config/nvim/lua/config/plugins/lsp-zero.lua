-- import plugin safely
local setup, lspzero = pcall(require, "lsp-zero")
if not setup then
    return
end

local lsp = lspzero.preset({
    name = 'recommended',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true,
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

local null_setup, null_ls = pcall(require, 'null-ls')
if not null_setup then
    return
end
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    -- configure format on save
    on_attach = function(current_client, bufnr)
        if current_client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        filter = function(client)
                            --  only use null-ls for formatting instead of lsp server
                            return client.name == "null-ls"
                        end,
                        bufnr = bufnr,
                    })
                end,
            })
        end
    end,
    sources = {
        -- Replace these with the tools you have installed
        formatting.prettier, -- js/ts formatter
        formatting.stylua, -- lua formatter
        diagnostics.eslint_d.with({ -- js/ts linter
            -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
            condition = function(utils)
                return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
            end,
        }),
    }
})

local mason_null_setup, mason_null = pcall(require, 'mason-null-ls')
if not mason_null_setup then
    return
end

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
mason_null.setup({
    -- list of formatters & linters for mason to install
    ensure_installed = {
        "prettier", -- ts/js formatter
        "stylua", -- lua formatter
        "eslint_d", -- ts/js linter
    },
    -- auto-install configured formatters & linters (with null-ls)
    automatic_installation = true,
    automatic_setup = true,
})

-- Required when `automatic_setup` is true
mason_null.setup_handlers()
