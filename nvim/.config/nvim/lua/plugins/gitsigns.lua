require('gitsigns').setup {
  sign_priority=100,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<leader>h]', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '<leader>h[', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

local sign_spacing_augroup = vim.api.nvim_create_augroup('sign_spacing', {})

vim.fn.sign_define('spacing_sign', {text = ' '})
local spacing_sign_group = 'spacing'

vim.api.nvim_create_autocmd({'User', 'WinScrolled'}, {
  pattern='GitSignsUpdate,*',
  group=sign_spacing_augroup,
  callback=function ()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.fn.sign_unplace(spacing_sign_group, {buffer=bufnr})

    local win_first_line = vim.fn.line('w0', vim.fn.win_getid())
    local win_last_line = vim.fn.line('w$', vim.fn.win_getid())

    local line = win_first_line
    while line <= win_last_line do
      local priority
      if next(vim.fn.sign_getplaced(bufnr, {group='gitsigns_vimfn_signs_', lnum=line})[1].signs) ~= nil then
        -- there is a git sign, align it to the right
        priority = -100
      else
        -- no git sign, prevent multiple non-git signs
        priority = 99
      end

      vim.fn.sign_place(0, spacing_sign_group, 'spacing_sign', bufnr, {lnum=line, priority=priority})

      line = line + 1
    end
  end
})
