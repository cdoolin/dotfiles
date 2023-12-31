return {
  {
    'stevearc/conform.nvim',
    cmd = "ConformInfo",
    event = "BufWritePre",
    -- lazy = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { { "prettierd", "prettier" } },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      }
    },
    -- dependencies = { '' },
  }
}
