local M = {}

local window = require("todo.window")
local state = require("todo.state")
local input = require("todo.input")

function M.open_todo_window()
    window.open(state, input)
end

return M
