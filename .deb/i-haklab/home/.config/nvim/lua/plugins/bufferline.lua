---------------------------------------------------------------
--  bufferline.nvim  —  barra superior de buffers
---------------------------------------------------------------
-- Documentación:
--   :help bufferline-configuration
--   https://github.com/akinsho/bufferline.nvim
---------------------------------------------------------------

local bufferline = require('bufferline')

bufferline.setup({
    options = {
        -- ─── Comportamiento del ratón ──────────────────────────
        numbers              = "none",
        close_command        = "Bdelete! %d",
        right_mouse_command  = "Bdelete! %d",
        left_mouse_command   = "buffer %d",
        middle_mouse_command = nil,

        -- ─── Iconos ────────────────────────────────────────────
        indicator_icon       = "▎",
        buffer_close_icon    = "",
        close_icon           = '',
        left_trunc_marker    = "",
        right_trunc_marker   = "",


        -- ─── Tamaños y nombres ────────────────────────────────
        max_name_length              = 30,
        max_prefix_length            = 30,
        tab_size                     = 21,

        -- ─── Diagnósticos LSP ─────────────────────────────────
        diagnostics                  = "nvim_lsp", -- muestra errores/warnings
        diagnostics_update_in_insert = false,

        -- ─── Integración con nvim-tree ────────────────────────
        offsets                      = {
            {
                filetype   = "NvimTree",
                text       = "  Explorador  ",
                text_align = "left",
                padding    = 1,
                separator  = true,
            },
        },

        -- ─── Iconos y ordenación ──────────────────────────────
        show_buffer_icons            = true,
        show_buffer_close_icons      = true,
        show_close_icon              = true,
        show_tab_indicators          = true,
        persist_buffer_sort          = true,

        -- ─── Estilo visual ────────────────────────────────────
        separator_style              = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' }
        enforce_regular_tabs         = false,
        always_show_bufferline       = true,
        hover                        = {
            enabled = true,
            delay   = 200,
            reveal  = { "close" },
        },

        -- ─── Estilo de tipografía (elegimos uno solo) ─────────
        -- Opciones válidas: default, no_italic, no_bold, no_underline,
        --                   bold_italic, minimal, minimal_dark
        style_preset                 = bufferline.style_preset.minimal,

        -- ─── Colores personalizados (opcional) ────────────────
        -- Descomenta y ajusta si quieres que combine con tokyonight-moon
        --[[
        modified_icon = "●",
        buffer_selected = {
            bold = true,
            italic = false,
        },
        --]]
    },
})

---------------------------------------------------------------
--  Grupos de buffers (por tipo de archivo)
--  IMPORTANTE: esta sección va FUERA del setup(), como
--  configuración independiente de bufferline.groups.
---------------------------------------------------------------
local groups = require("bufferline.groups")

groups.setup({
    options = {
        toggle_hidden_on_enter = true, -- reabre un grupo al entrar en él
    },
    items = {
        {
            name      = "Tests",
            icon      = "",
            highlight = { gui = "underline", guisp = "#7B96C4" },
            priority  = 2,
            matcher   = function(buf)
                return buf.name:match('_test') or buf.name:match('_spec')
            end,
        },
        {
            name       = "Docs",
            icon       = "",
            highlight  = { gui = "undercurl", guisp = "#6BCFC7" },
            auto_close = false,
            matcher    = function(buf)
                return buf.name:match('%.md') or buf.name:match('%.txt')
            end,
            separator  = {
                style = require('bufferline.groups').separator.tab,
            },
        },
    },
})



------------------------------------------------
