return {
  {
    'jakewvincent/mkdnflow.nvim',
    filetypes = { 'markdown' },

    config = function()
      require('mkdnflow').setup({
        mappings = {
          MkdnToggleToDo = { { 'n', 'v' }, '<C-Enter>' },
        }
      })
    end
  },

  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    opts = {
      glow_path = os.getenv("HOME") .. "/go/bin/glow",
    }
  },

}
