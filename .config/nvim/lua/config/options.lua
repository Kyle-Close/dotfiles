-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.keymap.set("i", "jj", "<esc>")

-- Don't want o & O entering insert mode automatically
vim.keymap.set("n", "o", "o<Esc>")
vim.keymap.set("n", "O", "O<Esc>")

-- Make 0 go to the first character on the line instead of the very starts
vim.keymap.set("n", "0", "^")
