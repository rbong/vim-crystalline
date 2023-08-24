# vim-crystalline

[![test status](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/rbong/vim-crystalline/actions/workflows/test.yml)

Want a nice statusline in vim?
[vim-airline](https://github.com/vim-airline/vim-airline/) too [slow](https://github.com/rbong/vim-crystalline/wiki/Performance-Comparison)?
[lightline.vim](https://github.com/itchyny/lightline.vim/) too [verbose](https://github.com/rbong/vim-crystalline/wiki/Configuration-Comparison)?
`vim-crystalline` is for you.

`vim-crystalline` lets you build your own statusline and tabline in a vanilla vim style.

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
To install on `vim-7`, use:

```vim
Plug 'rbong/vim-crystalline', { 'branch': 'vim-7' }
```

## Examples

Jump straight to the last example if you just want to see everything crystalline can do.
All examples go in your `.vimrc` before `vim-crystalline` is loaded.

See `:help statusline` for more information on the statusline syntax used in these examples.

### Basic Vim Syntax

```vim
function! Statusline()
  return ' %f%h%w%m%r '
endfunction
set statusline=%!Statusline()
set laststatus=2
```

### Statusline Mode Colors

```vim
function! g:CrystallineStatuslineFn(ctx)
  return crystalline#mode_color('A') . crystalline#mode_label() . ' %f%h%w%m%r '
endfunction
let g:crystalline_theme = 'default'
set laststatus=2
```

### Hiding Sections In Inactive Windows

```vim
function! g:CrystallineStatuslineFn(ctx)
  return ' %f%h%w%m%r '
        \ . (a:ctx.curr ? '%= %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : 'B')
endfunction
set laststatus=2
```

### Using Themes

```vim
function! g:CrystallineStatuslineFn(ctx)
  return '%#Crystalline# %f%h%w%m%r %#CrystallineMid#'
        \ . '%=%#Crystalline# %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction
let g:crystalline_theme = 'default'
set laststatus=2
```

### Adding More Statusline Information

```vim
function! g:CrystallineStatuslineFn(ctx)
  return ' %f%h%w%m%r %{fugitive#Head()} %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
endfunction
set laststatus=2
```

### Hiding Sections Based on Window Width

```vim
function! g:CrystallineStatuslineFn(ctx)
  return ' %f%h%w%m%r '
        \ . (a:ctx.w > 80 ? '%= %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : 'B')
endfunction
set laststatus=2
```

### Adding Powerline-Style Separators Between Sections

```vim
function! g:CrystallineStatuslineFn(ctx)
  return crystalline#mode_section(0, 'A', 'B')
        \ . ' %f%h%w%m%r ' . crystalline#sep(0, 'B', 'Mid') . '%='
        \ . crystalline#sep(1, 'Mid', 'B') . ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction
let g:crystalline_enable_sep = 1
let g:crystalline_theme = 'default'
set laststatus=2
```

`crystalline#sep()` generates a separator between highlight groups and starts the next highlight group.

The first argument is the index of the separator to use from `:help g:crystalline_separators`.

The other arguments are groups from `:help crystalline-highlight-groups` with `Crystalline` omitted.
The first group is the left group, and the second group is the right group.

### Using the Default Tabline

```vim
set tabline=%!crystalline#default_tabline()
set showtabline=2
```

Shows buffers if there is only one tab, otherwise shows tabs.
For more flexible buffers/tabs, see `:help crystalline#tabs_or_buffers()`.

### Enabling the Default Tabline in Gvim

```vim
set tabline=%!crystalline#default_tabline()
set showtabline=2
set guioptions-=e
```

### Tabline Current Tab Mode Colors

```vim
function! g:CrystallineTablineFn()
  return crystalline#default_tabline({ 'show_mode': 1 })
endfunction
set showtabline=2
```

### Adding More Tabline Information

```vim
function! g:CrystallineTablineFn()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#default_tabline({
        \ 'max_items': 80 - 2,
        \ 'max_width': &columns - strchars(l:vimlabel),
        \ })
        \ . '%=%#CrystallineTab# ' . l:vimlabel
endfunction
set showtabline=2
```

### Full Example

```vim
function! g:CrystallineStatuslineFn(ctx)
  let l:s = ''

  if a:ctx.curr
    let l:s .= crystalline#mode_section(0, 'A', 'B')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  if a:ctx.curr
    let l:s .= crystalline#sep(0, 'B', 'Mid') . ' %{fugitive#Head()}'
  endif

  let l:s .= '%='
  if a:ctx.curr
    let l:s .= crystalline#sep(1, 'Mid', 'B') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#sep(1, 'B', crystalline#mode_group('A'))
  endif
  if a:ctx.w > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! g:CrystallineTablineFn()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#default_tabline({
        \ 'show_mode': 1,
        \ 'enable_sep': 1,
        \ 'max_items': 80 - 2,
        \ 'max_width': &columns - strchars(l:vimlabel),
        \ })
        \ . '%=%#CrystallineTab# ' . l:vimlabel
endfunction
set showtabline=2

let g:crystalline_enable_sep = 1
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
