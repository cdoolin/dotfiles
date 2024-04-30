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
}
