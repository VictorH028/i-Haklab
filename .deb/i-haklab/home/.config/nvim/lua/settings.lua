-- ============================================================================
--  settings.lua  —  Opciones generales de Neovim
--  Entorno: Termux (Android) + posible uso con Termux:X11
-- ============================================================================

-- Variables locales (atajos para no escribir tanto)
local g              = vim.g
local opt            = vim.opt

-- ============================================================================
--  GENERAL
-- ============================================================================
g.mapleader          = ','                               -- Tecla líder para atajos personalizados
g.maplocalleader     = ','                               -- Tecla líder local (buffers específicos)

opt.shell            = "/bin/sh"                         -- Evita conflictos con fish/zsh en Termux
opt.completeopt      = { 'menu', 'menuone', 'noselect' } -- Comportamiento del menú de autocompletado
opt.mouse            = 'a'                               -- Habilita el ratón en todos los modos

-- ============================================================================
--  PORTAPAPELES (clipboard) — ¡IMPORTANTE en Termux!
-- ============================================================================
-- Hay DOS escenarios posibles. Elige el que corresponda a tu uso:

-- ---------------------------------------------------------------------------
--  ESCENARIO A: Termux puro (terminal sin entorno gráfico)
-- ---------------------------------------------------------------------------
-- Requiere: pkg install termux-api   (y la app Termux:API instalada)
-- Descomenta este bloque si NO usas X11:
--
-- vim.g.clipboard = {
--     name  = 'termux',
--     copy  = { ['+'] = 'termux-clipboard-set', ['*'] = 'termux-clipboard-set' },
--     paste = { ['+'] = 'termux-clipboard-get', ['*'] = 'termux-clipboard-get' },
--     cache_enabled = 0,
-- }
-- opt.clipboard = 'unnamedplus'

-- ---------------------------------------------------------------------------
--  ESCENARIO B: Termux:X11 (entorno gráfico con XFCE, etc.)
-- ---------------------------------------------------------------------------
-- Requiere: pkg install xclip
-- Usa el portapapeles del sistema X11 (comparte con apps gráficas).
opt.clipboard        = 'unnamedplus'

-- ============================================================================
--  INDENTACIÓN Y TABS
-- ============================================================================
opt.tabstop          = 4    -- Número de espacios visuales por TAB
opt.softtabstop      = 4    -- Número de espacios al pulsar TAB en modo inserción
opt.shiftwidth       = 4    -- Espacios al autoindentar (>>, <<)
opt.expandtab        = true -- Convierte TAB en espacios (recomendado para Python)

-- ============================================================================
--  BÚSQUEDA
-- ============================================================================
opt.incsearch        = true  -- Busca mientras escribes
opt.hlsearch         = false -- No resalta todas las coincidencias
opt.ignorecase       = true  -- Ignora mayúsculas/minúsculas por defecto
opt.smartcase        = true  -- Pero sé sensible si escribes alguna mayúscula

-- ============================================================================
--  INTERFAZ (UI)
-- ============================================================================
opt.updatetime       = 250   -- Tiempo de espera para eventos (ms)
opt.number           = true  -- Números de línea absolutos
opt.relativenumber   = true  -- Números relativos (más fácil saltar con j/k)
opt.cursorline       = true  -- Resalta la línea del cursor
opt.splitbelow       = true  -- Nuevos splits horizontales abajo
opt.splitright       = true  -- Nuevos splits verticales a la derecha
opt.termguicolors    = true  -- Color RGB de 24 bits (necesario para X11 y temas)
opt.showmode         = false -- Oculta el modo (ya lo muestra lualine)
opt.signcolumn       = 'yes' -- Columna fija para signos (diagnósticos, git)
opt.wrap             = true  -- Ajuste de línea activado
opt.pumheight        = 10    -- Altura del menú emergente de autocompletado
opt.scrolloff        = 8     -- Margen visible arriba/abajo al desplazarse
opt.sidescrolloff    = 8     -- Margen visible izquierda/derecha al desplazarse horizontalmente

-- ============================================================================
--  RENDIMIENTO
-- ============================================================================
opt.timeoutlen       = 300 -- Tiempo máximo para completar un atajo (ms)

-- ============================================================================
--  ARCHIVOS
-- ============================================================================
opt.undofile         = true  -- Guarda el historial de deshacer entre sesiones
opt.swapfile         = false -- Sin archivos .swp (útil en Termux, pocos recursos)
opt.backup           = false -- Sin copias de seguridad
opt.confirm          = true  -- Pide confirmación en vez de lanzar error (ej. :q con cambios)

-- ============================================================================
--  PLEGADO DE CÓDIGO (nvim-ufo)
-- ============================================================================
vim.o.foldcolumn     = '1'                               -- Columna de plegado
vim.o.foldlevel      = 99                                -- Nivel máximo abierto por defecto
vim.o.foldlevelstart = 99                                -- Al abrir un archivo, todo desplegado
vim.o.foldenable     = true                              -- Activa el plegado
vim.o.foldmethod     = 'expr'                            -- Método basado en expresión
vim.o.foldexpr       = 'v:lua.vim.treesitter.foldexpr()' -- Usa Treesitter para el plegado

-- ============================================================================
--  DIAGNÓSTICOS (LSP)
-- ============================================================================
vim.diagnostic.config({
    virtual_text  = true, -- Muestra errores/warnings como texto fantasma
    severity_sort = true, -- Ordena por severidad (error antes que warning)
})

-- ============================================================================
--  AJUSTES ESPECÍFICOS PARA TERMUX
-- ============================================================================
-- Reducen el consumo de RAM/CPU en dispositivos móviles
opt.lazyredraw = true -- No redibuja durante macros/atajos largos
opt.history    = 200  -- Historial de comandos más pequeño (por defecto 1000)
opt.undolevels = 200  -- Menos niveles de deshacer (ahorra memoria)


-- Libera memoria cuando Neovim está en segundo plano
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.cmd("silent! !pkill -f llama-server 2>/dev/null")
    end,
})
