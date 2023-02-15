require("dapui").setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "stacks", size = 0.2 },
        { id = "breakpoints", size = 0.2 },
        { id = "scopes", size = 0.6 },
      },
      size = 65, -- 60 columns
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
})
