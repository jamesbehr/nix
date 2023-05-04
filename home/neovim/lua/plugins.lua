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

require("lazy").setup({
    -- Core
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",

    -- LSP
    "neovim/nvim-lspconfig",

    -- Treesitter
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-context",

    -- Telescope
    "nvim-telescope/telescope.nvim",
    {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
    "nvim-telescope/telescope-file-browser.nvim",

    -- Surround
    "kylechui/nvim-surround",

    -- Comment
    "numToStr/Comment.nvim",

    -- Snippets
    "L3MON4D3/LuaSnip",

    -- Completion
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-calc",
    "f3fora/cmp-spell",
    "andersevenrud/cmp-tmux",

    -- Presentation
    "EdenEast/nightfox.nvim",
    "kyazdani42/nvim-web-devicons",
    {"nvim-lualine/lualine.nvim", dependencies = "kyazdani42/nvim-web-devicons"},
    {"akinsho/bufferline.nvim", version = "v2.*", dependencies = "kyazdani42/nvim-web-devicons"},
    "lewis6991/gitsigns.nvim",

    -- Other
    {
        "scalameta/nvim-metals",
        dependencies = "nvim-lua/plenary.nvim",
        ft = "scala",
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                useGlobalExecutable = true
            }

            metals_config.on_attach = on_attach

            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
              pattern = { "scala", "sbt", "java" },
              callback = function()
                require("metals").initialize_or_attach(metals_config)
              end,
              group = nvim_metals_group,
            })
        end,
    },
})
