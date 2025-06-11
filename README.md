<div align="center">

  <h1>active-files.nvim</h1>
  <h6>Neovim plugin that allows switching between recently used files — similar to <em>Switcher</em> in JetBrains or <em>Active Files</em> in Visual Studio.</h6>

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim 0.9+](https://img.shields.io/badge/Neovim%200.9+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

</div>

## Table of Contents

- [The problem](#problem)
- [The solution](#solution)
- [Repository structure](#repo)
- [Functionalities](#functionalities)
- [Installation](#installation)
    - [Vim-Plug](#vimplug)
    - [Packer](#packer)
- [Commands](#commands)
- [Setup](#setup)

---

## The problem :warning: <a name="problem"></a>

In modern IDEs like Visual Studio and JetBrains products, there's always a fast way to jump between recently opened files. In Neovim, this often requires fuzzy finders or full buffer lists, which don’t reflect recency in a consistent way and may include irrelevant or closed buffers.

---

## The solution :trophy: <a name="solution"></a>

**active-files.nvim** provides a clean, dedicated UI to quickly access the last N files you've worked on — sorted by recency of usage. With a popup window, non-intrusive indexing, and direct file switching, this gives you a workflow familiar to JetBrains and VS users — but native to Neovim.

[![asciicast](https://asciinema.org/a/tg6c4pkAQnVRslSo4y3D9I3JP.svg)](https://asciinema.org/a/tg6c4pkAQnVRslSo4y3D9I3JP)

---

## Repository structure :open_file_folder: <a name="repo"></a>

```bash
active-files.nvim/
├── LICENSE
├── lua
│   └── active-files
│       ├── commands.lua    # Exposed commands
│       ├── init.lua        # Plugin entry point
│       ├── ui.lua          # UI and switching logic
│       └── util.lua        # Utility helpers
└── README.md
```

---

## Functionalities :pick: <a name="functionalities"></a>

- [x] Automatically tracks most recently opened files
- [x] Floating window UI inspired by JetBrains and Visual Studio
- [x] Only tracks project-local files
- [x] Jump to file by number key (1–9)
- [x] Displays filenames with nice relative paths
- [x] Non-selectable virtual numbers styled like JetBrains "Switcher"
- [ ] Configurable number of active files --planned
- [ ] Configurable active files sorting criteria -- planned

---

## Installation :star: <a name="installation"></a>

Requires **Neovim v0.9+**. No external dependencies required.

### Vim-Plug <a name="vimplug"></a>

```lua
Plug 'jkeresman01/active-files.nvim'
```

### Packer <a name="packer"></a>

```lua
use 'jkeresman01/active-files.nvim'
```

---

## Commands :wrench: <a name="commands"></a>

These are the available user commands:

| Command                | Description                                      |
|------------------------|--------------------------------------------------|
| `:ShowActiveFiles`     | Show floating popup with active files            |
| `:SelectActiveFile`    | Select a file from the floating window (internal)|
| `:SwitchToActiveFile n`| Immediately switch to file at index `n`          |

---

## Setup :hammer_and_wrench: <a name="setup"></a>

Set the keybindings to match your workflow here is one example:

```lua
require("active-files.commands").register()

vim.keymap.set("n", "<C-s>", "<CMD>ShowActiveFiles<CR>", { desc = "Show active files" })

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    vim.cmd("SwitchToActiveFile " .. i)
  end, { noremap = true, silent = true, desc = "Switch to active file " .. i })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "active-files",
  callback = function(args)
    vim.keymap.set("n", "<CR>", "<CMD>SelectActiveFile<CR>", { buffer = args.buf, silent = true })
  end,
})

```
---

| Keybinding      | Mode | Description                                  |
|------------------|------|----------------------------------------------|
| `<C-s>`          | `n`  | Show the active files floating popup         |
| `<leader>1`–`9`  | `n`  | Jump directly to the N-th most recent file   |
| `<CR>`           | `n`  | Inside popup: open the selected file         |
