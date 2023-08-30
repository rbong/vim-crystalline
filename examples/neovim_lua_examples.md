# Neovim Lua Examples

These examples use neovim-flavored Lua.
Examples are also available in [vimscript](examples/vimscript_examples.md).

All examples belong in `init.lua` before `vim-crystalline` is loaded.

## Creating a Basic Statusline

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local s = ""

  -- Add file name and modification status
  s = s .. " %f%h%w%m%r "

  -- Start the right side of the statusline
  s = s .. "%="

  -- Add file type and position info
  s = s .. "%{&ft} %l/%L %2v "

  return s
end

-- Always show the statusline
vim.o.laststatus = 2
```

See [`:help 'statusline'`](https://vimhelp.org/options.txt.html#%27statusline%27) for more info.

## Creating a Basic Tabline

```lua
function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  return cl.DefaultTabline()
end

-- Always show the tabline
vim.o.showtabline = 2
```

See [`:help 'tabline'`](https://vimhelp.org/options.txt.html#%27statusline%27) for more info.

## Hiding Sections

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local s = ""

  s = s .. " %f%h%w%m%r "

  s = s .. "%="

  -- Only add this section in active windows
  if winnr == vim.fn.winnr() then
    s = s .. "%{&ft} "
  end
  -- Only add this section in wide enough windows
  if vim.fn.winwidth(winnr) >= 80 then
    s = s .. "%l/%L %2v "
  end

  return s
end

vim.o.laststatus = 2
```

## Using Highlight Groups

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  if winnr == vim.fn.winnr() then
    -- Start highlighting section A
    s = s .. cl.HiItem("A")
  else
    -- Start highlighting Fill section for inactive windows
    s = s .. cl.HiItem('InactiveFill')
  end

  s = s .. " %f%h%w%m%r "

  return s
end

vim.o.laststatus = 2
-- Default theme
vim.g.crystalline_theme = "default"
```

See [`:help crystalline-highlight-groups`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt)
for the full list of groups.

See [screenshots](README.md#obligatory-colorful-theme-screenshots)
for the full list of themes.

## Using Separators

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  s = s .. cl.HiItem("A")

  s = s .. " %f%h%w%m%r "

  -- Add separator 0 between section A and the statusline fill section
  s = s .. cl.Sep(0, "A", "Fill")

  s = s .. "%="

  -- Add separator 1 between the fill section and section A
  s = s .. cl.Sep(1, "Fill", "A")

  s = s .. "%{&ft} %l/%L %2v "

  return s
end

function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  -- Add separators to the tabline
  return cl.DefaultTabline({ enable_sep = true })
end

vim.o.laststatus = 2
vim.o.showtabline = 2
-- Default separators
vim.g.crystalline_separators = {
  { ch = "", alt_ch = "", dir = ">" },
  { ch = "", alt_ch = "", dir = "<" }
}
```

## Using Mode Colors

TODO: inactive colors example

Using mode colors manually:

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  -- Start highlighting section A with mode colors
  s = s .. cl.ModeHiItem("A")

  s = s .. " %f%h%w%m%r "

  -- Generate a separator with mode colors
  s = s .. cl.Sep(0, cl.ModeGroup("A"), cl.ModeGroup("Fill"))

  return s
end

function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  -- auto_prefix_groups automatically uses mode colors
  return cl.DefaultTabline({ auto_prefix_groups = true })
end

vim.o.laststatus = 2
vim.o.showtabline = 2
```

Using mode colors automatically:

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  -- The mode colors for section A will automatically be added
  s = s .. cl.HiItem("A")

  s = s .. " %f%h%w%m%r "

  -- A separator with mode colors for both groups will automatically be generated
  s = s .. cl.Sep(0, "A", "Fill")

  return s
end

function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  -- auto_prefix_groups will default to true
  return cl.DefaultTabline()
end

vim.o.laststatus = 2
vim.o.showtabline = 2
-- This enables auto mode/inactive colors
-- All functions work with this option
vim.g.crystalline_auto_prefix_groups = true
```

Add a mode section:

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  -- Automatically create a mode highlight group, mode label, and separator
  -- Same arguments as crystalline.sep()
  s = s .. cl.ModeSection(0, "A", "B")

  s = s .. " %f%h%w%m%r "

  s = s .. cl.Sep(0, "B", "Fill")

  return s
end

