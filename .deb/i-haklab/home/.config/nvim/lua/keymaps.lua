--[[
  Todos los atajos de teclado de la configuración, centralizados aquí.

  Sintaxis: vim.keymap.set(<mode>, <key>, <action>, <opts>)
  Ayuda:    :h vim.keymap.set

  <leader> y <localleader> son ',' (definidos en lua/settings.lua).
]]

local map = vim.keymap.set

------------------------------------------------------
--            Ventanas
------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Ir a la ventana izquierda" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir a la ventana derecha" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir a la ventana inferior" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir a la ventana superior" })

------------------------------------------------------
--            Guardar / editar / salir
------------------------------------------------------
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Guardar archivo" })
map("n", "<leader>x", "<cmd>x<cr>", { desc = "Guardar y cerrar" })
map("n", "<leader>ei", "<cmd>edit $MYVIMRC<cr>", { desc = "Abrir init.lua" })

------------------------------------------------------
--            Buffers
------------------------------------------------------
map("n", "<C-b>n", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
map("n", "<C-b>p", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<C-b>q", "<cmd>bdelete<cr>", { desc = "Cerrar buffer" })
map("i", "jk", "<Esc>", { desc = "Salir de modo inserción" })

------------------------------------------------------
--            Formateador (conform)
------------------------------------------------------
map("n", "<leader>fm", function()
  require("conform").format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Formatear archivo actual" })

------------------------------------------------------
--            Telescope
------------------------------------------------------
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Buscar texto" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar archivos" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", { desc = "Buscar todos los archivos" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers abiertos" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Ayuda" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Archivos recientes" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buscar en buffer actual" })
map("n", "<leader>ma", "<cmd>Telescope marks<cr>", { desc = "Marcas" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<cr>", { desc = "Commits de git" })
map("n", "<leader>gt", "<cmd>Telescope git_status<cr>", { desc = "Estado de git" })
map("n", "<leader>pt", "<cmd>Telescope terms<cr>", { desc = "Terminales ocultas" })

------------------------------------------------------
--            NvimTree (explorador de archivos)
------------------------------------------------------
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Alternar explorador" })

------------------------------------------------------
--            Terminal
------------------------------------------------------
local term_group = vim.api.nvim_create_augroup("TerminalKeymaps", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  pattern = "term://*",
  callback = function()
    local opts = { buffer = 0 }
    map("t", "<esc>", [[<C-\><C-n>]], opts)
    map("t", "jk", [[<C-\><C-n>]], opts)
    map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
  end,
})

------------------------------------------------------
--            Transparencia
------------------------------------------------------
map("n", "<leader>te", "<cmd>TransparentEnable<cr>", { desc = "Activar fondo transparente" })
map("n", "<leader>td", "<cmd>TransparentDisable<cr>", { desc = "Desactivar fondo transparente" })
map("n", "<leader>tt", "<cmd>TransparentToggle<cr>", { desc = "Alternar transparencia" })

------------------------------------------------------
--            nvim-ufo (folds)
------------------------------------------------------
map("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Abrir todos los folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Cerrar todos los folds" })
map("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Ver fold bajo el cursor" })

------------------------------------------------------
--            LSP (solo donde hay un servidor adjunto)
------------------------------------------------------
local lsp_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  desc = "Atajos LSP",
  callback = function(args)
    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf })
    end
    bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
    bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    bufmap("n", "<F3>", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    bufmap("x", "<F4>", function() vim.lsp.buf.code_action() end)
    bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
    bufmap("n", "[d", "<cmd>lua vim.diagnostic.jump({ count = -1 })<cr>")
    bufmap("n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1 })<cr>")
    bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    bufmap("n", "<leader>ds", "<cmd>lua vim.lsp.buf.document_symbol()<cr>")
    bufmap("n", "<leader>ci", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>")
    bufmap("n", "<leader>co", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>")
  end,
})

------------------------------------------------------
--            OpenCode
------------------------------------------------------
map({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ") end, { desc = "Preguntar a OpenCode" })
map({ "n", "x" }, "<C-x>", function() require("opencode").select() end, { desc = "Seleccionar en OpenCode" })
-- `go` lo usa el LSP (type_definition), por eso se usa <leader>o*.
map({ "n", "x" }, "<leader>oo", function() return require("opencode").operator("@this") end, { desc = "Enviar rango a OpenCode", expr = true })
map("n", "<leader>ol", function() return require("opencode").operator("@this") .. "_" end, { desc = "Enviar línea a OpenCode", expr = true })

------------------------------------------------------
--            CodeCompanion
------------------------------------------------------
map("n", "<A-,>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion: acciones" })
map("v", "<A-,>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion: acciones" })
map("n", "<A-,>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion: chat" })
map("v", "<A-,>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion: chat" })
map("n", "<A-,>ci", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion: inline" })
map("v", "<A-,>ci", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion: inline" })
map("n", "<A-,>ce", "<cmd>CodeCompanion /explain<cr>", { desc = "CodeCompanion: explicar" })

------------------------------------------------------
--            Ollama (IA local)
------------------------------------------------------
map({ "n", "v" }, "<leader>lm", function()
  -- ollama.nvim lee las marcas '< '> sin validarlas: en normal sin
  -- selección son inválidas y nvim_buf_get_text revienta (E5108).
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local bad = s[2] == 0 or e[2] == 0
    or (s[2] > e[2])
    or (s[2] == e[2] and s[3] > e[3])
  if bad then
    vim.notify("Ollama: selecciona código en modo visual y pulsa <leader>lm", vim.log.levels.WARN, { title = "Ollama" })
    return
  end
  if vim.fn.executable("ollama") == 0 then
    vim.notify("Ollama no está instalado. Instálalo con: pkg install ollama", vim.log.levels.WARN, { title = "Ollama" })
    return
  end
  local probe_ok = pcall(function()
    local out = vim.fn.system({ "curl", "--silent", "--max-time", "2", "http://127.0.0.1:11434/api/tags" })
    if vim.v.shell_error ~= 0 or out == "" then error("unreachable") end
  end)
  if not probe_ok then
    vim.notify("El servidor de Ollama no está corriendo. Inícialo con: ollama serve (y descarga un modelo, p.ej. ollama pull deepseek-coder:1.3b)", vim.log.levels.WARN, { title = "Ollama" })
    return
  end
  -- ollama.nvim es lazy (cmd): forzar su carga antes de usar el módulo.
  require("lazy").load({ plugins = { "ollama.nvim" } })
  require("ollama").prompt()
end, { desc = "Prompt de Ollama" })
