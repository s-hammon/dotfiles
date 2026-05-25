if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
  local template = {
    ".PHONY: all clean test",
    "",
    "all:",
    "clean:",
    "test:",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
end
