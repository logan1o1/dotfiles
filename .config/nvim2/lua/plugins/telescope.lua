local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<M-k>"] = actions.results_scrolling_up,
        ["<M-j>"] = actions.results_scrolling_down,
        ["<M-u>"] = actions.preview_scrolling_up,
        ["<M-n>"] = actions.preview_scrolling_down,
      },
    },
  },
  pickers = {
    find_files = { theme = "dropdown" },
  },
})
vim.keymap.set("n", "fh", builtin.help_tags)
vim.keymap.set("n", "fl", builtin.live_grep)
vim.keymap.set("n", "fg", builtin.grep_string)
vim.keymap.set("n", "ff", builtin.find_files)
vim.keymap.set("n", "fp", function()
  builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end)
