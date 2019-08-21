# vim-crystalline

[![Build Status](https://travis-ci.org/rbong/vim-crystalline.svg?branch=master)](https://travis-ci.org/rbong/vim-crystalline)

Want a nice statusline in vim?
[vim-airline](https://github.com/vim-airline/vim-airline/) too [slow](https://github.com/rbong/vim-crystalline/wiki/Performance-Comparison)?
[lightline.vim](https://github.com/itchyny/lightline.vim/) too [verbose](https://github.com/rbong/vim-crystalline/wiki/Configuration-Comparison)?
`vim-crystalline` is for you.

`vim-crystalline` lets you build your own statusline and tabline in a vanilla vim style.
It also comes with a bufferline!

## Obligatory Colorful Theme Screenshots

**default**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/default.png)

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

**jellybeans**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/jellybeans.png)

**molokai**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/molokai.png)

**onedark**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/onedark.png)

**papercolor**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/papercolor_light.png)

**solarized (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_dark.png)

**solarized (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_light.png)

**Making your own theme**

To make your own theme, see `:help crystalline-themes`.
If you'd like to port an airline theme, see [Porting Airline Themes](https://github.com/rbong/vim-crystalline/wiki/Porting-Airline-Themes) on the wiki.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug), put this in your `.vimrc` between `plug#begin()` and `plug#end()`:

```vim
Plug 'rbong/vim-crystalline'
```

Now run `:PlugInstall` after restarting vim.
Refer to your plugin manager of choice's documentation if you don't use `vim-plug`.

The default version of `vim-crystalline` requires Vim 8.
To install on Vim 7, please see [this thread](https://github.com/rbong/vim-crystalline/issues/12).

## Examples

Jump straight to the last example if you just want to see everything crystalline can do.
All examples go in your `.vimrc` before `vim-crystalline` is loaded.

See `:help statusline` for more information on the statusline syntax used in these examples.

### Basic Vim Syntax

```vim
function! StatusLine()
  return ' %f%h%w%m%r '
endfunction
set statusline=%!StatusLine()
set laststatus=2
```

### Statusline Mode Colors

```vim
function! StatusLine(...)
  return crystalline#mode() . ' %f%h%w%m%r '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Hiding Sections In Inactive Windows

```vim
function! StatusLine(current)
  return ' %f%h%w%m%r '
        \ . (a:current ? '%= %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P ' : '')
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
set laststatus=2
```

### Using Themes

```vim
function! StatusLine(...)
  return '%#Crystalline# %f%h%w%m%r %#CrystallineFill#'
        \ . '%=%#Crystalline# %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Adding More Statusline Information

```vim
function! StatusLine(...)
  return ' %f%h%w%m%r %{fugitive#head()} %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
set laststatus=2
```

### Hiding Sections Based on Window Width

```vim
function! StatusLine(current, width)
  return ' %f%h%w%m%r '
        \ . (a:width > 80 ? '%= %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P ' : '')
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
set laststatus=2
```

### Adding Powerline-Style Separators Between Sections

```vim
function! StatusLine(...)
  return crystalline#mode() . crystalline#right_mode_sep('')
        \ . ' %f%h%w%m%r ' . crystalline#right_sep('', 'Fill') . '%='
        \ . crystalline#left_sep('', 'Fill') . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction
let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

The strings passed to separator functions are groups from `:help crystalline-highlight-groups` with `Crystalline` omitted.

### Using the Bufferline

```vim
set tabline=%!crystalline#bufferline()
set showtabline=2
```

### Enabling the Bufferline in Gvim

```vim
set tabline=%!crystalline#bufferline()
set showtabline=2
set guioptions-=e
```

### Bufferline Current Tab Mode Colors

```vim
function! TabLine()
  return crystalline#bufferline(0, 0, 1)
endfunction
let g:crystalline_tabline_fn = 'TabLine'
set showtabline=2
```

### Adding More Tabline Information

```vim
function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction
let g:crystalline_tabline_fn = 'TabLine'
set showtabline=2
```

The first two options to the bufferline indicate the number of `%` items used and the character width used.

### Full Example

```vim
function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  if a:current
    let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'default'

set showtabline=2
set guioptions-=e
set laststatus=2
```

## More Info

See `:help crystalline` for more information.

Don't hesitate to [post an issue](https://github.com/rbong/vim-crystalline/issues/new) if you have any questions, suggestions, or bugs.

Feel free to [make a pull request](https://github.com/rbong/vim-crystalline/pulls) if you'd like to to contribute.
It's much appreciated.
