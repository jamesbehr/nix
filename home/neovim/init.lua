require('set')
require('plugins')

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = "*",
    command = "%s/\\s\\+$//e",
})
