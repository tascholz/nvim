return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            init_open_folds = 'always',
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes/notes',
              website = '~/notes/website',
            },
          },
        },
        ['core.presenter'] = {
          config = {
            zen_mode = 'zen-mode',
          },
        },
      },
    }
  end,
}
