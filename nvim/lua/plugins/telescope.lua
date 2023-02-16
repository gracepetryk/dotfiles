local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>FF', function() builtin.find_files({ no_ignore = true, hidden = true }) end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.pickers, {})

vim.keymap.set('n', 'gf', function() builtin.find_files({ default_text = vim.fn.expand('<cfile>') }) end)

require('telescope').setup({
  defaults = {
    cache_picker = {
      num_pickers = 100
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim"
    }
  }
})
