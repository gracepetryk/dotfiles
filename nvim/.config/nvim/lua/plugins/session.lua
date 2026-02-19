-- require('plugins.folds')
local function get_session_prefix(legacy, use_cwd)
  local Lib = require("auto-session.lib")
  local Config = require("auto-session.config")
  -- Sometimes we want to see what the default session name would be for the cwd, so
  -- if this flag is set, we should ignore the manually named session
  if not use_cwd and AutoSession.manually_named_session and vim.v.this_session and vim.v.this_session ~= "" then
    local session_name = Lib.escaped_session_path_to_session_name(vim.v.this_session)
    Lib.logger.debug("get_session_name - manually_named_session is true, session_name: " .. session_name)
    return session_name
  end

  local cwd = vim.fn.getcwd(-1, -1)
  local git_branch_name = Config.git_use_branch_name and Lib.get_git_branch_name(nil, Config.git_use_branch_name) or nil
  local custom_tag = Config.custom_session_tag and Config.custom_session_tag(cwd) or nil

  local session_name = Lib.combine_session_name_with_git_and_tag(cwd, git_branch_name, custom_tag, legacy)
  Lib.logger.debug("get_session_name, session_name: ", session_name)
  return Config.root_dir .. Lib.escape_session_name(session_name)
end

local function no_restore_hook()
  local Lib = require("auto-session.lib")
  local session_extra = Lib.escape_string_for_vim(get_session_prefix(false, true) .. "x.vim")
  local cmd = "silent! source " .. session_extra
  vim.cmd(cmd)
end

---@type AutoSession.Config
return {
  auto_restore = true,
  suppressed_dirs = { "~/Projects", "~/Downloads", "/" },
  cwd_change_handling = false,
  auto_restore_last_session = false,
  args_allow_files_auto_save = true,
  args_allow_single_directory = true,
  legacy_cmds = false,
  session_lens = {
    load_on_setup = true,
  },
  save_extra_data = require("gpetryk.session_folds").save_extra_data,
  restore_extra_data = require("gpetryk.session_folds").restore_extra_data,
  close_filetypes_on_save = {
    "checkhealth",
    "help",
    "terminal",
    "snacks_terminal",
    "dap-view",
    "dap-repl",
    "dap-view-term",
  },
  no_restore_cmds = {
    no_restore_hook,
  },
}
