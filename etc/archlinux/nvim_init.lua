-- base vim options
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.statusline = "%m%r%h%([File:%F] [Col:%v] [Lin:%l/%L/%p%%]%)"
vim.opt.wildmenu = true

vim.opt.mouse = ""
vim.opt.guicursor = ""
vim.opt.listchars = "eol:$"
vim.opt.hlsearch = false

vim.opt.autoread = false
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
    vim.cmd("normal! *N")
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
            require("github-theme").setup({
                options = {
                    transparent = true,
                },
            })
            vim.cmd.colorscheme("github_dark")
            vim.opt.background = "dark"
        end
    },
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {},
        config = function()
            require("tree-sitter-manager").setup({
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
            })
        end
    },
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "clangd",
                "rust_analyzer",
                "gopls",
                "omnisharp",
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.1.9",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    fzy_native = {
                        override_generic_sorter = false,
                        override_file_sorter = true,
                    },
                },
            })
            require("telescope").load_extension("fzy_native")
        end
    },
    {
        "saghen/blink.cmp",
        version = "*",
        opts = {
            keymap = {
                preset = "none",
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Enter>"] = { "accept", "fallback" },
            },
            sources = {
                default = { "lsp" },
            },
        },
    },
})

-- lsp
vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = {
        ".git",
        ".clangd",
        "compile_commands.json",
    },
})
vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {
        ".git",
        "Cargo.toml",
    },
})
vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = {
        ".git",
        "go.mod",
    },
    settings = {
        gopls = {
            analyses = {
                QF1003 = false,
            },
        },
    },
})
vim.lsp.config("omnisharp", {
    cmd = {
        "OmniSharp",
        "-z",
        "--languageserver",
    },
    filetypes = { "cs" },
    root_markers = {
        ".git",
        "*.sln",
        "*.csproj",
    }
})
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("omnisharp")

vim.opt.signcolumn = "number"
vim.diagnostic.config({
    virtual_text = true
})

-- keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<F2>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<F3>", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<F8>", vim.lsp.buf.rename)
vim.keymap.set("n", "<F11>", require("telescope.builtin").lsp_references)
vim.keymap.set("n", "<F12>", require("telescope.builtin").lsp_definitions)

-- autocmd
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.c", "*.cc", "*.cpp", "*.h", "*.go", "*.rs", "*.cs" },
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
