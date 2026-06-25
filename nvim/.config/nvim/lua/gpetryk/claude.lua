-- Returns true if any of the window's foreground processes is running claude.
local function is_claude_window(win)
  for _, proc in ipairs(win.foreground_processes or {}) do
    local exe = proc.cmdline and proc.cmdline[1]
    if exe and exe:match("claude$") then
      return true
    end
  end
  return false
end

-- Returns a list of kitty window objects running a claude process.
local function list_claude_windows()
  local result = vim.system({ "kitten", "@", "ls", "--match-tab", "state:active" }):wait()
  if result.code ~= 0 then
    return {}
  end

  local ok, data = pcall(vim.json.decode, result.stdout)
  if not ok then
    return {}
  end

  local windows = {}
  for _, os_window in ipairs(data) do
    for _, tab in ipairs(os_window.tabs or {}) do
      for _, win in ipairs(tab.windows or {}) do
        if is_claude_window(win) then
          table.insert(windows, win)
        end
      end
    end
  end

  return windows
end

-- Opens a telescope picker to choose between multiple Claude windows.
local function pick_claude_window(windows, on_choice)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Claude Sessions",
      finder = finders.new_table({
        results = windows,
        entry_maker = function(win)
          local label = win.title or "Claude"
          return {
            value = win,
            display = label,
            ordinal = label,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            on_choice(selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

-- Resolves which Claude window to target, then invokes callback with a kitty
-- match string (e.g. "id:42"). Logs an error if no session is running, and
-- prompts with a telescope picker if multiple sessions exist.
local function resolve_claude(callback)
  local windows = list_claude_windows()

  if #windows == 0 then
    vim.api.nvim_echo({ { "No running Claude session found", "ErrorMsg" } }, false, {})
  elseif #windows == 1 then
    callback("id:" .. windows[1].id)
  else
    vim.schedule(function()
      pick_claude_window(windows, function(win)
        callback("id:" .. win.id)
      end)
    end)
  end
end

local function switch_to_claude()
  vim.schedule(function()
    resolve_claude(vim.schedule_wrap(function(match)
      vim.system({ "kitten", "@", "focus-window", "--match", match }):wait()
    end))
  end)
end

local function send_to_claude(text, focus)
  vim.schedule(function()
    resolve_claude(function(match)
      vim.system({ "kitten", "@", "send-text", "--match", match, text .. " " }):wait()

      if focus then
        vim.system({ "kitten", "@", "focus-window", "--match", match }):wait()
      end
    end)
  end)
end

vim.keymap.set("n", "<leader>cc", switch_to_claude)
vim.keymap.set("n", "<leader>cs", function()
  local fpath = vim.fn.getreg("%")
  local line = vim.api.nvim_win_get_cursor(0)[1]

  send_to_claude("@" .. fpath .. ":" .. line, true)
end)

vim.keymap.set("n", "<leader>cp", function()
  local fpath = vim.fn.expand("%:p")
  local line = vim.api.nvim_win_get_cursor(0)[1]

  vim.fn.setreg("+", "@" .. fpath .. ":" .. line)
end)

vim.keymap.set("x", "<leader>cp", function()
  local fpath = vim.fn.expand("%:p")
  local startline = vim.fn.getpos("v")[2]
  local endline = vim.fn.getpos(".")[2]

  if startline > endline then
    local tmp = startline
    startline = endline
    endline = tmp
  end

  vim.fn.setreg("+", "@" .. fpath .. ":" .. startline .. "-" .. endline)

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
end)

vim.keymap.set("x", "<leader>cs", function()
  local fpath = vim.fn.getreg("%")
  local startline = vim.fn.getpos("v")[2]
  local endline = vim.fn.getpos(".")[2]

  if startline > endline then
    local tmp = startline
    startline = endline
    endline = tmp
  end

  send_to_claude("@" .. fpath .. ":" .. startline .. "-" .. endline, true)

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
end)
