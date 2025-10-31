vim.g.python3_host_prog = vim.fn.stdpath("config") .. "/.venv/bin/python"
if vim.fn.executable(vim.g.python3_host_prog) == 0 then
  vim.schedule(function()
    --- @param msg string
    local function warn(msg)
      vim.schedule(function ()
        vim.notify(msg:gsub('\n', ''), vim.log.levels.WARN)
      end)
    end

    local function handle_error(out)
      if out.code ~= 0 then
        warn("unable to set up python: " .. out.stderr)
      end
    end

    local buffer = ''
    ---@param msg string
    local function handle_stderr(_, msg)
      if not msg then
        return
      end
      buffer = buffer .. msg

      if msg:sub(-1) == '\n' then
        warn(buffer)
        buffer = ''
      end
    end

    local success, result_or_error = pcall(function ()
      warn("python is not available... trying to install with uv")

      vim.system({"cd", vim.fn.stdpath("config")})
      vim.system({"uv", "python", "install", "3.14"}, {stderr=handle_stderr}, handle_error):wait()
      vim.system({"uv", "sync"}, {stderr=handle_stderr}, handle_error):wait()
    end)

    if not success then
      local msg = "unable to set up python: "

      if not vim.fn.executable("uv") then
        msg = msg .. "uv not available"
      else
        msg = msg .. "\n" .. result_or_error
      end

      warn(msg)
    else
      warn("successfuly set up python provider")
    end
  end)
end
