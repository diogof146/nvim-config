# Neovim Keybindings Reference

## Table of Contents

- [Buffer Management](#buffer-management)
- [Commenting](#commenting)
- [Completion (nvim-cmp)](#completion-nvim-cmp)
- [Custom Keymaps](#custom-keymaps)
- [Custom Leader Keymaps](#custom-leader-keymaps)
- [Dashboard](#dashboard)
- [Diagnostics](#diagnostics)
- [File Explorer (nvim-tree)](#file-explorer-nvim-tree)
- [Git](#git)
- [LSP (Language Server)](#lsp-language-server)
- [Leap (Motion)](#leap-motion)
- [Mini.nvim Plugins](#mininvim-plugins)
- [Other](#other)
- [Plenary](#plenary)
- [Surround](#surround)
- [Vim Defaults](#vim-defaults)
- [Window Management](#window-management)
- [Yank Management](#yank-management)

---

## Buffer Management

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>b` |  | :bp<CR> |

## Commenting

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `gc` | Toggle comment with highlight | <Lua 111: ~/.config/nvim/lua/plugins/undo-glow.lua:152> |
| x | `gc` | Toggle comment with highlight | <Lua 107: ~/.config/nvim/lua/plugins/undo-glow.lua:152> |
| n | `gcc` | Toggle comment line with highlight | <Lua 105: ~/.config/nvim/lua/plugins/undo-glow.lua:180> |
| o | `gc` | Comment textobject with highlight | <Lua 103: ~/.config/nvim/lua/plugins/undo-glow.lua:167> |

## Completion (nvim-cmp)

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| s | `<Tab>` | cmp.utils.keymap.set_map | <Lua 812: ~/.local/share/nvim/lazy/nvim-cmp/lua/cmp/utils... |
| s | `<S-Tab>` | cmp.utils.keymap.set_map | <Lua 809: ~/.local/share/nvim/lazy/nvim-cmp/lua/cmp/utils... |

## Custom Keymaps

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| x | `<Tab>` |  | >gv |
| n | `#` | Search hash with highlight | <Lua 104: ~/.config/nvim/lua/plugins/undo-glow.lua:138> |
| n | `*` | Search star with highlight | <Lua 14: ~/.config/nvim/lua/plugins/undo-glow.lua:125> |
| n | `,xS` | Setup xcode-build-server for LSP | <Lua 430: ~/.config/nvim/lua/plugins/xcodebuild.lua:181> |
| n | `,xk` | Clean Project | <Cmd>XcodebuildCleanProject<CR> |
| n | `,xU` | Uninstall App from Device | <Cmd>XcodebuildUninstallApp<CR> |
| n | `,xi` | Install App on Device | <Cmd>XcodebuildInstallApp<CR> |
| n | `,xu` | Boot Selected Simulator | <Cmd>XcodebuildBootSimulator<CR> |
| n | `,xa` | Show Code Actions | <Cmd>XcodebuildCodeActions<CR> |
| n | `,xq` | Show QuickFix List | <Cmd>Telescope quickfix<CR> |
| n | `,xC` | Show Code Coverage Report | <Cmd>XcodebuildShowCodeCoverageReport<CR> |
| n | `,xc` | Toggle Code Coverage | <Cmd>XcodebuildToggleCodeCoverage<CR> |
| n | `,xL` | Open Build Logs | <Cmd>XcodebuildOpenLogs<CR> |
| n | `,xl` | Toggle Build Logs | <Cmd>XcodebuildToggleLogs<CR> |
| n | `,xp` | Select Test Plan | <Cmd>XcodebuildSelectTestPlan<CR> |
| n | `,xs` | Select Build Scheme | <Cmd>XcodebuildSelectScheme<CR> |
| n | `,xd` | Select Device/Simulator | <Cmd>XcodebuildSelectDevice<CR> |
| n | `,x.` | Run Selected Tests | <Cmd>XcodebuildTestSelected<CR> |
| n | `,xT` | Run This Test Class | <Cmd>XcodebuildTestClass<CR> |
| n | `,xt` | Run Tests | <Cmd>XcodebuildTest<CR> |
| n | `,xR` | Run Without Building | <Cmd>XcodebuildRun<CR> |
| n | `,xr` | Build & Run Project | <Cmd>XcodebuildBuildRun<CR> |
| n | `,xb` | Build Project | <Cmd>XcodebuildBuild<CR> |
| n | `,X` | Show Xcodebuild Actions | <Cmd>XcodebuildPicker<CR> |
| n | `,dc` |  | <Lua 243: ~/.local/share/nvim/lazy/nvim-dap/lua/dap.lua:1... |
| n | `,dt` |  | <Lua 240: ~/.local/share/nvim/lazy/nvim-dap/lua/dap.lua:1... |
| o | `,F` |  | <Plug>(leap-backward) |
| o | `,f` |  | <Plug>(leap-forward) |
| n | `,pa` | Add Project Root | <Lua 180: ~/.config/nvim/lua/plugins/project-nvim.lua:47> |
| n | `,i` | Inspect Highlight | <Cmd>Inspect<CR> |
| n | `,s` |  | :execute "setlocal spell spelllang=" . input("Enter spell... |
| n | `C` |  | "+y$d$ |
| n | `F` |  | <Plug>(leap-from-window) |
| n | `G` | Go to last line and end | G$ |
| n | `N` | Search prev with highlight | <Lua 109: ~/.config/nvim/lua/plugins/undo-glow.lua:112> |
| n | `P` | Paste above with highlight | <Lua 13: ~/.config/nvim/lua/plugins/undo-glow.lua:85> |
| x | `S` | Add a surrounding pair around a visual selection | <Plug>(nvim-surround-visual) |
| n | `U` | Redo | <C-R> |
| x | `X` | Exchange visual | <Lua 98: ~/.config/nvim/lua/plugins/substitute.lua:111> |
| o | `as` | Select outer statement | <Lua 574: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `as` | Select outer statement | <Lua 573: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `a@` | Select outer attribute | <Lua 568: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `a@` | Select outer attribute | <Lua 567: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ar` | Select outer return | <Lua 564: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ar` | Select outer return | <Lua 563: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `a=` | Select outer assignment | <Lua 560: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `a=` | Select outer assignment | <Lua 559: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ak` | Select outer function call | <Lua 556: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ak` | Select outer function call | <Lua 555: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ab` | Select outer block | <Lua 542: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ab` | Select outer block | <Lua 530: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `al` | Select outer loop | <Lua 526: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `al` | Select outer loop | <Lua 524: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ac` | Select outer conditional | <Lua 497: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ac` | Select outer conditional | <Lua 495: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `aa` | Select outer parameter | <Lua 491: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `aa` | Select outer parameter | <Lua 489: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `af` | Select outer function | <Lua 419: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `af` | Select outer function | <Lua 418: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| n | `b` |  | q |
| n | `cS` | Change a surrounding pair, putting replacements on new lines | <Plug>(nvim-surround-change-line) |
| n | `cs` | Change a surrounding pair | <Plug>(nvim-surround-change) |
| x | `c` |  | "+ygvd |
| n | `cc` |  | <Lua 85: ~/.config/nvim/lua/config/autocmds.lua:134> |
| n | `c` |  | <Lua 26: ~/.config/nvim/lua/config/autocmds.lua:130> |
| n | `ds` | Delete a surrounding pair | <Plug>(nvim-surround-delete) |
| x | `f` |  | <Plug>(leap) |
| n | `f` |  | <Plug>(leap) |
| x | `gS` | Add a surrounding pair around a visual selection, on new lines | <Plug>(nvim-surround-visual-line) |
| n | `gg` | Go to first line and start | gg0 |
| o | `in` | Select inner number | <Lua 572: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `in` | Select inner number | <Lua 571: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `i@` | Select inner attribute | <Lua 570: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `i@` | Select inner attribute | <Lua 569: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ir` | Select inner return | <Lua 566: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ir` | Select inner return | <Lua 565: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `i=` | Select inner assignment | <Lua 562: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `i=` | Select inner assignment | <Lua 561: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ik` | Select inner function call | <Lua 558: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ik` | Select inner function call | <Lua 557: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ib` | Select inner block | <Lua 554: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ib` | Select inner block | <Lua 553: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `il` | Select inner loop | <Lua 529: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `il` | Select inner loop | <Lua 527: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ic` | Select inner conditional | <Lua 523: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ic` | Select inner conditional | <Lua 514: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `ia` | Select inner parameter | <Lua 494: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `ia` | Select inner parameter | <Lua 492: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| o | `if` | Select inner function | <Lua 488: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| x | `if` | Select inner function | <Lua 420: ~/.config/nvim/lua/plugins/ts-textobjects.lua:22> |
| n | `n` | Search next with highlight | <Lua 15: ~/.config/nvim/lua/plugins/undo-glow.lua:99> |
| n | `p` | Paste below with highlight | <Lua 106: ~/.config/nvim/lua/plugins/undo-glow.lua:71> |
| n | `q` |  | b |
| n | `ss` | Substitute line with highlight | <Lua 102: ~/.config/nvim/lua/plugins/substitute.lua:53> |
| n | `s` | Substitute with highlight | <Lua 101: ~/.config/nvim/lua/plugins/substitute.lua:39> |
| n | `sS` | Substitute to end of line | <Lua 100: ~/.config/nvim/lua/plugins/substitute.lua:67> |
| n | `sx` | Exchange operator | <Lua 99: ~/.config/nvim/lua/plugins/substitute.lua:95> |
| x | `s` | Substitute selection | <Lua 97: ~/.config/nvim/lua/plugins/substitute.lua:81> |
| n | `sxc` | Cancel exchange | <Lua 96: ~/.config/nvim/lua/plugins/substitute.lua:120> |
| n | `sxx` | Exchange line | <Lua 95: ~/.config/nvim/lua/plugins/substitute.lua:103> |
| n | `u` | Undo with highlight | <Lua 108: ~/.config/nvim/lua/plugins/undo-glow.lua:43> |
| n | `ySS` | Add a surrounding pair around the current line, on new lines (normal mode) | <Plug>(nvim-surround-normal-cur-line) |
| n | `yS` | Add a surrounding pair around a motion, on new lines (normal mode) | <Plug>(nvim-surround-normal-line) |
| n | `yss` | Add a surrounding pair around the current line (normal mode) | <Plug>(nvim-surround-normal-cur) |
| n | `ys` | Add a surrounding pair around a motion (normal mode) | <Plug>(nvim-surround-normal) |
| x | `zb` |  | <Lua 333: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `zb` |  | <Lua 332: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `zb` |  | <Lua 331: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `zz` |  | <Lua 330: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `zz` |  | <Lua 329: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `zz` |  | <Lua 328: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `zt` |  | <Lua 327: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `zt` |  | <Lua 326: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `zt` |  | <Lua 325: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<Plug>(nvim-surround-change-line)` | Change a surrounding pair, putting replacements on new lines | <Lua 155: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<Plug>(nvim-surround-change)` | Change a surrounding pair | <Lua 206: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<Plug>(nvim-surround-delete)` | Delete a surrounding pair | <Lua 383: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| x | `<Plug>(nvim-surround-visual-line)` | Add a surrounding pair around a visual selection, on new lines | <Lua 487: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| x | `<Plug>(nvim-surround-visual)` | Add a surrounding pair around a visual selection | <Lua 490: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<Plug>(nvim-surround-normal-cur-line)` | Add a surrounding pair around the current line, on new lines (normal mode) | <Lua 493: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<Plug>(nvim-surround-normal-line)` | Add a surrounding pair around a motion, on new lines (normal mode) | <Lua 89: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim-... |
| n | `<Plug>(nvim-surround-normal-cur)` | Add a surrounding pair around the current line (normal mode) | <Lua 238: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<Plug>(nvim-surround-normal)` | Add a surrounding pair around a motion (normal mode) | <Lua 203: ~/.local/share/nvim/lazy/nvim-surround/lua/nvim... |
| n | `<C-R>` | Redo with highlight | <Lua 110: ~/.config/nvim/lua/plugins/undo-glow.lua:57> |
| n | `<F5>` |  | <Cmd>ToggleTerm<CR> |
| n | `<F6>` |  | <Lua 356: ~/.config/nvim/lua/plugins/toggleterm.lua:362> |
| x | `<C-K>` |  | <Lua 339: ~/.config/nvim/lua/plugins/neoscroll.lua:35> |
| s | `<C-K>` |  | <Lua 338: ~/.config/nvim/lua/plugins/neoscroll.lua:35> |
| n | `<C-K>` |  | <Lua 337: ~/.config/nvim/lua/plugins/neoscroll.lua:35> |
| x | `<C-J>` |  | <Lua 336: ~/.config/nvim/lua/plugins/neoscroll.lua:32> |
| s | `<C-J>` |  | <Lua 335: ~/.config/nvim/lua/plugins/neoscroll.lua:32> |
| n | `<C-J>` |  | <Lua 334: ~/.config/nvim/lua/plugins/neoscroll.lua:32> |
| x | `<C-E>` |  | <Lua 324: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-E>` |  | <Lua 323: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-E>` |  | <Lua 322: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `<C-Y>` |  | <Lua 321: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-Y>` |  | <Lua 320: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-Y>` |  | <Lua 319: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `<C-F>` |  | <Lua 318: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-F>` |  | <Lua 317: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-F>` |  | <Lua 316: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `<C-B>` |  | <Lua 315: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-B>` |  | <Lua 314: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-B>` |  | <Lua 313: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `<C-D>` |  | <Lua 312: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-D>` |  | <Lua 311: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-D>` |  | <Lua 310: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| x | `<C-U>` |  | <Lua 309: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| s | `<C-U>` |  | <Lua 308: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<C-U>` |  | <Lua 305: ~/.local/share/nvim/lazy/neoscroll.nvim/lua/neo... |
| n | `<Plug>(git-conflict-prev-conflict)` | Git Conflict: Previous Conflict | <Cmd>GitConflictPrevConflict<CR> |
| n | `<Plug>(git-conflict-next-conflict)` | Git Conflict: Next Conflict | <Cmd>GitConflictNextConflict<CR> |
| v | `<Plug>(git-conflict-theirs)` | Git Conflict: Choose Theirs | <Cmd>GitConflictChooseTheirs<CR> |
| n | `<Plug>(git-conflict-theirs)` | Git Conflict: Choose Theirs | <Cmd>GitConflictChooseTheirs<CR> |
| v | `<Plug>(git-conflict-none)` | Git Conflict: Choose None | <Cmd>GitConflictChooseNone<CR> |
| n | `<Plug>(git-conflict-none)` | Git Conflict: Choose None | <Cmd>GitConflictChooseNone<CR> |
| v | `<Plug>(git-conflict-both)` | Git Conflict: Choose Both | <Cmd>GitConflictChooseBoth<CR> |
| n | `<Plug>(git-conflict-both)` | Git Conflict: Choose Both | <Cmd>GitConflictChooseBoth<CR> |
| v | `<Plug>(git-conflict-ours)` | Git Conflict: Choose Ours | <Cmd>GitConflictChooseOurs<CR> |
| n | `<Plug>(git-conflict-ours)` | Git Conflict: Choose Ours | <Cmd>GitConflictChooseOurs<CR> |
| x | `<S-Tab>` |  | <gv |

## Custom Leader Keymaps

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| o | `<Space>kR` | Previous return end | <Lua 610: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| n | `<Space>kR` | Previous return end | <Lua 609: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| o | `<Space>jR` | Next return end | <Lua 608: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| n | `<Space>jR` | Next return end | <Lua 607: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| o | `<Space>kr` | Previous return start | <Lua 606: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| n | `<Space>kr` | Previous return start | <Lua 605: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| o | `<Space>jr` | Next return start | <Lua 604: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>jr` | Next return start | <Lua 603: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| o | `<Space>ka` | Previous parameter start | <Lua 602: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| n | `<Space>ka` | Previous parameter start | <Lua 601: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| o | `<Space>ja` | Next parameter start | <Lua 600: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>ja` | Next parameter start | <Lua 599: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| o | `<Space>kL` | Previous loop end | <Lua 598: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| n | `<Space>kL` | Previous loop end | <Lua 597: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| o | `<Space>jL` | Next loop end | <Lua 596: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| n | `<Space>jL` | Next loop end | <Lua 595: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| o | `<Space>kl` | Previous loop start | <Lua 594: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| n | `<Space>kl` | Previous loop start | <Lua 593: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| o | `<Space>jl` | Next loop start | <Lua 592: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>jl` | Next loop start | <Lua 591: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| o | `<Space>kC` | Previous conditional end | <Lua 590: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| n | `<Space>kC` | Previous conditional end | <Lua 589: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| o | `<Space>jC` | Next conditional end | <Lua 588: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| n | `<Space>jC` | Next conditional end | <Lua 587: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| o | `<Space>kc` | Previous conditional start | <Lua 586: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| n | `<Space>kc` | Previous conditional start | <Lua 585: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| o | `<Space>jc` | Next conditional start | <Lua 584: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>jc` | Next conditional start | <Lua 583: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| o | `<Space>kF` | Previous function end | <Lua 582: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| n | `<Space>kF` | Previous function end | <Lua 581: ~/.config/nvim/lua/plugins/ts-textobjects.lua:41> |
| o | `<Space>jF` | Next function end | <Lua 580: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| n | `<Space>jF` | Next function end | <Lua 579: ~/.config/nvim/lua/plugins/ts-textobjects.lua:31> |
| o | `<Space>kf` | Previous function start | <Lua 578: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| n | `<Space>kf` | Previous function start | <Lua 577: ~/.config/nvim/lua/plugins/ts-textobjects.lua:45> |
| o | `<Space>jf` | Next function start | <Lua 576: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>jf` | Next function start | <Lua 575: ~/.config/nvim/lua/plugins/ts-textobjects.lua:35> |
| n | `<Space>ct` | Toggle Colors | <Cmd>ColorizerToggle<CR> |
| n | `<Space>9` | Go to tab 9 | <Lua 382: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>8` | Go to tab 8 | <Lua 381: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>7` | Go to tab 7 | <Lua 380: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>6` | Go to tab 6 | <Lua 379: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>5` | Go to tab 5 | <Lua 378: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>4` | Go to tab 4 | <Lua 377: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>3` | Go to tab 3 | <Lua 376: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>2` | Go to tab 2 | <Lua 375: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>1` | Go to tab 1 | <Lua 374: ~/.config/nvim/lua/plugins/window_manager.lua:120> |
| n | `<Space>tn` | New tab | <Cmd>tabnew<CR> |
| n | `<Space>wr` | Toggle resize mode | <Lua 373: ~/.config/nvim/lua/plugins/window_manager.lua:76> |
| n | `<Space>wv` | Split vertical | <Cmd>vsplit<CR> |
| n | `<Space>ws` | Split horizontal | <Cmd>split<CR> |
| n | `<Space>H` | Toggle all function folds | <Lua 151: ~/.config/nvim/lua/plugins/treesitter.lua:154> |
| n | `<Space>h` | Toggle current function fold | <Lua 185: ~/.config/nvim/lua/plugins/treesitter.lua:90> |
| n | `<Space>fk` | Find keymaps | <Lua 178: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fs` | Find symbols in file | <Lua 177: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fc` | Find in current buffer | <Lua 175: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fw` | Find word under cursor | <Lua 174: ~/.config/nvim/lua/plugins/telescope.lua:102> |
| n | `<Space>fr` | Recent files | <Lua 173: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fh` | Help tags | <Lua 172: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fb` | Find buffers | <Lua 171: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>fg` | Live grep | <Lua 170: ~/.config/nvim/lua/plugins/telescope.lua:88> |
| n | `<Space>ff` | Find files | <Lua 169: ~/.config/nvim/lua/plugins/telescope.lua:83> |
| n | `<Space>n` |  | <Lua 153: ~/.config/nvim/lua/plugins/neo_tree.lua:270> |
| n | `<Space>tr` | Reload Theme | <Lua 28: ~/.config/nvim/lua/config/keymaps.lua:63> |
| n | `<Space>r` |  | :%s/\<<C-R><C-W>\>//gc<Left><Left><Left> |

## Dashboard

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<CR>` |  | @<Lua 703: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `b` | Dashboard-action: Bookmarks | @<Lua 693: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `c` | Dashboard-action: Configuration | @<Lua 698: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `f` | Dashboard-action: Find File | @<Lua 400: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `h` | Dashboard-action: Help Tags | @<Lua 696: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `l` | Dashboard-action: Plugin Manager | @<Lua 694: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `n` | Dashboard-action: New File | @<Lua 692: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `q` | Dashboard-action: Quit Neovim | @<Lua 699: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `r` | Dashboard-action: Recent Files | @<Lua 691: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `t` | Dashboard-action: Terminal | @<Lua 697: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |
| n | `º` | Dashboard-action: Projects | @<Lua 695: ~/.local/share/nvim/lazy/dashboard-nvim/lua/da... |

## Diagnostics

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>dF` | Generate file documentation | <Lua 159: ~/.config/nvim/lua/plugins/neogen.lua:36> |
| n | `<Space>dt` | Toggle inline diagnostics | <Lua 726: ~/.config/nvim/lua/plugins/tiny-inline-diagnost... |
| n | `<Space>dc` | Generate class documentation | <Lua 255: ~/.config/nvim/lua/plugins/neogen.lua:30> |
| n | `<Space>df` | Generate function documentation | <Lua 260: ~/.config/nvim/lua/plugins/neogen.lua:27> |
| n | `<Space>fd` | Find diagnostics | <Lua 176: ~/.local/share/nvim/lazy/telescope.nvim/lua/tel... |
| n | `<Space>db` |  | :Dashboard<CR> |
| n | `,dg` | Toggle diagnostics | <Lua 258: ~/.config/nvim/lua/plugins/lsp.lua:27> |
| n | `[D` | Jump to the first diagnostic in the current buffer | <Lua 32: vim/_defaults.lua:0> |
| n | `[d` | Jump to the previous diagnostic in the current buffer | <Lua 30: vim/_defaults.lua:0> |
| n | `]D` | Jump to the last diagnostic in the current buffer | <Lua 31: vim/_defaults.lua:0> |
| n | `]d` | Jump to the next diagnostic in the current buffer | <Lua 29: vim/_defaults.lua:0> |
| n | `<C-W><C-D>` | Show diagnostics under the cursor | <C-W>d |
| n | `<C-W>d` | Show diagnostics under the cursor | <Lua 33: vim/_defaults.lua:0> |

## File Explorer (nvim-tree)

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>tc` | Toggle Treesitter Context | <Lua 623: ~/.config/nvim/lua/plugins/ts-context.lua:24> |

## Git

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>gf` | Format buffer | <Lua 250: /opt/homebrew/Cellar/neovim/0.11.5/share/nvim/r... |

## LSP (Language Server)

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>lo` |  | :OpenPDF<CR> |
| n | `<Space>ll` | Toggle lualine | <Lua 12: ~/.config/nvim/lua/plugins/lualine.lua:12> |

## Leap (Motion)

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| o | `<Plug>(leap-backward-till)` |  | <Lua 200: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-backward-till)` |  | <Lua 199: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-backward-till)` |  | <Lua 198: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap-forward-till)` |  | <Lua 197: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-forward-till)` |  | <Lua 196: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-forward-till)` |  | <Lua 195: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap-backward)` |  | <Lua 194: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-backward)` |  | <Lua 193: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-backward)` |  | <Lua 192: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap-forward)` |  | <Lua 191: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-forward)` |  | <Lua 190: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-forward)` |  | <Lua 189: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap-anywhere)` |  | <Lua 188: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-anywhere)` |  | <Lua 168: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-anywhere)` |  | <Lua 166: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap-from-window)` |  | <Lua 164: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap-from-window)` |  | <Lua 162: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap-from-window)` |  | <Lua 161: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| o | `<Plug>(leap)` |  | <Lua 160: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| x | `<Plug>(leap)` |  | <Lua 157: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |
| n | `<Plug>(leap)` |  | <Lua 156: ~/.local/share/nvim/lazy/leap.nvim/plugin/init.... |

## Mini.nvim Plugins

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<M-k>` |  | <Lua 93: ~/.config/nvim/lua/plugins/mini_move.lua:10> |
| n | `<M-j>` |  | <Lua 92: ~/.config/nvim/lua/plugins/mini_move.lua:9> |
| n | `<M-l>` |  | <Lua 137: ~/.config/nvim/lua/plugins/mini_move.lua:12> |
| n | `<M-h>` |  | <Lua 115: ~/.config/nvim/lua/plugins/mini_move.lua:11> |
| v | `<M-k>` |  | <Lua 140: ~/.config/nvim/lua/plugins/mini_move.lua:15> |
| v | `<M-j>` |  | <Lua 138: ~/.config/nvim/lua/plugins/mini_move.lua:14> |
| v | `<M-l>` |  | <Lua 143: ~/.config/nvim/lua/plugins/mini_move.lua:17> |
| v | `<M-h>` |  | <Lua 141: ~/.config/nvim/lua/plugins/mini_move.lua:16> |

## Other

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| o | `%` |  | <Plug>(MatchitOperationForward) |
| x | `%` |  | <Plug>(MatchitVisualForward) |
| n | `%` |  | <Plug>(MatchitNormalForward) |
| o | `[%` |  | <Plug>(MatchitOperationMultiBackward) |
| x | `[%` |  | <Plug>(MatchitVisualMultiBackward) |
| n | `[%` |  | <Plug>(MatchitNormalMultiBackward) |
| o | `]%` |  | <Plug>(MatchitOperationMultiForward) |
| x | `]%` |  | <Plug>(MatchitVisualMultiForward) |
| n | `]%` |  | <Plug>(MatchitNormalMultiForward) |
| x | `a%` |  | <Plug>(MatchitVisualTextObject) |
| o | `g%` |  | <Plug>(MatchitOperationBackward) |
| x | `g%` |  | <Plug>(MatchitVisualBackward) |
| n | `g%` |  | <Plug>(MatchitNormalBackward) |
| x | `<Plug>(MatchitVisualTextObject)` |  | <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMu... |
| o | `<Plug>(MatchitOperationMultiForward)` |  | :<C-U>call matchit#MultiMatch("W",  "o")<CR> |
| o | `<Plug>(MatchitOperationMultiBackward)` |  | :<C-U>call matchit#MultiMatch("bW", "o")<CR> |
| x | `<Plug>(MatchitVisualMultiForward)` |  | :<C-U>call matchit#MultiMatch("W",  "n")<CR>m'gv`` |
| x | `<Plug>(MatchitVisualMultiBackward)` |  | :<C-U>call matchit#MultiMatch("bW", "n")<CR>m'gv`` |
| n | `<Plug>(MatchitNormalMultiForward)` |  | :<C-U>call matchit#MultiMatch("W",  "n")<CR> |
| n | `<Plug>(MatchitNormalMultiBackward)` |  | :<C-U>call matchit#MultiMatch("bW", "n")<CR> |
| o | `<Plug>(MatchitOperationBackward)` |  | :<C-U>call matchit#Match_wrapper('',0,'o')<CR> |
| o | `<Plug>(MatchitOperationForward)` |  | :<C-U>call matchit#Match_wrapper('',1,'o')<CR> |
| x | `<Plug>(MatchitVisualBackward)` |  | :<C-U>call matchit#Match_wrapper('',0,'v')<CR>m'gv`` |
| x | `<Plug>(MatchitVisualForward)` |  | :<C-U>call matchit#Match_wrapper('',1,'v')<CR>:if col("''... |
| n | `<Plug>(MatchitNormalBackward)` |  | :<C-U>call matchit#Match_wrapper('',0,'n')<CR> |
| n | `<Plug>(MatchitNormalForward)` |  | :<C-U>call matchit#Match_wrapper('',1,'n')<CR> |
| s | `<Plug>luasnip-jump-prev` | LuaSnip: Jump to the previous node | <Lua 513: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| s | `<Plug>luasnip-jump-next` | LuaSnip: Jump to the next node | <Lua 512: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| s | `<Plug>luasnip-prev-choice` | LuaSnip: Change to the previous choice from the choiceNode | <Lua 511: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| s | `<Plug>luasnip-next-choice` | LuaSnip: Change to the next choice from the choiceNode | <Lua 510: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| s | `<Plug>luasnip-expand-snippet` | LuaSnip: Expand the current snippet | <Lua 509: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| s | `<Plug>luasnip-expand-or-jump` | LuaSnip: Expand or jump in the current snippet | <Lua 508: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |
| n | `<Plug>luasnip-delete-check` | LuaSnip: Removes current snippet from jumplist | <Lua 504: ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip... |

## Plenary

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Plug>PlenaryTestFile` |  | :lua require('plenary.test_harness').test_file(vim.fn.exp... |

## Surround

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>S` |  | ys$ |
| n | `<Space>s` |  | ysiw |

## Vim Defaults

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| x | `#` | :help v_#-default | <Lua 9: vim/_defaults.lua:0> |
| n | `&` | :help &-default | :&&<CR> |
| x | `*` | :help v_star-default | <Lua 4: vim/_defaults.lua:0> |
| x | `@` | :help v_@-default | mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>' : '@' |
| x | `Q` | :help v_Q-default | mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>'... |
| n | `Y` | :help Y-default | y$ |
| n | `[<Space>` | Add empty line above cursor | <Lua 60: vim/_defaults.lua:0> |
| n | `[B` | :brewind | <Lua 58: vim/_defaults.lua:0> |
| n | `[b` | :bprevious | <Lua 56: vim/_defaults.lua:0> |
| n | `[<C-T>` | :ptprevious | <Lua 54: vim/_defaults.lua:0> |
| n | `[T` | :trewind | <Lua 52: vim/_defaults.lua:0> |
| n | `[t` | :tprevious | <Lua 50: vim/_defaults.lua:0> |
| n | `[A` | :rewind | <Lua 48: vim/_defaults.lua:0> |
| n | `[a` | :previous | <Lua 46: vim/_defaults.lua:0> |
| n | `[<C-L>` | :lpfile | <Lua 44: vim/_defaults.lua:0> |
| n | `[L` | :lrewind | <Lua 42: vim/_defaults.lua:0> |
| n | `[l` | :lprevious | <Lua 40: vim/_defaults.lua:0> |
| n | `[<C-Q>` | :cpfile | <Lua 38: vim/_defaults.lua:0> |
| n | `[Q` | :crewind | <Lua 36: vim/_defaults.lua:0> |
| n | `[q` | :cprevious | <Lua 34: vim/_defaults.lua:0> |
| n | `]<Space>` | Add empty line below cursor | <Lua 61: vim/_defaults.lua:0> |
| n | `]B` | :blast | <Lua 59: vim/_defaults.lua:0> |
| n | `]b` | :bnext | <Lua 57: vim/_defaults.lua:0> |
| n | `]<C-T>` | :ptnext | <Lua 55: vim/_defaults.lua:0> |
| n | `]T` | :tlast | <Lua 53: vim/_defaults.lua:0> |
| n | `]t` | :tnext | <Lua 51: vim/_defaults.lua:0> |
| n | `]A` | :last | <Lua 49: vim/_defaults.lua:0> |
| n | `]a` | :next | <Lua 47: vim/_defaults.lua:0> |
| n | `]<C-L>` | :lnfile | <Lua 45: vim/_defaults.lua:0> |
| n | `]L` | :llast | <Lua 43: vim/_defaults.lua:0> |
| n | `]l` | :lnext | <Lua 41: vim/_defaults.lua:0> |
| n | `]<C-Q>` | :cnfile | <Lua 39: vim/_defaults.lua:0> |
| n | `]Q` | :clast | <Lua 37: vim/_defaults.lua:0> |
| n | `]q` | :cnext | <Lua 35: vim/_defaults.lua:0> |
| n | `gO` | vim.lsp.buf.document_symbol() | <Lua 22: vim/_defaults.lua:0> |
| n | `grt` | vim.lsp.buf.type_definition() | <Lua 21: vim/_defaults.lua:0> |
| n | `gri` | vim.lsp.buf.implementation() | <Lua 20: vim/_defaults.lua:0> |
| n | `grr` | vim.lsp.buf.references() | <Lua 19: vim/_defaults.lua:0> |
| x | `gra` | vim.lsp.buf.code_action() | <Lua 18: vim/_defaults.lua:0> |
| n | `gra` | vim.lsp.buf.code_action() | <Lua 17: vim/_defaults.lua:0> |
| n | `grn` | vim.lsp.buf.rename() | <Lua 16: vim/_defaults.lua:0> |
| x | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | <Lua 11: vim/_defaults.lua:0> |
| n | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | <Lua 10: vim/_defaults.lua:0> |
| s | `<C-S>` | vim.lsp.buf.signature_help() | <Lua 24: vim/_defaults.lua:0> |
| n | `<C-L>` | :help CTRL-L-default | <Cmd>nohlsearch\|diffupdate\|normal! <C-L><CR> |

## Window Management

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| n | `<Space>w=` | Balance windows | <C-W>= |
| n | `<Space>wl` | Move to right window | <Lua 372: ~/.config/nvim/lua/plugins/window_manager.lua:50> |
| n | `<Space>wk` | Move to up window | <Lua 371: ~/.config/nvim/lua/plugins/window_manager.lua:50> |
| n | `<Space>wj` | Move to down window | <Lua 370: ~/.config/nvim/lua/plugins/window_manager.lua:50> |
| n | `<Space>wh` | Move to left window | <Lua 341: ~/.config/nvim/lua/plugins/window_manager.lua:50> |

## Yank Management

| Mode | Key | Description | Mapping |
|------|-----|-------------|---------|
| v | `D` | Delete to end without yanking | "_D |
| n | `D` | Delete to end without yanking | "_D |
| n | `S` | Substitute line without yanking | "_cc |
| v | `d` | Delete without yanking | "_d |
| n | `d` | Delete without yanking | "_d |
| v | `x` | Delete character without yanking | "_x |
| n | `x` | Delete character without yanking | "_x |
