vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.cursorline = true
vim.o.confirm = true
vim.o.updatetime = 250
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.undofile = true

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split"
vim.o.scrolloff = 10

vim.g.loaded_python3_provider = 0

-- NOTE: if this doesn't work for some reason, get the bootstrap
-- from lazy.nvim; I'm guessing it won't because of vim.uv
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "config/plugins" }, {
  change_detection = { notify = false },
})

vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform-vars",
    tfstate = "json",
  },
})

require("config.autoformat")

-- [[ Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Return to normal mode from terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Source current file
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source file" })
-- Lua: run this line
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "E[x]ecute lua line" })
-- Lua: run selection
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "E[x]ecute lua selection" })

-- format JSON with jq
vim.keymap.set("n", "<leader>jq", ":%!jq .<CR>", { desc = "Format JSON with jq" })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- 日本語入力ＦＥＰ
local function toggle_ibus()
  local current_engine = vim.fn.system("ibus engine"):gsub("%s+", "")

  if current_engine == "anthy" then
    vim.fn.system("ibus engine xkb:us::eng")
    vim.notify("IME: English", vim.log.levels.INFO)
  else
    vim.fn.system("ibus engine anthy")
    vim.notify("IME: Anthy", vim.log.levels.INFO)
  end
end

vim.keymap.set("i", "<C-\\>", toggle_ibus, { desc = "Toggle IME (Anthy/English" })

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("IbusAutoEnglish", { clear = true }),
  callback = function()
    local current_engine = vim.fn.system("ibus engine"):gsub("%s+", "")
    if current_engine ~= "xkb:us::eng" then
      vim.fn.system("ibus engine xkb:us::eng")
    end
  end,
})

-- Plugins in development
local dev_workspace = vim.fn.expand("~/projects/plugins/")

if not dev_workspace:match("[\\/]$") then
  dev_workspace = dev_workspace .. "/"
end

if vim.fn.isdirectory(dev_workspace) == 0 then
  vim.notify("Dev workspace not found: " .. dev_workspace, vim.log.level.WARN)
end

local function dev_load(plugin_name)
  local path = dev_workspace .. plugin_name
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("Plugin directory not found: " .. path, vim.log.level.ERROR)
    return
  end

  vim.opt.rtp:append(path)

  local plugin_dir = path .. "/plugin"
  if vim.fn.isdirectory(plugin_dir) == 1 then
    local files = vim.fn.globpath(plugin_dir, "**/*.{lua,vim}", false, true)
    for _, file in ipairs(files) do
      vim.cmd("source " .. file)
    end
  end

  vim.notify("Loaded dev plugin: " .. plugin_name, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("DevLoad", function(opts)
  dev_load(opts.args)
end, {
  nargs = 1,
  complete = function(ArgLead, _, _)
    if vim.fn.isdirectory(dev_workspace) == 0 then
      return {}
    end

    local folders = vim.fn.globpath(dev_workspace, "*", false, true)
    local names = {}
    for _, folder in ipairs(folders) do
      table.insert(names, vim.fn.fnamemodify(folder, ":t"))
    end

    return vim.tbl_filter(function(name)
      return name:match("^" .. ArgLead)
    end, names)
  end,
})
