local set = vim.opt_local

set.shiftwidth = 2
set.tabstop = 2
set.expandtab = true
set.number = true

vim.b._rest_nvim_count = vim.b._rest_nvim_count or 1

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = "[R]est: " .. desc })
end

map("n", "<leader>rr", "<cmd>Rest run<cr>", "[R]un request under cursor")
map("n", "<leader>rl", "<cmd>Rest last<cr>", "[L]ast request")
map("n", "<leader>ro", "<cmd>Rest open<cr>", "[O]pen result pane")

vim.api.nvim_set_hl(0, "@string.special.url", {
  undercurl = false,
  underline = false,
})
