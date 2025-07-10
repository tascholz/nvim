return {
  "todo",
  dir = vim.fn.stdpath("config") .. "/lua/todo",
  lazy = false,
  keys = {
    { "<leader>ww", function() require("todo").open_todo_window() end, desc = "Open Todo App" },
  },
}
