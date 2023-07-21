require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "javascript", "typescript", "tsx", "python", "c", "lua", "vim", "vimdoc", "query", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',

        ['af'] = '@function.outer',
        ['if'] = '@function.inner',

        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',

        ['av'] = '@variable.outer',
        ['iv'] = '@variable.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]p"] = "@parameter.inner",
        [']m'] = '@function.outer',
        [']]'] = '@function.outer',
      },
      goto_next_end = {
        ["]P"] = "@parameter.outer",
        [']M'] = '@function.outer',
        [']['] = '@function.outer',
      },
      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ['[m'] = '@function.outer',
        ['[['] = '@function.outer',
      },
      goto_previous_end = {
        ["[P"] = "@parameter.outer",
        ['[M'] = '@function.outer',
        ['[]'] = '@function.outer',
      },
    },

    context_commentstring = {
      enable = true,
    },
    --    swap = {
    --      enable = true,
    --      swap_next = {
    --        ['<leader>a'] = '@parameter.inner',
    --      },
    --      swap_previous = {
    --        ['<leader>A'] = '@parameter.inner',
    --      },
    --    },
  },
}
