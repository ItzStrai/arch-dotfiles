-- ~/.config/nvim/init.lua

-- 1. УСТАНОВКА LAZY.NVIM (МЕНЕДЖЕР ПЛАГИНОВ)
-- Этот код автоматически скачает lazy.nvim, если он еще не установлен.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- последние стабильные релизы
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. НАСТРОЙКА ПЛАГИНОВ
-- Здесь мы перечисляем все плагины, которые хотим установить.
require("lazy").setup({
  -- Плагин для файлового дерева
  {
    'akinsho/bufferline.nvim',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup()
    end,
  },
  {
    "goolord/alpha-nvim",
    -- dependencies = { 'nvim-mini/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

      alpha.setup(dashboard.opts)
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- опционально, для иконок
    config = function()
      -- отключаем стандартный файловый менеджер netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      -- настраиваем nvim-tree
      require("nvim-tree").setup()
    end,
  },

  -- Плагин для подсветки синтаксиса
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- команда для обновления парсеров
    config = function()
      require('nvim-treesitter').setup {
        -- список языков для установки парсеров
        ensure_installed = { "cpp", "python", "lua", "vim", "vimdoc" },
        -- автоматически устанавливать недостающие парсеры
        auto_install = true,
        -- включить подсветку синтаксиса
        highlight = { enable = true, },
      }
    end,
  },
  -- Mason и Mason-lspconfig для управления LSP серверами
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  "williamboman/mason-lspconfig.nvim",

  -- nvim-lspconfig все еще нужен для предоставления конфигураций!
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Этот код теперь будет выполняться после загрузки плагина

      -- Указываем mason-lspconfig, какие серверы установить
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright" },
      })

      -- 1. (Опционально) Настраиваем серверы с помощью нового API
      vim.lsp.config('clangd', {
        root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
      })

      vim.lsp.config('pyright', {
        root_markers = { "pyproject.toml", "setup.py", ".git" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- 2. Включаем серверы
      vim.lsp.enable('clangd', 'pyright')

      -- 3. Настраиваем горячие клавиши через LspAttach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          -- ... добавьте любые другие нужные вам клавиши
        end,
      })
    end,
  },
-- Плагин для автодополнения
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- источник дополнений от LSP
      'hrsh7th/cmp-buffer',   -- источник дополнений из текущего буфера
      'hrsh7th/cmp-path',     -- источник дополнений для путей
      'L3MON4D3/LuaSnip',     -- движок для сниппетов
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter для подтверждения
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },
})

-- 3. ОБЩИЕ НАСТРОЙКИ NEOVIM
-- Номера строк
vim.wo.number = true
vim.wo.relativenumber = true

-- Использование 2 пробелов вместо таба
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- 4. ГОРЯЧИЕ КЛАВИШИ
-- Открывать/закрывать файловое дерево по Ctrl + b
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>')
