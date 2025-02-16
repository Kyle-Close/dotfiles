return {
  "ThePrimeagen/refactoring.nvim",
  config = function()
    require("refactoring").setup({})
    vim.keymap.set("x", "<leader>re", ":Refactor extract ", { noremap = true, silent = false, expr = false })
    vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
  end,
}
