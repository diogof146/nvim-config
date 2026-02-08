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
- [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) - Start screen
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer line
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close pairs
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugging
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [leap.nvim](https://github.com/ggandor/leap.nvim) - Leap
- [nvim-surround](https://github.com/kylechui/nvim-surround) - Surround selection
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) - Java LSP
- [VimTeX](https://github.com/lervag/vimtex) - LaTeX syntax
- [mini.move](https://github.com/echasnovski/mini.move) - Line/Selection Moving
- [neogen](https://github.com/danymat/neogen) - Annotation Toolkit
- [noice.nvim](https://github.com/folke/noice.nvim) - Better notifications
- [neoscroll](https://github.com/karb94/neoscroll.nvim) - Fast scrolling
- [mini.icons](https://github.com/echasnovski/mini.icons) - Icon provider
- [codediff.nvim](https://github.com/esmellert/codediff.nvim) - Side-by-side diff view
- [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) - Merge conflict resolution
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git decorations
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) - Lua development setup
- [lush.nvim](https://github.com/rktjmp/lush.nvim) - Colorscheme creation toolkit
- [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) - Color highlighter
- [project.nvim](https://github.com/ahmedkhalf/project.nvim) - Project root detection
- [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim) - Rainbow parentheses
- [recover.nvim](https://github.com/lucidph34r/recover.nvim) - Swap file management
- [substitute.nvim](https://github.com/gbprod/substitute.nvim) - Substitution/exchange operators
- [tiny-inline-diagnostics.nvim](https://github.com/rachartier/tiny-inline-diagnostics.nvim) - Inline LSP diagnostics
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto-close HTML/XML tags
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Sticky code headers
- [nvim-ts-endwise](https://github.com/RRethy/nvim-ts-endwise) - Auto-add "end" via Treesitter
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Syntax-aware text objects
- [undo-glow.nvim](https://github.com/yioneko/undo-glow.nvim) - Visual feedback for actions
- [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) - Xcode integration

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
