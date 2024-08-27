local cc_config = function(_, opts)
  local home = vim.fn.expand("$HOME")

  require("codecompanion").setup({
    adapters = {
      openai = require("codecompanion.adapters").use("openai", {
        env = {
          api_key = "cmd:cat " .. home .. "/.openai_api_key",
        },
        schema = {
          model = {
            default = "gpt-4o"
          }
        }
      }),
      strategies = {
        chat = "openai",
        inline = "openai"
      },
    },
  })
end

return {
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     local home = vim.fn.expand("$HOME")
  --     require("chatgpt").setup({
  --       api_key_cmd = "cat " .. home .. "/.openai_api_key"
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "folke/trouble.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- },

  {
    'github/copilot.vim',
    event = "InsertEnter",

    config = function(_, _)
      vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = '[C]opilot [E]nable' })
      vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = '[C]opilot [D]isable' })
      vim.keymap.set("n", "<leader>cs", ":Copilot status<CR>", { desc = '[C]opilot [S]tatus' })
      vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = '[C]opilot [P]anel' })
    end
  },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-telescope/telescope.nvim", -- Optional
  --     {
  --       "stevearc/dressing.nvim",      -- Optional: Improves the default Neovim UI
  --       opts = {},
  --     },
  --   },
  --   config = cc_config
  -- },
  {
    "robitx/gp.nvim",
    config = function()
      local home = vim.fn.expand("$HOME")

      require("gp").setup({
        openai_api_key = { "cat", home .. "/.openai_api_key" },
        -- whisper_rec_cmd = { "arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav" },
      })
    end,
  }
}
