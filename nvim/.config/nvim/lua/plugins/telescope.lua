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

vim.keymap.set('n', 'gr', function ()
  builtin.lsp_references({initial_mode='normal'})
end, {})

vim.keymap.set('n', 'gd', function ()
  builtin.lsp_definitions({initial_mode='normal'})
end, {})

vim.keymap.set('n', '<leader>gw', function ()
  builtin.grep_string({initial_mode='normal'})
end, {})


vim.keymap.set('x', '<leader>gw', function ()
  vim.api.nvim_feedkeys('"9y', 'nx', true)
  local search = vim.fn.getreg('9')
  builtin.grep_string({search=search, initial_mode='normal'})
end)

vim.keymap.set('n', '<leader>gf', function() builtin.find_files({ default_text = vim.fn.expand('<cfile>') }) end)

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
      "--ignore-case",
      "--trim"
    }
  }
})

require('telescope').load_extension('ui-select')
