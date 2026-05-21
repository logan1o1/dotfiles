vim.pack.add({
    -- Core
    { src = "https://github.com/nvim-lua/plenary.nvim" }, --enabled (used by telescope & git_worktree.nvim)
    { src = "https://github.com/folke/lazydev.nvim" }, --enabled

    -- all telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim", branch = "master" },--enabled
    { src = "https://github.com/andrew-george/telescope-themes" }, --enabled
    { src = "https://github.com/nvim-lua/popup.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-media-files.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" }, --enabled
    { src = "https://github.com/nvim-lualine/lualine.nvim" }, --enabled

    { src = "https://github.com/stevearc/oil.nvim" }, --enabled
    { src = "https://github.com/olrtg/nvim-emmet" }, --enabled

    -- folding
    { src = "https://github.com/stevearc/conform.nvim" },


    { src = "https://github.com/MunifTanjim/nui.nvim" },

    { src = "https://github.com/folke/snacks.nvim" }, --enabled
    { src = "https://github.com/echasnovski/mini.nvim" }, --enabled

    -- git
    { src = "https://github.com/ThePrimeagen/git-worktree.nvim" }, --enabled
    { src = "https://github.com/lewis6991/gitsigns.nvim" }, --enabled
    { src = "https://github.com/tpope/vim-fugitive" }, --enabled

    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" }, --enabled
    { src = "https://github.com/windwp/nvim-ts-autotag" }, --enabled

    -- blink
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },

    -- LSP stack
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    { src = "https://github.com/NvChad/nvim-colorizer.lua" }, --enabled

    -- icons
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, --enabled

    -- colorschemes
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://gitlab.com/shmerl/neogotham.git"},
    { src = "https://github.com/ficcdaf/ashen.git"},
    { src = "https://github.com/loctvl842/monokai-pro.nvim" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },
})
