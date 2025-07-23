--- @param cmp blink.cmp.API
local function show_signature(cmp)
  local config = require('blink.cmp.config')

  vim.api.nvim_create_autocmd('InsertLeave', {
    once = true,
    callback = function ()
      config.signature.trigger.enabled = false
    end
  })

  config.signature.trigger.enabled = true
  require('blink.cmp.signature.trigger').show()
  return true
end

--- @param cmp blink.cmp.API
local function hide_signature(cmp)
  local config = require('blink.cmp.config')

  vim.api.nvim_create_autocmd('InsertLeave', {
    once = true,
    callback = function ()
      config.signature.trigger.enabled = false
    end
  })


  config.signature.window.show_documentation = true
  require('blink.cmp.signature.trigger').show()
  return true
end

---@module 'blink.cmp'
---@type blink.cmp.Config
return {
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
  -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
  -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-e: Hide menu
  -- C-k: Toggle signature help
  --
  -- See the full "keymap" documentation for information on defining your own keymap.
  keymap = {
    preset = 'default',


    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-y>'] = { 'select_and_accept' },
  },

  signature = {
    enabled = false,
  },

  completion = {
    documentation = {
      window = {
        border = 'rounded'
      }
    }
  },

  appearance = {
    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    -- Useful for when your theme doesn't support blink.cmp
    -- Will be removed in a future release
    use_nvim_cmp_as_default = false,
    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono'
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = { implementation = "prefer_rust_with_warning" }
  }
