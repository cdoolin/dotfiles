vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")


vim.keymap.set('n', "<leader>y", "\"+y")
vim.keymap.set('n', "<leader>Y", "\"+Y")
vim.keymap.set('v', "<leader>y", "\"+y")

vim.keymap.set('n', "<leader>d", "\"+d")
vim.keymap.set('v', "<leader>d", "\"+d")
