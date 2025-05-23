# Personal Neovim Configuration

My personalized Neovim configuration. This repository is actively maintained and evolves alongside my development needs.

## Requirements

- Neovim >= 0.9.0
- Npm
- Ripgrep
- Nerd Font

## Plugins

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [mason.nvim](https://github.com/williamboman/mason.nvim) - Package manager for LSP servers
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) - Additional linting/formatting
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git operations
- [undotree](https://github.com/mbbill/undotree) - Visual undo history
- [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) - Start screen
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer line
- [tiny-glimmer.nvim](https://github.com/link/to/tiny-glimmer) - Visual cue on yank/paste/undo/redo/search 
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close pairs
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Code commenting
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugging
- [live-preview.nvim](https://github.com/link/to/live-preview) - Markdown/HTML preview
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [leap.nvim](https://github.com/ggandor/leap.nvim) - Leap
- [nvim-surround](https://github.com/kylechui/nvim-surround) - Surround selection
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) - Java LSP
- [VimTeX](https://github.com/lervag/vimtex) - LaTeX syntax 
- [mini.move](https://github.com/echasnovski/mini.move) - Line/Selection Moving
- [neogen](https://github.com/danymat/neogen) - Annotation Toolkit
- [java-project-creator](https://github.com/diogof146/java-project-creator.nvim) - Creating Java and Maven projects
<!-- - [garbage-day.nvim](https://github.com/Zeioth/garbage-day.nvim) - Garbage collector for LSP-->

## Installation

1. Backup existing config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone repository:
```bash
git clone https://github.com/diogof146/nvim-config.git ~/.config/nvim
```

3. Start Neovim - Lazy.nvim will automatically install plugins

## LSP Setup

Run `:Mason` and install needed language servers:
- pyright (Python)
- tsserver (JavaScript/TypeScript)
- lua_ls (Lua)
- clangd (C/C++)
- jdtls (Java)

## Updates

Configuration updated regularly. Star the repository for updates.
