require("conform").setup({
    formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "isort", "black" },
        rust       = { "rustfmt", lsp_format = "fallback" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
        cpp        = { "clang-format" },
        c          = { "clang-format" },
        java       = { "google-java-format" },
        javascript = { "prettierd" }, -- quita stop_after_first de aquí
        typescript = { "prettierd" },
        json       = { "prettierd" },
        markdown   = { "prettierd" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
})
