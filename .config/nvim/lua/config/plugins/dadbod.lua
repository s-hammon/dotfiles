return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    init = function()
      vim.env.SQLCMDMAXVARTYPEWIDTH = "30"
      vim.env.SQLCMDMAXFIXEDTYPEWIDTH = "30"
      vim.env.SQLCMDWIDTH = "1000"
    end,
  },
  "kristijanhusak/vim-dadbod-completion",
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_win_width = 35
    end,
  },
}
