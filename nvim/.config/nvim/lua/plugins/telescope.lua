local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    find_command = {
      'rg',
      '--files',
      '--hidden',
      '-g', '!.git',
      '-g', '!node_modules'
    }
  })
end)
vim.keymap.set('n', '<leader>FF', function() builtin.find_files({
  find_command = {
    'rg',
    '--files',
    '--hidden',
    '--no-ignore',
    '--no-config'
  }
}) end, {})
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep({
    additional_args = {
      "--hidden",
    },
    glob_pattern = {
      '!.git',
      '!node_modules'
    }
  })
end)
vim.keymap.set('n', '<leader>FG', function() builtin.live_grep({
  find_command = {
    'rg',
    '--hidden',
    '--no-ignore',
    '--no-config'
  }
}) end, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.pickers, {})
vim.keymap.set('n', '<leader>fid', ':Telescope live_grep glob_pattern=')

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
