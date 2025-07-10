return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = '/home/tscholz/.virtualenvs/debugpy/bin/python',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
    end
      end

      dap.configurations.python = {
        {
          type = 'python';
          request = 'launch';
          name = 'Launch file';

          program = "${file}";
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end;
        }
      }
    end,
  },
  {
    "miroshQa/debugmaster.nvim",
    config = function()
      local dm = require("debugmaster")
      vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true})
      vim.keymap.set("t", "<C-/>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
    end
  }
}
