# vim-crystalline

[![test status](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml)

Want a nice statusline in Vim?
Other statuslines too [slow](https://github.com/rbong/vim-crystalline/wiki/Performance-Comparison)
and [verbose](https://github.com/rbong/vim-crystalline/wiki/Configuration-Comparison)?
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

**hybrid**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/hybrid.png)

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

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/papercolor_light.png)

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

More examples are availabe in [vimscript](examples/vimscript_examples.md)
and [neovim-flavored Lua](examples/neovim_lua_examples.md).

Fully featured example:

```vim
function! g:GroupSuffix()
  if &paste
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
    let l:s .= crystalline#mode_section(0, 'A', 'B')
  else
    let l:s .= crystalline#hi_item('InactiveFill')
  endif
  let l:s .= ' %f%h%w%m%r '
  if l:curr
    let l:s .= crystalline#sep(0, 'B', 'Fill') . ' %{fugitive#Head()}'
  endif

  let l:s .= '%='
  if l:curr
    let l:s .= crystalline#sep(1, 'Fill', 'B') . &paste ? 'PASTE ' : ' '
    let l:s .= crystalline#sep(1, 'B', 'A')
  endif
  if winwidth(a:winnr) > 80
    let l:s .= ' %{&ft} %l/%L %2v '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! g:CrystallineTablineFn()
  let g:crystalline_group_suffix = g:GroupSuffix()
  let l:max_items = 80
  let l:max_width = &columns

  let l:right = '%='
  let l:max_items -= 1

  let l:right .= crystalline#sep(1, 'TabFill', 'TabType')
  let l:max_items -= 2
  let l:max_width -= 1

  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  let l:max_width -= strchars(l:vimlabel)

  return crystalline#default_tabline({
        \ 'enable_sep': 1, 'max_items': l:max_items, 'max_width': l:max_width
        \ }) . l:right
endfunction

set showtabline=2
set guioptions-=e
set laststatus=2
let g:crystalline_auto_prefix_mode_group = 1
```

## More Info

See [`:help crystalline`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt) for more information.

Don't hesitate to [post an issue](https://github.com/rbong/vim-crystalline/issues/new) if you have any questions, suggestions, or bugs.

Feel free to [make a pull request](https://github.com/rbong/vim-crystalline/pulls) if you'd like to to contribute.
It's much appreciated.
