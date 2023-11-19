return {
  "sainnhe/everforest",
  'tpope/vim-sleuth',
  "nvim-tree/nvim-web-devicons",
  -- "vimpostor/vim-lumen",
  "christoomey/vim-tmux-navigator",

  { 'folke/which-key.nvim',      opts = {} },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       tag = "legacy", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  'jose-elias-alvarez/null-ls.nvim',

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },


  { 'nvim-lualine/lualine.nvim', opts = {} },

  {
    'numToStr/Comment.nvim',
    -- branch = "jsx",
    opts = {
      -- pre_hook = function(ctx)
      --   return require('Comment.jsx').calculate(ctx)
      -- end,
    },
    config = function(_, opts)
      -- for nvim-ts-commentstring
      require('nvim-treesitter.configs').setup {
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      }

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
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    -- build = ':TSUpdateSync',
  },
  'nvim-treesitter/playground',

  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   opts = {},
  --   config = function()
  --     vim.keymap.set('n', '<c-b>', require('nvim-tree').tree.toggle)
  --   end
  -- },
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
  { 'folke/lsp-colors.nvim', opts = {} },
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
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function(_, _)
      local neogit = require('neogit')
      neogit.setup {}
      vim.keymap.set("n", "<leader>gs", function() neogit.open() end, { desc = '[G]it [S]tatus (Neogit)' })
    end

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
  -- { 'karb94/neoscroll.nvim', opts = {} },
  {
    'github/copilot.vim',

    config = function(_, _)
      vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = '[C]opilot [E]nable' })
      vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = '[C]opilot [D]isable' })
      vim.keymap.set("n", "<leader>cs", ":Copilot status<CR>", { desc = '[C]opilot [S]tatus' })
      vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = '[C]opilot [P]anel' })
    end
  },

  {
    "klen/nvim-config-local",
    config = function()
      require('config-local').setup {
        -- Default options (optional)

        -- Config file patterns to load (lua supported)
        config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

        -- Where the plugin keeps files data
        hashfile = vim.fn.stdpath("data") .. "/config-local",

        autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
        silent = false,             -- Disable plugin messages (Config loaded/ignored)
        lookup_parents = false,     -- Lookup config files in parent directories
      }
    end
  }

}
