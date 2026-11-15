vim.env.TMPDIR = '/data/data/com.termux/files/usr/tmp'

local lazy = {}

vim.env.PATH = vim.env.PATH .. ':/data/data/com.termux/files/usr/bin'

function lazy.install(path)
    if not vim.loop.fs_stat(path) then
        print('Installing lazy.nvim....')
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            path,
        })
    end
end

function lazy.setup(plugins)
    -- Pueden comentar la siguiente línea una vez que lazy.nvim esté instalado
    lazy.install(lazy.path)

    vim.opt.rtp:prepend(lazy.path)
    require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- No reiniciar el runtimepath en lazy.setup: así el directorio lua/ añadido
-- abajo sigue visible cuando Neovim activa la detección de filetype.
lazy.opts = { performance = { rtp = { reset = false } } }

-- settings define mapleader antes de lazy.setup, para que los `keys`
-- de lazy (y el resto de keymaps) expandan <leader> correctamente.
require('settings')

-- Los directorios de runtime (ftdetect, ftplugin, indent, syntax, snippets)
-- viven dentro de lua/ para mantener la raíz limpia. Se añade lua/ al rtp
-- para que Neovim los siga detectando como si estuvieran en la raíz.
vim.opt.rtp:append(vim.fn.stdpath('config') .. '/lua')

lazy.setup({
    ---
    -- Lista de plugins
    --- Partomar  notas de texto sin formato
    -- zk-nvim: la configuración vive en lua/plugins/zk.lua
    { "mickael-menu/zk-nvim" },
    {
        "nickjvandyke/opencode.nvim",
        -- Defaults to "main", supporting OpenCode v2.
        -- Uncomment to pull the latest stable release, supporting OpenCode v1.
        version = "*",
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any; goto definition on the type for details
            }
            -- Keymaps centralizados en lua/keymaps.lua
        end,
    },
    -- formatting!
    {
        "stevearc/conform.nvim",
        opts = {},
    },
    { 'rhysd/vim-grammarous' },
    -- Github Copilot
    { 'github/copilot.vim',   commit = 'dfe0a3a1c256167d181488a73ec6ccab8d8931a9' }, -- CONFIGURATION NEEDED RUNNING ':Copilot setup .''
    -- Tema
    { 'folke/tokyonight.nvim' },
    -- Linea inferiol
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- Linea superiol
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
    -- Buscar de forma interavtiva
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        -- or                              , branch = '0.1.xx,
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Albol de directorio
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    -- Linea en blanco de sangría
    {
        "lukas-reineke/indent-blankline.nvim",
    },
    -- Tarminal
    { 'akinsho/toggleterm.nvim', version = "*", config = true },
    -- Plegado de código con nvim-ufo
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        event = "VeryLazy",
        config = function()
            require("ufo").setup({
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },
    -- Gir ---> Pendiente a cambiar
    { 'dinhhuy258/git.nvim' },
    -- Gitsigns (cambios git en la línea de estado / margin)
    { 'lewis6991/gitsigns.nvim', opts = {} },
    -- Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            delay = 300,
        },
    },
    -- Autocierre de pares
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    -- Efecto "smear" para el cursor
    {
        "sphamba/smear-cursor.nvim",
        priority = 1000, -- Cargar después del tema de colores
        opts = {
            -- Carácter para la cabeza (puedes probar con '🔥', '*', '>', etc.)
            head = "🔥",
            -- Color para la cabeza (un rojo fuerte)
            head_fg = "#FF0000",
            -- Colores para la estela (mezcla de rojos, naranjas y amarillos)
            tail_fg = { "#FF0000", "#FF4500", "#FFA500", "#FFD700", "#FFFF00" },
            -- Otros ajustes que puedes experimentar
            tail_length = 7, -- Un poco más larga la estela
            timeout = 15, -- Que tarde un poco más en desaparecer
        },
    },
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
    },
    -- IA local con Ollama (colaboración demon; no altera lo existente)
    {
        "nomnivore/ollama.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("ollama").setup({
                model = "deepseek-coder:1.3b",
                prompts = {
                    Translate_To_Spanish = {
                        prompt = "Traduce este código a español (comentarios y explicaciones):\n\n$sel",
                        action = "display",
                        options = { temperature = 0.3 },
                    },
                    Find_Bugs = {
                        prompt = "Encuentra posibles bugs o problemas en este código:\n\n$sel",
                        action = "display",
                        options = { temperature = 0.1 },
                    },
                    Document_Code = {
                        prompt = "Genera documentación (comentarios) para este código:\n\n$sel",
                        action = "replace",
                        extract = "```[%w+]+\n(.-)```",
                        options = { temperature = 0.2 },
                    },
                    Optimize_Code = {
                        prompt = "Optimiza este código para mejor rendimiento:\n\n$sel",
                        action = "display",
                        options = { temperature = 0.4 },
                    },
                },
                url = "http://127.0.0.1:11434",
                serve = {
                    on_start = false,
                    command = "ollama",
                    args = { "serve" },
                    stop_command = "pkill",
                    stop_args = { "-SIGTERM", "ollama" },
                },
            })
        end,
        cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
        -- Keymap centralizado en lua/keymaps.lua
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },

    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
    { 'xiyaowong/transparent.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
})

----------------------------------
--        ==Arcivo de  configuracion===
------------------------------------
require('keymaps')
require("plugins.formatting")    -- Formatting
require('plugins.tokyonight')    -- Tema
require('plugins.lualine')       -- Lina inferiol
require('plugins.bufferline')    -- Line superiol
require('plugins.lsp-zero')      -- Soporte para LSP
require('plugins.blankline')     -- guías de sangría a todas las líneas
require("plugins.telescope")     -- filtrar de forma interactiva
require("plugins.toggleterm")    -- Terminal
require("plugins.git")           -- Cosas de git
require("plugins.zk")            -- Plain text notes
require("plugins.react")         -- Web LSP servers (on demand, manual install via :Mason)
require("plugins.codecompanion") -- Code Companion

-- ----------------------------------------------------------------------------
-- Ollama server exit prompt (shared service: keep running by default)
-- ----------------------------------------------------------------------------
-- Only prompt on interactive exits while an "ollama serve" process is alive.
-- Headless/scripted exits quit silently and never kill the server.
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if #vim.api.nvim_list_uis() == 0 then return end
        if vim.fn.executable("pgrep") == 0 then return end
        vim.fn.system({ "pgrep", "-f", "ollama serve" })
        if vim.v.shell_error ~= 0 then return end -- no server running, exit quietly
        local choice = vim.fn.confirm("Ollama server is still running. Stop it?", "&Keep running\n&Stop server", 1)
        if choice == 2 then
            vim.fn.system({ "pkill", "-SIGTERM", "-f", "ollama serve" })
        end
    end,
})
