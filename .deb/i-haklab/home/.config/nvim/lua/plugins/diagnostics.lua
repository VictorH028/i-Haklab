-- ============================================================
--  Diagnósticos (LSP) — aspecto limpio
-- ============================================================
local signs = {
    Error = "❌",
    Warn  = "⚠️",
    Hint  = "💡",
    Info  = "ℹ️",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    virtual_text     = true, -- sin texto al final de la línea
    signs            = true, -- icono en la columna
    underline        = true, -- subrayado del código
    update_in_insert = true, -- no recalcular mientras escribes
    severity_sort    = true,
    float            = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})
