
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})


-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript',
    'javascriptreact', 'typescript', 'typescriptreact', 'yaml', 'lua'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-- augroup('neoFormatter')
-- autocmd('BufWritePre', {
--   group = 'neoFormatter'
--   pattern = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}
--   command = ":%s/\\s\\+$//e"
-- })
