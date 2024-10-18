local nnoremap = require("keymap").nnoremap
local utils = require('telescope.utils')
local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions

require("telescope").setup({
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
    }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

nnoremap("<leader>t", "<cmd>Telescope<cr>")

nnoremap("<leader><leader>", function()
    builtin.find_files()
end)

nnoremap("<leader><return>", builtin.buffers)

nnoremap("<leader>f", "<cmd>e %:h<cr>")

nnoremap("<leader>rg", builtin.live_grep)
