-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.

local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })

local on_attach = function(_, bufnr)
  local telescope = require('telescope.builtin')

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
    { buffer = bufnr, desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
    { buffer = bufnr, desc = '[C]ode [A]ction' })

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
    { buffer = bufnr, desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
    { buffer = bufnr, desc = '[G]oto [D]eclaration' })
  vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition,
    { buffer = bufnr, desc = '[G]oto [T]ype Definition' })
  vim.keymap.set('n', 'gr', telescope.lsp_references,
    { buffer = bufnr, desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation,
    { buffer = bufnr, desc = '[G]oto [I]mplementation' })

  vim.keymap.set('n', '<leader>fs', telescope.lsp_document_symbols,
    { buffer = bufnr, desc = '[F]ind [S]ymbols' })
  vim.keymap.set('n', '<leader>fa', telescope.lsp_dynamic_workspace_symbols,
    { buffer = bufnr, desc = '[F]ind [A]ll symbols in workspace' })
  vim.keymap.set('n', '<leader>fi', function() telescope.lsp_document_symbols({ ignore_symbols = 'variable' }) end,
    { buffer = bufnr, desc = '[F]ind [I]mportant symbols (non-variable)' })

  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end,
    { buffer = bufnr, desc = 'Hover Documentation' })
  vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help() end,
    { buffer = bufnr, desc = 'Signature Documentation' })

  -- Lesser used LSP functionality
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })

  local filter = function(client)
    return client ~= "tsserver"
  end

  local format = function()
    vim.lsp.buf.format { filter = filter }
  end

  vim.api.nvim_clear_autocmds { buffer = bufnr, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = format,
  })

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'Format',
    format,
    { desc = 'Format current buffer with LSP' }
  )
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  bashls = {},
  eslint = {},
  yamlls = {},
  pyright = {},
  -- rust_analyzer = {},
  tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      severity_limit = "Warning",
    },
  }
)

require("null-ls").setup {
  sources = {
    require("null-ls").builtins.formatting.prettierd,
    -- require("null-ls").builtins.formatting.isort,
    require("null-ls").builtins.formatting.black,
  },
}
