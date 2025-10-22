local builtin = require('telescope.builtin')
local actions_mt = require('telescope.actions.mt')

M = {}
M.post_select = function(prompt_bufnr)
  vim.cmd('silent! normal zOzz')
end
M = actions_mt.transform_mod(M)

require('telescope').load_extension('ui-select')  -- make telescope default picker
require('telescope').load_extension('fzf')


vim.keymap.set('n', '<leader>fa', builtin.find_files)
vim.keymap.set('n', '<leader>ff', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
vim.keymap.set('n', '<leader>FR', builtin.pickers, {})
vim.keymap.set('n', '<leader>fid', ':Telescope live_grep glob_pattern=')
vim.keymap.set('n', '<leader>/',  builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>t', builtin.builtin)

vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
vim.keymap.set('n', 'gr', builtin.lsp_references, {})

vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>gd', function ()
  vim.cmd.only()
  vim.cmd.vsplit()
  vim.schedule(function ()
    vim.cmd.wincmd('l')
    builtin.lsp_definitions({reuse_win=false})
  end)
end, {})

vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {})
vim.keymap.set('n', '<leader>gt', function ()
  vim.cmd.only()
  vim.cmd.vsplit()
  vim.schedule(function ()
    vim.cmd.wincmd('l')
    builtin.lsp_type_definitions({reuse_win=false})
  end)
end, {})

vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('x', '<leader>fw', function ()
  vim.api.nvim_feedkeys('"9y', 'nx', true)
  local search = vim.fn.getreg('9')
  builtin.grep_string({search=search})
end)

vim.keymap.set('n', '<leader>FA', function() builtin.find_files({
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


vim.keymap.set('n', '<leader>gf', function() builtin.find_files({ default_text = vim.fn.expand('<cfile>') }) end)

local function open_picker_with_current_search(picker)
  return function(prompt_bufnr)
    local state = require("telescope.actions.state")
    local actions = require("telescope.actions")

    local search = state.get_current_line()
    actions.close(prompt_bufnr)
    picker({default_text = search})
  end
end

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-a>"] = require('telescope.actions').nop,
        ["<CR>"] = require('telescope.actions').select_default + M.post_select,
      }
    },
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
      "--hidden",
      "--trim"
    }
  },
  pickers = {
    find_files = {
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '-g', '!.git',
        '-g', '!node_modules'
      },
      mappings = {
        i = {
          ["<C-a>"] = open_picker_with_current_search(builtin.buffers),
        },
        n = {
          ["<C-a>"] = open_picker_with_current_search(builtin.buffers),
        }
      }
    },
    buffers = {
      mappings = {
        i = {
          ["<C-a>"] = open_picker_with_current_search(builtin.find_files),
        },
        n = {
          ["<C-a>"] = open_picker_with_current_search(builtin.find_files),
        }
      }
    },
  }
})

-- telescope doesn't play niceley with 'winborder' yet
vim.api.nvim_create_autocmd('User', {
  pattern='TelescopeFindPre',
  callback=function ()
    local old_winborder = vim.o.winborder
    vim.o.winborder = 'none'

    vim.api.nvim_create_autocmd('WinLeave', {
      once=true,
      callback = function ()
        vim.opt.winborder = old_winborder
      end})
  end
})
