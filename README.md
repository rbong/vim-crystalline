# vim-crystalline

[![Build Status](https://travis-ci.org/rbong/vim-crystalline.svg?branch=master)](https://travis-ci.org/rbong/vim-crystalline)

Want a nice statusline in vim?
[vim-airline](https://github.com/vim-airline/vim-airline/) too slow?
[lightline.vim](https://github.com/itchyny/lightline.vim/) too verbose?
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

**papercolor (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/papercolor_light.png)

**solarized (dark)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_dark.png)

**solarized (light)**

![img](https://github.com/rbong/vim-crystalline/wiki/screenshots/solarized_light.png)

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug), put this in your `.vimrc` between `plug#begin()` and `plug#end()`:

```vim
Plug('rbong/vim-crystalline')
```

Now run `:PlugInstall` after restarting vim.
Refer to your plugin manager of choice's documentation if you don't use `vim-plug`.

## Examples

Jump straight to the last example if you just want to see everything crystalline can do.
All examples go in your `.vimrc` before `vim-crystalline` is loaded.
See `:help statusline` for a information on the statusline syntax used in these examples.

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

This will add a colored mode section to the statusline.

### Hiding Sections When Inactive

```vim
function! StatusLine(current)
  return (a:current ? crystalline#mode() : '') . ' %f%h%w%m%r '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Using Themes

```vim
function! StatusLine(current)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CystallineInactive#') . ' %f%h%w%m%r '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

See `:help crystalline-highlight-groups` for a full list of highlight groups and information on creating themes.

### Adding More Statusline Information

```vim
function! StatusLine(current)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
        \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
        \ . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Hiding Sections Based on Window Width

```vim
function! StatusLine(current, width)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
        \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
        \ . (a:width > 80 ? ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P ' : ' ')
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Adding Separators

```vim
function! StatusLine(current)
  return (a:current ? crystalline#mode() . crystalline#right_mode_sep('') : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}' : '')
        \ . '%=' . (a:current ? crystalline#left_sep('', 'Fill') . ' %{&spell?"SPELL ":""}' . crystalline#left_mode_sep('') : '')
        \ . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction
let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2
```

### Using the Bufferline

```vim
set tabline=%!crystalline#bufferline(0, 0, 0)
set showtabline=2
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
  let l:vimlabel = has("nvim") ?  " NVIM " : " VIM "
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction
let g:crystalline_tabline_fn = 'TabLine'
set showtabline=2
```

### Full Example

```vim
function! StatusLine(current)
  return (a:current ? crystalline#mode() . crystalline#right_mode_sep('') : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}' : '')
        \ . '%=' . (a:current ? crystalline#left_sep('', 'Fill') . ' %{&spell?"SPELL ":""}' . crystalline#left_mode_sep('') : '')
        \ . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction

function! TabLine()
  let l:vimlabel = has("nvim") ?  " NVIM " : " VIM "
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'default'

set showtabline=2
set laststatus=2
```

The statusline has default info, mode-based colors, the current git branch, width and inactivity based hiding, settings, and powerline-style separators.

## More Info

See `:help crystalline` for more information.

Don't hesitate to [post an issue](https://github.com/rbong/vim-crystalline/issues/new) if you have any questions, suggestions, or bugs.

For a performance comparison with other statusline plugins, see [the Performance Comparison page on the wiki](https://github.com/rbong/vim-crystalline/wiki/Performance-Comparison).

To port a theme from airline, see [Porting Airline Themes](https://github.com/rbong/vim-crystalline/wiki/Porting-Airline-Themes).

Feel free to [make a pull request](https://github.com/rbong/vim-crystalline/pulls) if you'd like to to contribute.
It's much appreciated.
