local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- Mantén tus keymaps habituales de LSP aquí
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',    -- Servidor oficial para JS, TS, React JSX y TSX
    'html',     -- Para etiquetas HTML
    'cssls',    -- CSS
    'tailwindcss' -- Opcional: Soporte para Tailwind CSS en componentes React
  },
  handlers = {
    lsp_zero.default_setup,
  },
})