vim.o.laststatus = 2
```

## Using Color Variants

Using color variants manually:

```lua
local function GroupSuffix()
  if &paste then
    -- Add the suffix "2" to all groups
    return "2"
  end
  if &modified then
    -- Add the suffix "1" to all groups
    return "1"
  end
  -- Don"t add any suffix
  return ""
end

function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  local v = GroupSuffix()

  -- Add the variant onto the end of the highlight item
  s = s .. cl.HiItem("A") .. v

  s = s .. " %f%h%w%m%r "

  return s
end

function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  -- Add the variant onto the end of all tabline groups
  return cl.DefaultTabline({ group_suffix = GroupSuffix() })
end

vim.o.laststatus = 2
vim.o.showtabline = 2
```

Using color variants automatically:

```lua
local function GroupSuffix()
  if &paste then
    return "2"
  end
  if &modified then
    return "1"
  end
  return ""
end

function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  local s = ""

  -- Automatically add the suffix onto the end of all groups
  -- Works with all functions
  vim.g.crystalline_group_suffix = GroupSuffix()

  s = s .. cl.HiItem("A")

  s = s .. " %f%h%w%m%r "

  return s
end

function vim.g.CrystallineTablineFn(winnr)
  local cl = require("crystalline")
  -- group_suffix will default to vim.g.crystalline_group_suffix
  vim.g.crystalline_group_suffix = GroupSuffix()
  return cl.DefaultTabline()
end

vim.o.laststatus = 2
vim.o.showtabline = 2
```

## Showing More Statusline Information

```lua
function vim.g.CrystallineStatuslineFn(winnr)
  local s = ""

  s = s .. " %f%h%w%m%r "

  -- Add the current branch from vim-fugitive
  -- Plugins often provide functions for the statusline
  s = s .. "%{fugitive#Head()} "

  s = s .. "%"

  -- Show settings in the statusline
  s = s .. "${&paste ? "PASTE" : ""} "

  return s
end

vim.o.laststatus = 2
```

## Showing More Tabline Information

```lua
function vim.g.CrystallineTablineFn()
  local cl = require("crystalline")
  -- The maximum supported statusline/tabline items in Vim
  local max_items = 80
  -- The width of the screen
  local max_width = &columns

  -- Start the right side of the tabline
  local right = "%="
  local max_items -= 1

  -- Add a separator
  -- Reuse the TabType group for the right section
  right = right .. cl.Sep(1, "TabFill", "TabType")
  -- One item for the separator group, one item to start the TabType group
  local max_items -= 2
  -- Subtract the width of the separator
  local max_width -= 1

  -- Add a label indicating that neovim is being used
  local vimlabel = " NVIM" 
  -- Use strchars() to get the real visible width
  local max_width -= vim.fn.strchars(vimlabel)

  return cl.DefaultTabline({ max_items = max_items, max_width = max_width }) .. right
end

vim.o.showtabline = 2
```

## Full Example

```lua
local function GroupSuffix()
  if &paste then
    return "2"
  end
  if &modified then
    return "1"
  end
  return ""
end

function vim.g.CrystallineStatuslineFn(winnr)
  local cl = require("crystalline")
  vim.g.crystalline_group_suffix = GroupSuffix()
  local curr = winnr == vim.fn.winnr()
  local s = ""

  if curr then
    s = s .. cl.ModeSection(0, "A", "B")
  else
    s = s .. cl.HiItem("Fill")
  end
  s = s .. " %f%h%w%m%r "
  if curr then
    s = s .. cl.Sep(0, "B", "Fill") .. " %{fugitive#Head()}"
  end

  s = s .. "%="
  if curr then
    s = s .. cl.Sep(1, "Fill", "B") .. &paste ? "PASTE " : " "
    s = s .. cl.Sep(1, "B", "A")
  end
  if vim.fn.winwidth(winnr) > 80 then
    s = s .. " %{&ft} %l/%L %2v "
  else
    s = s .. " "
  end

  return s
end

function vim.g.CrystallineTablineFn()
  local cl = require("crystalline")
  vim.g.crystalline_group_suffix = GroupSuffix()
  local max_items = 80
  local max_width = &columns

  local right = "%="
  local max_items -= 1

  right = right .. cl.Sep(1, "TabFill", "TabType")
  local max_items -= 2
  local max_width -= 1

  local vimlabel = " NVIM "
  local max_width -= vim.fn.strchars(vimlabel)

  return cl.DefaultTabline({
    enable_sep = true, max_items = max_items, max_width = max_width
  }) .. right
end

vim.o.showtabline = 2
vim.o.laststatus = 2
vim.g.crystalline_auto_prefix_groups = 1
```
