local M = {}

local function get_priority_highlight(priority)
    if priority == "high" then
        return "DiagnosticError"
    elseif priority == "medium" then
        return "DiagnosticWarn"
    elseif priority == "low" then
        return "DiagnosticHint"
    else
        return "Comment"
    end
end

function M.render_lines(buf, todos, categories, start_line)
    start_line = start_line or 0
    local lines = {}
    for _, todo in ipairs(todos) do
        local icon = todo.done and " " or " "
        local category = "Nil"
        if todo.category then
            category = todo.category
        end
        table.insert(lines, icon .. todo.text .. " [" .. category .. "]")
    end
    vim.api.nvim_buf_set_lines(buf, start_line, -1, false, lines)

    for i, todo in ipairs(todos) do
        if todo.done then
            vim.api.nvim_buf_add_highlight(buf, -1, "Comment", i -1, 0, -1)
        else
            vim.api.nvim_buf_add_highlight(buf, -1, get_priority_highlight(todo.priority), i -1, 0, -1)
        end
    end
end

return M
