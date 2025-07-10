return {
  {
    "nishu-murmu/ThemeSwitch.nvim",
    config = function()
        require('ThemeSwitch').setup({
        
        })
    end
  },
  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.cmd [[colorscheme gruvbox-material]]
    end,
  },
  {
    'ingenarel/cyberpunk-neon.nvim',
  }
}
