local module = {}


function module.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.keymap.set(mode, lhs, rhs, options)
end


---@class M.CycleOpts
---@field reset_events string[]
--- A list of events that when fired, will return the cycle to   
--- it's ground state.

---@type M.CycleOpts
local default_opts = { reset_events = {"CursorMoved", "InsertEnter"}}

--- Creates a keybinding that cycles through a list of functions
---@param mode string passed to vim.keymap.set
---@param lhs string passed to vim.keymap.set
---@param fns (fun(): nil)[] A list of functions to cycle through. The first function  
--- should be considered a "ground state" and be able to handle a transition from any  
--- of the other states.
---@param opts M.CycleOpts | nil
---@return states
function module.cycle(mode, lhs, fns, opts)
  --- @type integer
  local current_state = 1

  local augroup_name = 'gpetryk.cycle.' .. lhs
  local augroup = vim.api.nvim_create_augroup(augroup_name, {})
  opts = vim.tbl_extend('force', default_opts, opts or {})

  ---@type table<integer, fun(state: integer): nil>
  local hook_fns = {}

  local function set_state(state)
    current_state = state
    fns[current_state]()

    if state ~= 1 then
      vim.api.nvim_create_autocmd(opts.reset_events, {
        group = augroup,
        once=true,
        callback = function ()
          set_state(1)
        end
      })
    end

    for _, hook_fn in pairs(hook_fns) do
      hook_fn(state)
    end
  end


  local function _cycle()
    for _, hook_fn in pairs(hook_fns) do
      hook_fn(current_state)
    end

    current_state = (current_state % #fns) + 1
    set_state(current_state)
  end

  set_state(1)
  vim.keymap.set(mode, lhs, _cycle)

  --- @class states
  --- @field add_hook_fn fun(hook_fn: fun(state: integer): nil): nil
  --- @field set_state fun(state: integer): nil
  --- @field get_state fun(): integer
  return {
    set_state = function(state) set_state(state) end,
    get_state = function () return current_state end,
    add_hook_fn = function (hook_fn) table.insert(hook_fns, hook_fn) end,
    hooks = hook_fns
  }
end

return module
