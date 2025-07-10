local m = {}

local todo_file = vim.fn.stdpath("data") .. "/todo.json"
local category_file = vim.fn.stdpath("data") .. "/category.json"
m.todos = {}
m.categories = {}

function m.load_todos()
    local f = io.open(todo_file, "r")
    if f then
        local content = f:read("*a")
        f:close()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and type(data) == "table" then
            m.todos = data
        end
    end
end

function m.save_todos()
    vim.fn.mkdir(vim.fn.fnamemodify(todo_file, ":h"), "p")
    local f = io.open(todo_file, "w")
    if f then
        f:write(vim.fn.json_encode(m.todos))
        f:close()
    end
end

function m.load_categories()
    local f = io.open(category_file, "r")
    if f then
        local content = f:read("*a")
        f:close()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and type(data) == "table" then
            m.categories = data
        end
    end
end

function m.save_categories()
    vim.fn.mkdir(vim.fn.fnamemodify(category_file, ":h"), "p")
    local f = io.open(category_file, "w")
    if f then
        f:write(vim.fn.json_encode(m.categories))
        f:close()
    end
end

if vim.fn.filereadable(todo_file) and #m.todos == 0 then
    m.load_todos()
end

if vim.fn.filereadable(category_file) and #m.categories == 0 then
    m.load_categories()
end

return m
