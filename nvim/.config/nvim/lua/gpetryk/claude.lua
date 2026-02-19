local CLAUDE_FILTER = "title:Claude and neighbor:right"
local function is_claude_ready()
  local find_claude_win_cmd = { "kitten", "@", "ls", "--match", CLAUDE_FILTER }
  local claude_window = vim.system(find_claude_win_cmd):wait()

  return claude_window.code == 0
end

local function wait_for_claude(callback)
  if not is_claude_ready() then
    vim.system({ "kitten", "@", "action", "launch_claude" }):wait()
    vim.print("Starting Claude...")
  end

  local timer = vim.uv.new_timer()
  if not timer then
    error("failed to initialize timer")
  end

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if is_claude_ready() then
        timer:stop()

        if callback then
          callback()
        end
      end
    end)
  )
end

local function switch_to_claude()
  wait_for_claude(vim.schedule_wrap(function()
    vim.system({ "kitten", "@", "focus-window", "--match", CLAUDE_FILTER }):wait()
  end))
end

local function send_to_claude(text, focus)
  vim.schedule(function()
    wait_for_claude(function()
      vim.system({ "kitten", "@", "send-text", "--match", CLAUDE_FILTER, text .. " " }):wait()

      if focus then
        switch_to_claude()
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
