return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",                               -- iconos por extensión
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" }, -- lazy-load
    keys = {
        { "<leader>e",  "<cmd>NvimTreeToggle<CR>",   desc = "Árbol: abrir/cerrar" },
        { "<leader>E",  "<cmd>NvimTreeFocus<CR>",    desc = "Árbol: enfocar" },
        { "<leader>fe", "<cmd>NvimTreeFindFile<CR>", desc = "Árbol: ubicar archivo actual" },
    },
    opts = {
        -- --- Apariencia general ---
        sort_by = "case_sensitive",
        view = {
            width = 30,
            side = "left",
            preserve_window_proportions = true,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        renderer = {
            -- Iconos
            icons = {
                show = {
                    file         = true,
                    folder       = true,
                    folder_arrow = true,
                    git          = true,
                    diagnostics  = true,
                    modified     = true,
                    bookmarks    = true,
                },
                glyphs = {
                    default  = "",
                    symlink  = "",
                    bookmark = "",
                    folder   = {
                        arrow_closed = "",
                        arrow_open   = "",
                        default      = "",
                        open         = "",
                        empty        = "",
                        empty_open   = "",
                        symlink      = "",
                        symlink_open = "",
                    },
                    git      = {
                        unstaged  = "✗",
                        staged    = "✓",
                        unmerged  = "",
                        renamed   = "➜",
                        untracked = "★",
                        deleted   = "",
                        ignored   = "◌",
                    },
                },
            },

            -- Guías de indentación dentro del árbol
            indent_markers = { enable = true, inline_arrows = true },

            -- Resaltado de archivos especiales
            highlight_git = true,
            highlight_diagnostics = true,
            highlight_opened_files = "icon",
            highlight_modified = "icon",
            highlight_bookmarks = "icon",

            -- Números de línea dentro del árbol (opcional)
            root_folder_label = ":~:s?$?/..?",
            indent_width = 2,

            -- Iconos especiales por nombre de archivo
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        },

        -- --- Filtros ---
        filters = {
            dotfiles = false,      -- muestra .gitignore, .env, etc.
            git_clean = false,     -- no oculta archivos sin cambios en git
            custom = { "^.git$" }, -- pero sí oculta .git
        },

        -- --- Git ---
        git = {
            enable = true,
            ignore = false,
            timeout = 500,
        },

        -- --- Diagnósticos LSP ---
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            icons = {
                hint    = "",
                info    = "",
                warning = "",
                error   = "",
            },
        },

        -- --- Modificados ---
        modified = {
            enable = true,
        },

        -- --- Comportamiento ---
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        actions = {
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = { enable = true },
            },
            change_dir = { enable = true },
        },
        hijack_directories = {
            enable = true,
            auto_open = false,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
    },
}
