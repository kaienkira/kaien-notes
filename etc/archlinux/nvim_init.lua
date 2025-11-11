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

vim.opt.mouse = ""
vim.opt.guicursor = ""
vim.opt.listchars = "eol:$"
vim.opt.hlsearch = false

vim.opt.termguicolors = true
vim.cmd.colorscheme("default")
vim.opt.background = "dark"

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

-- bootstrap lazy.nvim
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

-- plugins
require("lazy").setup({
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        config = function()
            require('github-theme').setup({
                options = {
                    transparent = true,
                },
            })
            vim.cmd.colorscheme("github_dark")
            vim.opt.background = "dark"
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                sync_install = true,
                auto_install = false,
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "c_sharp",
                    "go",
                    "javascript",
                    "lua",
                    "php",
                    "rust",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end
    },
})

-- autocmd
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.c", "*.cc", "*.cpp", "*.go", "*.rs", "*.cs" },
    callback = function()
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.opt_local.foldlevel = 99
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "Makefile", "makefile", "*.mak", "*.go" },
    callback = function()
        vim.opt_local.expandtab = false
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.html", "*.xml" },
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
