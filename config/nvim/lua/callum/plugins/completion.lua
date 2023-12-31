local config = function(_, opt)
  local cmp = require 'cmp'
  -- local luasnip = require 'luasnip'
  -- require('luasnip.loaders.from_vscode').lazy_load()
  -- luasnip.config.setup {}

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-Space>'] = cmp.mapping.complete {},
      -- ['<CR>'] = cmp.mapping.confirm {
      --   behavior = cmp.ConfirmBehavior.Replace,
      --   select = true,
      -- },
      ["<c-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<M-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        { "i", "c" }
      ),
    },
    sources = {
      { name = 'nvim_lsp' },
      -- { name = 'luasnip' },
      -- { name = 'copilot' },
      { name = "buffer",  keyword_length = 5 },
    },
    experimental = {
      native_menu = false,
    },
  }
end

return {
  {
    "hrsh7th/nvim-cmp",
    config = config,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      -- "saadparwaiz1/cmp_luasnip",
    }
  },
  {
    "onsails/lspkind-nvim",
    config = function()
      local lspkind = require('lspkind')
      lspkind.init({
        symbol_map = {
          Copilot = "",
        },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
  {
    'github/copilot.vim',

    config = function(_, _)
      vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = '[C]opilot [E]nable' })
      vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = '[C]opilot [D]isable' })
      vim.keymap.set("n", "<leader>cs", ":Copilot status<CR>", { desc = '[C]opilot [S]tatus' })
      vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = '[C]opilot [P]anel' })
    end
  },
  -- { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup()
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },


}
