# vim-crystalline

[![test status](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml)

Want a nice statusline in Vim?
Other statusline plugins too [slow](https://github.com/rbong/vim-crystalline/wiki/Performance-Comparison)
and [uncustomizable](https://github.com/rbong/vim-crystalline/wiki/Configuration-Comparison)?
`vim-crystalline` is for you.

`vim-crystalline` lets you build your own statusline and tabline in a vanilla Vim style.

## Obligatory Colorful Theme Screenshots

**default**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/default.png)

**ayu (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/ayu_dark.png)

**ayu (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/ayu_light.png)

**badwolf**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/badwolf.png)

**dracula**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/dracula.png)

**gruvbox (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/gruvbox_dark.png)

**gruvbox (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/gruvbox_light.png)

**hybrid (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/hybrid_dark.png)

**hybrid (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/hybrid_light.png)

**iceberg (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/iceberg_dark.png)

**iceberg (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/iceberg_light.png)

**jellybeans**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/jellybeans.png)

**molokai**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/molokai.png)

**nord**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/nord.png)

**onedark**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/onedark.png)

**onehalfdark**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/onehalfdark.png)

**onehalflight**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/onehalflight.png)

**papercolor**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/papercolor.png)

**shadesofpurple**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/shadesofpurple.png)

**solarized (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_dark.png)

**solarized (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_light.png)

**Making your own theme**

