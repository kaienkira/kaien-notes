--- vim options
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.statusline = "%m%r%h%([File:%F] [Col:%v] [Lin:%l/%L/%p%%]%)"
vim.opt.ambiwidth = "double"
vim.opt.wildmenu = true

vim.opt.listchars = "eol:$"
vim.opt.hlsearch = false

vim.cmd("colorscheme vim")
vim.opt.background = "light"

function BR_RelativeNumberToggle()
    if vim.opt.relativenumber:get() then
        vim.opt.relativenumber = false
        vim.opt.number = true
    else
        vim.opt.number = true
        vim.opt.relativenumber = true
    end
end

function BR_HighlightSearchWordUnderCursor()
    vim.cmd('normal! *N')
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end

vim.keymap.set("i", "<C-j>", "<C-x><C-p>")
vim.keymap.set("n", "<C-j>", BR_RelativeNumberToggle)
vim.keymap.set("n", "<C-k>", BR_HighlightSearchWordUnderCursor)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
