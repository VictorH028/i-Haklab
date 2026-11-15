require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
})

local lsp_servers = {
  jdtls = {
    cmd = { 'jdtls' }, -- :MasonInstall jdtls
    filetypes = { 'java' },
    root_markers = { 'pom.xml', 'build.gradle', 'settings.gradle', 'gradlew', '.git' },
  },
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
  },
  clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { 'compile_commands.json', 'CMakeLists.txt', 'Makefile', '.git' },
  },
  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  },
  lua_ls = {
    cmd = { '/data/data/com.termux/files/usr/bin/lua-language-server' },
    filetypes = { 'lua' },
    -- 'lazy-lock.json' marca la raíz de esta config de Neovim (no hay .git).
    root_markers = { '.luarc.json', '.luarc.jsonc', 'stylua.toml', 'lazy-lock.json', '.git' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = { vim.env.VIMRUNTIME } },
      },
    },
  },
  smali_lsp = {
    cmd = { 'smali-lsp', 'lsp' },
    filetypes = { 'smali' },
    root_markers = { 'apktool.yml', 'AndroidManifest.xml', '.git' },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities,
  require('cmp_nvim_lsp').default_capabilities())

for name, config in pairs(lsp_servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = config.filetypes,
    callback = function(args)
      local clients = vim.lsp.get_clients({ name = name, bufnr = args.buf })
      if #clients == 0 then
        local root = config.root_markers and vim.fs.root(args.buf, config.root_markers) or nil
        vim.lsp.start({
          name = name,
          cmd = config.cmd,
          -- nil => modo archivo único; nunca enviar $HOME como workspace.
          root_dir = root,
          capabilities = capabilities,
          settings = config.settings,
        })
      end
    end,
  })
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.api.nvim_exec_autocmds('FileType', { buffer = 0 })
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = true,
})

-- Los atajos LSP viven en lua/keymaps.lua (augroup "LspKeymaps").

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '',
        nvim_lua = "Π",
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})
