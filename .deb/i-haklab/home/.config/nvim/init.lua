--------------------------------------------------------------------------------
--  init.lua  —  Configuración de Neovim en Termux
--------------------------------------------------------------------------------
-- Rutas específicas de Termux
vim.env.TMPDIR = '/data/data/com.termux/files/usr/tmp'
vim.env.PATH   = vim.env.PATH .. ':/data/data/com.termux/files/usr/bin'

--------------------------------------------------------------------------------
--  Bootstrap de lazy.nvim
--------------------------------------------------------------------------------
local lazy     = {}

function lazy.install(path)
    if not vim.loop.fs_stat(path) then
        print('Installing lazy.nvim....')
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable',
            path,
        })
    end
end

function lazy.setup(plugins)
    lazy.install(lazy.path)
    vim.opt.rtp:prepend(lazy.path)
    require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

--------------------------------------------------------------------------------
--  Lista de plugins
--------------------------------------------------------------------------------
lazy.setup({

    --------------------------------------------------------------------------
    --  Notas / texto plano
    --------------------------------------------------------------------------
    {
        "mickael-menu/zk-nvim"
    },

    --------------------------------------------------------------------------
    --  Formato y gramática
    --------------------------------------------------------------------------
    { "stevearc/conform.nvim", opts = {} },
    { "rhysd/vim-grammarous" },

    --------------------------------------------------------------------------
    --  Apariencia
    --------------------------------------------------------------------------
    { "folke/tokyonight.nvim" },

    -- Línea inferior
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Línea superior (buffers)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },

    -- Guías de indentación
    { "lukas-reineke/indent-blankline.nvim" },

    -- Fondo transparente
    { "xiyaowong/transparent.nvim" },

    -- Efecto "smear" para el cursor
    {
        "sphamba/smear-cursor.nvim",
        priority = 1000,
        opts = {
            head        = "🔥",
            head_fg     = "#FF0000",
            tail_fg     = { "#FF0000", "#FF4500", "#FFA500", "#FFD700", "#FFFF00" },
            tail_length = 7,
            timeout     = 15,
        },
    },

    --------------------------------------------------------------------------
    --  Navegación / búsqueda / árbol
    --------------------------------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({})
        end,
    },

    --------------------------------------------------------------------------
    --  Terminal
    --------------------------------------------------------------------------
    { "akinsho/toggleterm.nvim", version = "*", config = true },

    --------------------------------------------------------------------------
    --- Key
    --------------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            delay = 300,
        },
    },
    --------------------------------------------------------------------------
    --  Git
    --------------------------------------------------------------------------
    { "dinhhuy258/git.nvim" }, -- pendiente a cambiar
    { "lewis6991/gitsigns.nvim", opts = {} },

    --------------------------------------------------------------------------
    --  Plegado de código
    --------------------------------------------------------------------------
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "VeryLazy",
        config = function()
            require("ufo").setup({
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    --------------------------------------------------------------------------
    --  IA  —  CodeCompanion + Ollama local
    --------------------------------------------------------------------------
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("codecompanion").setup({
                adapters = {
                    ollama = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            schema = { model = { default = "qwen2.5:0.5b" } },
                        })
                    end,
                },
                strategies = {
                    chat   = { adapter = "ollama" },
                    inline = { adapter = "ollama" },
                },
            })
        end,
    },

    --------------------------------------------------------------------------
    --  LSP + Autocompletado
    --------------------------------------------------------------------------
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lua" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },

    --------------------------------------------------------------------------
    --  Edición
    --------------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    --------------------------------------------------------------------------
    --  Treesitter
    --------------------------------------------------------------------------
    { "nvim-treesitter/nvim-treesitter" },
})


--------------------------------------------------------------------------------
--  Configuración personal (módulos en lua/)
--------------------------------------------------------------------------------
require("settings")            -- Opciones generales
require("keymaps")             -- Atajos
require("plugins.formatting")  -- Formato
require("plugins.tokyonight")  -- Tema
require("plugins.lualine")     -- Línea inferior
require("plugins.bufferline")  -- Línea superior
require("plugins.lsp-zero")    -- Soporte LSP
require("plugins.blankline")   -- Guías de indentación
require("plugins.telescope")   -- Búsqueda interactiva
require("plugins.toggleterm")  -- Terminal
require("plugins.git")         -- Git
require("plugins.zk")          -- Notas de texto plano
require("plugins.nvim-tree")   -- Barra lateral
require("plugins.diagnostics") -- .....
