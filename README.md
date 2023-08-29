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

Using [vim-plug](https://github.com/junegunn/vim-plug), put this in your `.vimrc` between `plug#begin()` and `plug#end()`:

```vim
Plug 'rbong/vim-crystalline'
```

Then, run `:PlugInstall` after restarting vim.

If you don't use `vim-plug` refer to your plugin manager of choice.

## Examples

All examples belong in `.vimrc` before `vim-crystalline` is loaded.

### Create a Basic Vim Statusline

```vim
function! g:CrystallineStatuslineFn(winnr)
  return ' %f%h%w%m%r '
endfunction
set laststatus=2
```

See [`:help 'statusline'`](https://vimhelp.org/options.txt.html#%27statusline%27)
and [`:help 'laststatus'`](https://vimhelp.org/options.txt.html#%27laststatus%27) for more information.

### Add Mode Colors to the Statusline

```vim
function! g:CrystallineStatuslineFn(winnr)
  return crystalline#mode_hi_item('A') . crystalline#mode_label() . '%f%h%w%m%r '
endfunction
let g:crystalline_theme = 'default'
set laststatus=2
```

### Hide Sections in Inactive Windows

```vim
function! g:CrystallineStatuslineFn(winnr)
  return ' %f%h%w%m%r '
        \ . (a:winnr == winnr() ? '%= %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : '')
endfunction
set laststatus=2
```

### Use Crystalline Themes

```vim
function! g:CrystallineStatuslineFn(winnr)
  return crystalline#hi_item('A') . ' %f%h%w%m%r ' . crystalline#hi_item('Fill') . '%='
        \ . crystalline#hi_item('A') . ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction
let g:crystalline_theme = 'default'
set laststatus=2
```

### Add More Statusline Information

```vim
function! g:CrystallineStatuslineFn(winnr)
  return ' %f%h%w%m%r %{fugitive#Head()} %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
endfunction
set laststatus=2
```

### Hide Sections Based on Window Width

```vim
function! g:CrystallineStatuslineFn(winnr)
  return ' %f%h%w%m%r '
        \ . (winwidth(a:winnr) > 80 ? '%= %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : '')
endfunction
set laststatus=2
```

### Add Powerline-Style Separators Between Sections

```vim
function! g:CrystallineStatuslineFn(winnr)
  return crystalline#hi_item('A') . ' %f%h%w%m%r '
        \ . crystalline#sep(0, 'B', 'Fill') . '%='
        \ . crystalline#sep(1, 'Fill', 'B') . ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction
" Example: default separators
let g:crystalline_separators = [
      \ { 'ch': '', 'alt_ch': '', 'dir': '>' },
      \ { 'ch': '', 'alt_ch': '', 'dir': '<' },
      \ ]
let g:crystalline_theme = 'default'
set laststatus=2
```

### Show More Mode Info

```vim
function! g:CrystallineStatuslineFn(winnr)
  return crystalline#mode_section(0, 'A', 'B') . ' %f%h%w%m%r '
endfunction
let g:crystalline_theme = 'default'
set laststatus=2
```

The mode section will display a colored label for the current mode and a
separator for the next section.

### Use the Default Tabline

```vim
function! g:CrystallineTablineFn()
  return crystalline#default_tabline()
endfunction
set showtabline=2
```

Shows buffers if there is only one tab, otherwise shows tabs.
For more flexible buffers/tabs, see [`:help crystalline#tabs_or_buffers()`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt).

### Enabling the Default Tabline in Gvim

```vim
function! g:CrystallineTablineFn()
  return crystalline#default_tabline()
endfunction
set showtabline=2
set guioptions-=e
```

### Adding More Tabline Information

```vim
function! g:CrystallineTablineFn()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#default_tabline({
        \ 'max_items': 80 - 2,
        \ 'max_width': &columns - strchars(l:vimlabel),
        \ })
        \ . '%=' . crystalline#hi_item('TabType') . ' ' . l:vimlabel
endfunction
set showtabline=2
```

### Full Example

```vim
function! g:CrystallineStatuslineFn(winnr)
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
    let l:s .= crystalline#sep(1, 'Fill', 'B') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#sep(1, 'B', crystalline#mode_group('A'))
  endif
  if winwidth(a:winnr) > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! g:CrystallineTablineFn()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#default_tabline({
        \ 'enable_sep': 1,
        \ 'max_items': 80 - 2,
        \ 'max_width': &columns - strchars(l:vimlabel),
        \ })
        \ . '%=' . crystalline#hi_item('TabType') . ' ' . l:vimlabel
endfunction

let g:crystalline_theme = 'default'

set showtabline=2
set guioptions-=e
set laststatus=2
```

## More Info

See [`:help crystalline`](https://raw.githubusercontent.com/rbong/vim-crystalline/master/doc/crystalline.txt) for more information.

Don't hesitate to [post an issue](https://github.com/rbong/vim-crystalline/issues/new) if you have any questions, suggestions, or bugs.

Feel free to [make a pull request](https://github.com/rbong/vim-crystalline/pulls) if you'd like to to contribute.
It's much appreciated.
