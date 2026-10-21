-- ============================================================================
--  keymaps.lua  —  Atajos de teclado
--  Sintaxis: vim.keymap.set(<modo>, <tecla>, <acción>, <opciones>)
--  Ayuda:    :h vim.keymap.set
-- ============================================================================
--
-- Notación Significado
-- M Meta (tecla Alt en la mayoría de teclados)
-- C Control
-- S Shift
--
local map = vim.keymap.set

-- Atajo corto para opciones comunes
local opts = { noremap = true, silent = true }

-- ============================================================================
--  VENTANAS (splits)
-- ============================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Ventana ← izquierda" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana → derecha" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana ↓ abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana ↑ arriba" })

-- ============================================================================
--  FORMATEO AUTOMÁTICO al guardar
-- ============================================================================
-- Manual:  :ConformInfo
-- También puedes formatear a mano con <leader>mp (ver más abajo)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.lua", "*.py", "*.rs", "*.sh", "*.c", "*.cpp", "*.js", "*.ts", "*.md" },
    callback = function()
        require("conform").format({
            lsp_format = "fallback",
            timeout_ms = 500,
        })
    end,
})

-- ============================================================================
--  TELESCOPE (búsqueda interactiva)
-- ============================================================================
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Buscar texto (grep en vivo)" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Buscar archivos" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "Buscar TODOS los archivos" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Listar buffers abiertos" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Archivos recientes" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Ayuda de Neovim" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Buscar dentro del buffer" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Marcas" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Terminales ocultas" })

-- Git vía Telescope
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Commits de Git" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Estado de Git" })

-- ============================================================================
--  EXPLORADOR DE ARCHIVOS (nvim-tree)
-- ============================================================================
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Mostrar/ocultar explorador" })

-- ============================================================================
--  ARCHIVOS Y SESIÓN
-- ============================================================================
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Guardar archivo" })
map("n", "<leader>x", "<cmd>x<CR>", { desc = "Guardar y cerrar" })
map("n", "<leader>ei", "<cmd>edit $MYVIMRC<CR>", { desc = "Abrir init.lua" })
map("n", "<leader>er", "<cmd>source $MYVIMRC<CR>", { desc = "Recargar init.lua" })

-- ============================================================================
--  BUFFERS
-- ============================================================================
map("n", "<C-b>n", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<C-b>p", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<C-b>q", "<cmd>bdelete<CR>", { desc = "Cerrar buffer" })

-- Salir de Neovim
map("n", "<C-c>", "<cmd>q!<CR>", { desc = "Salir sin guardar" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Guardar (atajo rápido)" })

-- Salir de modo inserción con jk
map("i", "jk", "<Esc>", { desc = "Salir de modo inserción" })

-- ============================================================================
--  TERMINAL (toggleterm)
-- ============================================================================
function _G.set_terminal_keymaps()
    local t_opts = { buffer = 0 }
    map('t', '<Esc>', [[<C-\><C-n>]], t_opts)
    map('t', 'jk', [[<C-\><C-n>]], t_opts)
    map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], t_opts)
    map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], t_opts)
    map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], t_opts)
    map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], t_opts)
    map('t', '<C-w>', [[<C-\><C-n><C-w>]], t_opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- ============================================================================
--  FORMATEO MANUAL
-- ============================================================================
map({ "n", "v" }, "<leader>mp", function()
    require("conform").format({
        lsp_format = "fallback",
        timeout_ms = 500,
    })
end, { desc = "Formatear archivo o selección" })

-- ============================================================================
--  TRANSPARENCIA
-- ============================================================================
map("n", "<leader>te", "<cmd>TransparentEnable<CR>", { desc = "Activar fondo transparente" })
map("n", "<leader>td", "<cmd>TransparentDisable<CR>", { desc = "Desactivar fondo transparente" })
map("n", "<leader>tt", "<cmd>TransparentToggle<CR>", { desc = "Alternar fondo transparente" })

-- ============================================================================
--  NVIM-UFO (plegado de código)
-- ============================================================================
map("n", "zR", function() require('ufo').openAllFolds() end, { desc = "Abrir todos los pliegues" })
map("n", "zM", function() require('ufo').closeAllFolds() end, { desc = "Cerrar todos los pliegues" })
map("n", "zp", function() require('ufo').peekFoldedLinesUnderCursor() end, { desc = "Ver pliegue bajo el cursor" })

-- ============================================================================
--  CODECOMPANION (IA)
-- ============================================================================
-- <A-,> = Alt + coma. Si en Termux no funciona, cambia por <leader>a
local cc = "<leader>a" -- Alternativa más fiable en móvil
-- local cc = "<A-,>"   -- Descomenta si tu teclado soporta Alt

map({ "n", "v" }, cc .. "a", "<cmd>CodeCompanionActions<CR>", { desc = "IA: acciones" })
map({ "n", "v" }, cc .. "c", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "IA: abrir chat" })
map({ "n", "v" }, cc .. "i", "<cmd>CodeCompanion<CR>", { desc = "IA: prompt inline" })
map({ "n", "v" }, cc .. "e", "<cmd>CodeCompanion /explain<CR>", { desc = "IA: explicar código" })
map({ "n", "v" }, cc .. "f", "<cmd>CodeCompanion /fix<CR>", { desc = "IA: arreglar código" })
map({ "n", "v" }, cc .. "t", "<cmd>CodeCompanion /tests<CR>", { desc = "IA: generar tests" })

-- Atajos para ver diagnósticos sin ruido visual
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Ver diagnóstico" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnóstico anterior" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnóstico siguiente" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnósticos en lista" })
