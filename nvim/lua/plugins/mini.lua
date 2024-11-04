return {
  'echasnovski/mini.nvim',
  config = function()
    local statusline = require('mini.statusline')
    statusline.setup { use_icons = vim.g.have_nerd_font }
    statusline.section_location = function()
      return '%2l:%-2v'
    end
    require('mini.starter').setup()
    require('mini.tabline').setup()
    require('mini.basics').setup()
  end,
}
