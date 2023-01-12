require("bufferline").setup{
  options = {
    numbers = function (opts)
      if (opts.ordinal <= 9) then
        return "⌥"..opts.ordinal
      else
        return ""
      end
    end,
    separator_style = 'slant'
  }
}
