---------------------------------------------------------------------
-- Table of contents
-- -----------------
-- 1. Globals
-- 2. Options
-- 3. Key mappings
-- 4. Auto commands
---------------------------------------------------------------------

-----------------------------------------------------------------------------
--  GLOBALS
-----------------------------------------------------------------------------

-- Set space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enables nerd font icons (must have nerd font selected in terminal)
vim.g.have_nerd_font = true

-----------------------------------------------------------------------------
--  OPTIONS
-----------------------------------------------------------------------------


-- Show line numbers
vim.opt.number = true

-- Use relative line numbers
vim.opt.relativenumber = true

-- Newlines that are wrapped will be indented
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Enable sign column, this is used to show useful info like breakpoints for example
vim.opt.signcolumn = 'yes'

-- Min number of lines to show below or above the cursor
vim.opt.scrolloff = 10

-- Use OS clipboard by default
vim.opt.clipboard = 'unnamedplus'

-----------------------------------------------------------------------------
--  KEY MAPPINGS
-----------------------------------------------------------------------------

-- jj to exit insert mode
vim.keymap.set('i' 'jj', '<Esc>')

-- Don't want o & O entering insert mode automatically
vim.keymap.set('n', 'o', 'o<Esc>')
vim.keymap.set('n', 'O', 'O<Esc>')

-- Clear the annoying highlights with <Esc> after searching
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Leader + w to save a file
vim.keymap.set('n' '<leader>w', '<cmd>:w<CR>')

-- <C-t> to toggle NERDTREE
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>')

-----------------------------------------------------------------------------
--  AUTO COMMANDS
-----------------------------------------------------------------------------

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
