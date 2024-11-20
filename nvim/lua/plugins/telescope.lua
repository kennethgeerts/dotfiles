return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("telescope").load_extension("ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", builtin.find_files, {})
      vim.keymap.set("n", "<leader>r", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader>rg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})
    end,
  },
}
