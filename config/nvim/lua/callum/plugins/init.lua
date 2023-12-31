return {
  "sainnhe/everforest",
  'tpope/vim-sleuth',
  "nvim-tree/nvim-web-devicons",
  -- "vimpostor/vim-lumen",
  "christoomey/vim-tmux-navigator",

  { 'folke/which-key.nvim',      opts = {} },

  { 'nvim-lualine/lualine.nvim', opts = {} },

  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function(_, opts)
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter' }
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function(_, _)
      vim.keymap.set("n", "<leader>pf", ":Neotree filesystem reveal toggle float<CR>",
        { desc = '[P]roject [F]loat filesystem browser' })
      vim.keymap.set("n", "<leader>pt", ":Neotree filesystem reveal toggle left<CR>", { desc = '[P]roject [T]ree' })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
  },


  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    version = "*",
    opts = {
      options = {
        custom_filter = function(buf_number, _)
          local windows_displaying_buffer = vim.api.nvim_call_function('win_findbuf', { buf_number })
          if #windows_displaying_buffer > 0 then return true end

          -- local active = vim.api.nvim_call_function('bufnr', { '%' })
          -- if active == buf_number then return true end

          local modified = vim.api.nvim_buf_get_option(buf_number, 'modified')
          if modified then return true end
        end,

      },
    }
  },
  -- {
  --   'dstein64/nvim-scrollview',
  --   opts = {},
  --   config = function(_, opts)
  --     require('scrollview').setup(opts)
  --     require('scrollview.contrib.gitsigns').setup()
  --   end,
  --   dependencies = { 'lewis6991/gitsigns.nvim' }
  -- },
  {
    'lewis6991/satellite.nvim',
    opts = {
      winblend = 20,
    }
  },

  -- smooth scrolling - useful to benchmark
  -- { 'karb94/neoscroll.nvim', opts = {} },

}
