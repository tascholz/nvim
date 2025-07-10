-- lua/todo/window.lua
local ui = require("todo.ui")

local M = {}

local function shrink_and_close(wins, bufs)
  coroutine.wrap(function()
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
    for _, buf in ipairs(bufs) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end)()
end

local function render_title(buf)
  local title = {
    " ████████╗ ██████╗ ██████╗  ██████╗ ",
    " ╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗",
    "    ██║   ██║   ██║██████╔╝██║   ██║",
    "    ██║   ██║   ██║██╔═══╝ ██║   ██║",
    "    ██║   ╚██████╔╝██║     ╚██████╔╝",
    "    ╚═╝    ╚═════╝ ╚═╝      ╚═════╝ ",
    "                                   ",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, title)
end

local function render_statusline(buf, todos)
  local total = #todos
  local done = 0
  for _, todo in ipairs(todos) do
    if todo.done then
      done = done + 1
    end
  end
  local status = string.format("%d/%d tasks completed", done, total)
  vim.api.nvim_buf_set_lines(buf, 1, -1, false, {status})
end

function M.open(state, input)
  local win_width = math.floor(vim.o.columns * 0.5)
  local win_height = math.floor(vim.o.lines * 0.5)
  local center_row = math.floor((vim.o.lines - win_height) / 2)
  local center_col = math.floor((vim.o.columns - win_width) / 2)

  local title_buf = vim.api.nvim_create_buf(false, true)
  local todo_buf = vim.api.nvim_create_buf(false, true)
  local status_buf = vim.api.nvim_create_buf(false, true)

  local title_height = 7
  local status_height = 3
  local todo_height = win_height - title_height - status_height

  local title_win = vim.api.nvim_open_win(title_buf, false, {
    relative = "editor",
    row = center_row,
    col = center_col,
    width = win_width,
    height = title_height,
    style = "minimal",
    border = "rounded",
  })

  local todo_win = vim.api.nvim_open_win(todo_buf, true, {
    relative = "editor",
    row = center_row + title_height,
    col = center_col,
    width = win_width,
    height = todo_height,
    style = "minimal",
    border = "single",
  })

  local status_win = vim.api.nvim_open_win(status_buf, false, {
    relative = "editor",
    row = center_row + title_height + todo_height,
    col = center_col,
    width = win_width,
    height = status_height,
    style = "minimal",
    border = "single",
  })

  render_title(title_buf)
  ui.render_lines(todo_buf, state.todos, state.categories)
  render_statusline(status_buf, state.todos)

  local function refresh()
    ui.render_lines(todo_buf, state.todos, state.categories)
    render_statusline(status_buf, state.todos)
  end

  vim.keymap.set('n', '<CR>', function()
    input.cycle_done(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'd', function()
    input.delete_todo(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'a', function()
    input.add_todo(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'e', function()
    input.edit_todo(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'p', function()
    input.cycle_priority(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'c', function()
    input.cycle_category(state)
    refresh()
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'o', function()
    input.add_category(state)
  end, { buffer = todo_buf })

  vim.keymap.set('n', 'u', function()
    input.print_categories(state)
  end, { buffer = todo_buf })


  vim.keymap.set('n', 'q', function()
    shrink_and_close({ title_win, todo_win, status_win }, { title_buf, todo_buf, status_buf })
  end, { buffer = todo_buf })
end

return M

