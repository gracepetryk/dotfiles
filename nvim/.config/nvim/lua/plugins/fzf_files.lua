-- File picker that lists open buffers ahead of everything else and marks them,
-- and leaves ignored files out until the tracked ones have no match for the
-- query.
local fzf = require("fzf-lua")

local M = {}

local EXCLUDES = { "-g", "!.git", "-g", "!node_modules" }
local TRACKED_CMD = vim.list_extend({ "rg", "--files", "--hidden" }, EXCLUDES)
local IGNORED_CMD = vim.list_extend({ "rg", "--files", "--hidden", "--no-ignore" }, EXCLUDES)

local function shell_join(args)
  return table.concat(vim.tbl_map(vim.fn.shellescape, args), " ")
end

--- Paths of listed buffers that are files under `cwd`, relative to it, most
--- recently used first.
local function open_buffer_paths(cwd)
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  table.sort(bufs, function(a, b)
    return a.lastused > b.lastused
  end)

  local paths = {}
  for _, buf in ipairs(bufs) do
    local name = buf.name
    local rel = name ~= "" and vim.fs.relpath(cwd, name)
    local stat = rel and vim.uv.fs_stat(name)
    if stat and stat.type == "file" then
      table.insert(paths, rel)
    end
  end
  return paths
end

--- Shell pipeline printing `<tag>\t<path>` lines: open buffers (`b`), then
--- tracked files (`t`), then ignored files (`i`) while `flag` exists. A path is
--- printed once, under the first tag it shows up with, so listing buffers first
--- also wins them fzf's index tiebreak.
local function build_cmd(cwd, flag)
  local parts = {}

  local buffers = open_buffer_paths(cwd)
  if #buffers > 0 then
    table.insert(parts, "printf 'b\\t%s\\n' " .. shell_join(buffers))
  end

  table.insert(parts, shell_join(TRACKED_CMD) .. [[ | awk '{ print "t\t" $0 }']])
  table.insert(
    parts,
    ("if [ -e %s ]; then %s | awk '{ print \"i\\t\" $0 }'; fi"):format(
      vim.fn.shellescape(flag),
      shell_join(IGNORED_CMD)
    )
  )

  return "{ " .. table.concat(parts, "; ") .. "; } | awk '{ path = $0; sub(/^[^\\t]*\\t/, \"\", path) } !seen[path]++'"
end

--- Turns a `<tag>\t<path>` line into a file entry behind a marker column: `+`
--- for open buffers, blank otherwise. Ignored files are dimmed. Runs in
--- fzf-lua's headless worker, so it can't close over anything.
local function transform(line, opts)
  local tag, path = line:match("^(%a)\t(.*)$")
  local entry = path and FzfLua.make_entry.file(path, opts)
  if not entry then
    return nil
  end

  local utils = FzfLua.utils
  if tag == "b" then
    return utils.ansi_codes.yellow("+") .. utils.nbsp .. entry
  elseif tag == "i" then
    return " " .. utils.nbsp .. utils.ansi_codes.dark_grey(utils.strip_ansi_coloring(entry))
  end
  return " " .. utils.nbsp .. entry
end

local TOGGLE_IGNORED_KEY = "alt-i"

--- fzf binds that pull in the ignored files, by pressing TOGGLE_IGNORED_KEY on
--- the user's behalf, once a non-empty query stops matching anything. They're
--- held back until the list has finished loading, so a query typed while files
--- are still streaming in doesn't set them off early.
local function zero_match_binds(flag)
  local fallback = ([[if [ -n "$FZF_QUERY" ] && [ ! -e %s ]; then echo 'trigger(%s)'; fi]]):format(
    vim.fn.shellescape(flag),
    TOGGLE_IGNORED_KEY
  )
  return {
    zero = "transform:" .. fallback,
    start = "+unbind(zero)",
    load = "+rebind(zero)",
  }
end

--- Opens the picker. TOGGLE_IGNORED_KEY lists or hides the ignored files
--- in place.
function M.find_files(opts)
  opts = opts or {}
  local cwd = vim.fs.normalize(opts.cwd or vim.uv.cwd())
  -- its existence is what includes the ignored files, so toggling them is a
  -- reload of the same command rather than a new picker
  local flag = vim.fn.tempname()

  fzf.files({
    cwd = cwd,
    query = opts.query,
    raw_cmd = build_cmd(cwd, flag),
    fn_transform = transform,
    -- the command always mentions --no-ignore, so the flags would say ignored
    -- files are listed whether or not they are
    winopts = { title_flags = false },
    keymap = { fzf = zero_match_binds(flag) },
    actions = {
      [TOGGLE_IGNORED_KEY] = {
        fn = function()
          if vim.uv.fs_stat(flag) then
            os.remove(flag)
          else
            assert(io.open(flag, "w")):close()
          end
        end,
        reload = true,
      },
      ["alt-h"] = false,
      ["alt-f"] = false,
      ["ctrl-a"] = function()
        fzf.buffers({ query = fzf.get_last_query() })
      end,
    },
  })
end

return M
