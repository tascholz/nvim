local M = {}

local function cycle_priorities(current)
    local priorities = { "low", "medium", "high" }
    local i = 0
    for idx, val in ipairs(priorities) do
      if val == current then
        i = idx
        break
      end
    end
    return priorities[(i % #priorities) + 1]
end

function M.cycle_done(state)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    if state.todos[line] then
        state.todos[line].done = not state.todos[line].done
        state.save_todos()
    end
end

function M.delete_todo(state)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    if state.todos[line] then
        table.remove(state.todos, line)
        state.save_todos()
    end
end

function M.add_todo(state)
    vim.ui.input({ prompt = "Add Todo: " }, function(input)
        if input and input ~= "" then
            table.insert(state.todos, { text = input, done = false, priority = "low", category="None" })
            state.save_todos()
        end
    end)
end

function M.edit_todo(state)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local current = state.todos[line]
    if current then
        vim.ui.input({ prompt = "Edit Todo:", default = current.text }, function(new_text)
            if new_text and new_text ~= "" then
                current.text = new_text
                state.save_todos()
            end
        end)
    end
end

function M.cycle_priority(state)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local current = state.todos[line]
    if current then
        current.priority = cycle_priorities(current.priority)
        state.save_todos()
    end
end

function M.cycle_category(state)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local current = state.todos[line]
    if current.category then
        local cat_idx = nil
        for i, v in ipairs(state.categories) do
            if v == current.category then
                print(i)
                cat_idx = i
                break
            end
        end
        current.category = state.categories[(cat_idx % #state.categories) + 1]
    else
        current.category = state.categories[1]
    end
    state.save_todos()
end

function M.add_category(state)
    vim.ui.input({ prompt = "Add Category: " }, function(input)
        if input and input ~= "" then
            table.insert(state.categories, input)
            state.save_categories()
        end
    end)
end

function M.print_categories(state)
    print("Cats: " .. state.categories[1])
end

return M