See also [`:help crystalline-creating-themes`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt)
and [Porting Airline Themes](https://github.com/rbong/vim-crystalline/wiki/Porting-Airline-Themes).

## Installation

### Installation with [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()
Plug 'rbong/vim-crystalline'
call plug#end()
```

Run `:PlugInstall` after restarting vim.

### Installation with [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
require("packer").startup(function(use)
  use("rbong/vim-crystalline")
end)
```

Run `:PackerInstall` after restarting neovim.

## Examples

These examples use vimscript.
Examples are also available in [neovim-flavored Lua](examples/neovim_lua_examples.md).

All examples belong in `.vimrc` before `vim-crystalline` is loaded.

### Creating a Basic Statusline

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " Add file name and modification status
  let l:s .= ' %f%h%w%m%r '

  " Start the right side of the statusline
  let l:s .= '%='

  " Add file type and position info
  let l:s .= '%{&ft} %l/%L %2v '

  return l:s
endfunction

" Always show the statusline
set laststatus=2
```

See [`:help 'statusline'`](https://vimhelp.org/options.txt.html#%27statusline%27) for more info.

### Creating a Basic Tabline

```vim
function! g:CrystallineTablineFn()
  return crystalline#DefaultTabline()
endfunction

" Always show the tabline
set showtabline=2
" Show the tabline in gvim
set guioptions-=e
```

See [`:help 'tabline'`](https://vimhelp.org/options.txt.html#%27statusline%27) for more info.

### Hiding Sections

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  let l:s .= ' %f%h%w%m%r '

  let l:s .= '%='

  " Only add this section in active windows
  if a:winnr == winnr()
    let l:s .= '%{&ft} '
  endif
  " Only add this section in wide enough windows
  if winwidth(a:winnr) >= 80
    let l:s .= '%l/%L %2v '
  endif

  return l:s
endfunction

set laststatus=2
```

### Using Highlight Groups

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  if a:winnr == winnr()
    " Start highlighting section A
    let l:s .= crystalline#HiItem('A')
  else
    " Start highlighting Fill section for inactive windows
    let l:s .= crystalline#HiItem('InactiveFill')
  endif

  let l:s .= ' %f%h%w%m%r '

  return l:s
endfunction

set laststatus=2
" Default theme
let g:crystalline_theme = 'default'
```

See [`:help crystalline-highlight-groups`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt)
for the full list of groups.

See [screenshots](#obligatory-colorful-theme-screenshots)
for the full list of themes.

### Using Separators

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  let l:s .= crystalline#HiItem('A')

  let l:s .= ' %f%h%w%m%r '

  " Add separator 0 between section A and the statusline fill section
  let l:s .= crystalline#Sep(0, 'A', 'Fill')

  let l:s .= '%='

  " Add separator 1 between the fill section and section A
  let l:s .= crystalline#Sep(1, 'Fill', 'A')

  let l:s .= '%{&ft} %l/%L %2v '

  return l:s
endfunction

function! g:CrystallineTablineFn()
  " Add separators to the tabline
  return crystalline#DefaultTabline({ 'enable_sep': 1 })
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
" By default, these are powerline-style separators
let g:crystalline_separators = [
      \ { 'ch': '>', 'alt_ch': '|', 'dir': '>' },
      \ { 'ch': '<', 'alt_ch': '|', 'dir': '<' },
      \ ]
```

### Using Mode Colors

Using mode colors manually:

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " In different modes, this will be 'NormalModeA', 'InsertModeA', etc.
  let l:s .= crystalline#ModeHiItem('A')

  let l:s .= ' %f%h%w%m%r '

  " The mode prefix is added to all separator groups
  let l:s .= crystalline#Sep(0, crystalline#ModeGroup('A'), crystalline#ModeGroup('Fill'))

  return l:s
endfunction

function! g:CrystallineTablineFn()
  " auto_prefix_groups automatically uses mode colors
  return crystalline#DefaultTabline({ 'auto_prefix_groups': 1 })
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
```

Using mode colors automatically:

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " In different modes, this will be 'NormalModeA', 'InsertModeA', etc.
  " In inactive windows, this will be 'InactiveA'
  let l:s .= crystalline#HiItem('A')

  let l:s .= ' %f%h%w%m%r '

  " The prefix will automatically be added to separator groups
  let l:s .= crystalline#Sep(0, 'A', 'Fill')

  return l:s
endfunction

function! g:CrystallineTablineFn()
  " auto_prefix_groups will default to true
  " 'Inactive*' groups will not be used in the tabline
  return crystalline#DefaultTabline()
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
" This enables auto mode/inactive colors
" All functions work with this option
let g:crystalline_auto_prefix_groups = 1
```

Add a mode section:

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " Automatically create a mode highlight group, mode label, and separator
  " Same arguments as crystalline#Sep()
  let l:s .= crystalline#ModeSection(0, 'A', 'B')

  let l:s .= ' %f%h%w%m%r '

  let l:s .= crystalline#Sep(0, 'B', 'Fill')

  return l:s
endfunction

set laststatus=2
```

### Using Color Variants

Using color variants manually:

```vim
function! g:GroupSuffix()
  if mode() ==# 'i' && &paste
    " Add the suffix '2' to all groups
    return '2'
  endif
  if &modified
    " Add the suffix '1' to all groups
    return '1'
  endif
  " Don't add any suffix
  return ''
endfunction

function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " Add the variant onto the end of the highlight item
  let l:s .= crystalline#HiItem('Fill' . g:GroupSuffix())

  let l:s .= ' %f%h%w%m%r '

  return l:s
endfunction

function! g:CrystallineTablineFn()
  " Add the variant onto the end of all tabline groups
  return crystalline#DefaultTabline({ 'group_suffix': g:GroupSuffix() })
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
let g:crystalline_auto_prefix_groups = 1
```

Using color variants automatically:

```vim
function! g:GroupSuffix()
  if mode() ==# 'i' && &paste
    return '2'
  endif
  if &modified
    return '1'
  endif
  return ''
endfunction

function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " Automatically add the suffix onto the end of all groups
  " Works with all functions
  let g:crystalline_group_suffix = g:GroupSuffix()

  let l:s .= crystalline#HiItem('Fill')

  let l:s .= ' %f%h%w%m%r '

  return l:s
endfunction

function! g:CrystallineTablineFn()
  let g:crystalline_group_suffix = g:GroupSuffix()
  return crystalline#DefaultTabline()
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
let g:crystalline_auto_prefix_groups = 1
```

There are 2 variants to use in built-in themes.

### Showing More Statusline Information

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  let l:s .= ' %f%h%w%m%r '

  " Add the current branch from vim-fugitive
  " Plugins often provide functions for the statusline
  let l:s .= '%{fugitive#Head()} '

  let l:s .= '%='

  " Show settings in the statusline
  let l:s .= '%{&paste ? "PASTE " : " "}'

  return l:s
endfunction

set laststatus=2
```

### Showing More Tabline Information

```vim
function! g:CrystallineTablineFn()
  let l:max_width = &columns
  " Start the right side of the tabline
  let l:right = '%='

  " Add a separator
  " Reuse the TabType group for the right section
  let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
  " Subtract the width of the separator
  let l:max_width -= 1

  " Add a label indicating if vim or neovim is being used
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  let l:right .= l:vimlabel
  " Use strchars() to get the real visible width
  let l:max_width -= strchars(l:vimlabel)

  " Reduce the number of max tabs to fit new tabline items
  let l:max_tabs = 23

  return crystalline#DefaultTabline({ 'max_tabs': l:max_tabs, 'max_width': l:max_width }) . l:right
endfunction

set showtabline=2
set guioptions-=e
```

### Full Example

```vim
function! g:GroupSuffix()
  if mode() ==# 'i' && &paste
    return '2'
  endif
  if &modified
    return '1'
  endif
  return ''
endfunction

function! g:CrystallineStatuslineFn(winnr)
  let g:crystalline_group_suffix = g:GroupSuffix()
  let l:curr = a:winnr == winnr()
  let l:s = ''

  if l:curr
    let l:s .= crystalline#ModeSection(0, 'A', 'B')
  else
    let l:s .= crystalline#HiItem('Fill')
  endif
  let l:s .= ' %f%h%w%m%r '
  if l:curr
    let l:s .= crystalline#Sep(0, 'B', 'Fill') . ' %{fugitive#Head()}'
  endif

  let l:s .= '%='
  if l:curr
    let l:s .= crystalline#Sep(1, 'Fill', 'B') . '%{&paste ? " PASTE " : " "}'
    let l:s .= crystalline#Sep(1, 'B', 'A')
  endif
  if winwidth(a:winnr) > 80
    let l:s .= ' %{&ft} %l/%L %2v '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! g:CrystallineTablineFn()
  let l:max_width = &columns
  let l:right = '%='

  let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
  let l:max_width -= 1

  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  let l:right .= l:vimlabel
  let l:max_width -= strchars(l:vimlabel)

  let l:max_tabs = 23

  return crystalline#DefaultTabline({
        \ 'enable_sep': 1,
        \ 'max_tabs': l:max_tabs,
        \ 'max_width': l:max_width
        \ }) . l:right
endfunction

set showtabline=2
set guioptions-=e
set laststatus=2
let g:crystalline_auto_prefix_groups = 1
```

## More Info

See [`:help crystalline`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt) for more information.

Don't hesitate to [start a discussion](https://github.com/rbong/vim-crystalline/discussions/new/choose) if you have any questions or suggestions
or [post an issue](https://github.com/rbong/vim-crystalline/issues/new) if you encounter any bugs.

Feel free to [make a pull request](https://github.com/rbong/vim-crystalline/pulls) if you'd like to to contribute.
It's much appreciated.
