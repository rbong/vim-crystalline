# Vimscript Examples

These examples use vimscript.
Examples are also available in [neovim-flavored Lua](examples/neovim_lua_examples.md).

All examples belong in `.vimrc` before `vim-crystalline` is loaded.

## Creating a Basic Statusline

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

## Creating a Basic Tabline

```vim
function! g:CrystallineTablineFn(winnr)
  return crystalline#DefaultTabline()
endfunction

" Always show the tabline
set showtabline=2
" Show the tabline in gvim
set guioptions-=e
```

See [`:help 'tabline'`](https://vimhelp.org/options.txt.html#%27statusline%27) for more info.

## Hiding Sections

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

## Using Highlight Groups

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

See [screenshots](README.md#obligatory-colorful-theme-screenshots)
for the full list of themes.

## Using Separators

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

function! g:CrystallineTablineFn(winnr)
  " Add separators to the tabline
  return crystalline#DefaultTabline({ 'enable_sep': 1 })
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
" Default separators
let g:crystalline_separators = [
      \ { 'ch': '', 'alt_ch': '', 'dir': '>' },
      \ { 'ch': '', 'alt_ch': '', 'dir': '<' },
      \ ]
```

## Using Mode Colors

Using mode colors manually:

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  " Start highlighting section A with mode colors
  let l:s .= crystalline#ModeHiItem('A')

  let l:s .= ' %f%h%w%m%r '

  " Generate a separator with mode colors
  let l:s .= crystalline#Sep(0, crystalline#ModeGroup('A'), crystalline#ModeGroup('Fill'))

  return l:s
endfunction

function! g:CrystallineTablineFn(winnr)
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

  " The mode colors for section A will automatically be added
  let l:s .= crystalline#HiItem('A')

  let l:s .= ' %f%h%w%m%r '

  " A separator with mode colors for both groups will automatically be generated
  let l:s .= crystalline#Sep(0, 'A', 'Fill')

  return l:s
endfunction

function! g:CrystallineTablineFn(winnr)
  " auto_prefix_groups will default to true
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

## Using Color Variants

Using color variants manually:

```vim
function! g:GroupSuffix()
  if &paste
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

  let l:v = g:GroupSuffix()

  " Add the variant onto the end of the highlight item
  let l:s .= crystalline#HiItem('A') . l:v

  let l:s .= ' %f%h%w%m%r '

  return l:s
endfunction

function! g:CrystallineTablineFn(winnr)
  " Add the variant onto the end of all tabline groups
  return crystalline#DefaultTabline({ 'group_suffix': g:GroupSuffix() })
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
```

Using color variants automatically:

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
  let l:s = ''

  " Automatically add the suffix onto the end of all groups
  " Works with all functions
  let g:crystalline_group_suffix = g:GroupSuffix()

  let l:s .= crystalline#HiItem('A')

  let l:s .= ' %f%h%w%m%r '

  return l:s
endfunction

function! g:CrystallineTablineFn(winnr)
  " group_suffix will default to g:crystalline_group_suffix
  let g:crystalline_group_suffix = g:GroupSuffix()
  return crystalline#DefaultTabline()
endfunction

set laststatus=2
set showtabline=2
set guioptions-=e
```

## Showing More Statusline Information

```vim
function! g:CrystallineStatuslineFn(winnr)
  let l:s = ''

  let l:s .= ' %f%h%w%m%r '

  " Add the current branch from vim-fugitive
  " Plugins often provide functions for the statusline
  let l:s .= '%{fugitive#Head()} '

  let l:s .= '%'

  " Show settings in the statusline
  let l:s .= '${&paste ? "PASTE" : ""} '

  return l:s
endfunction

set laststatus=2
```

## Showing More Tabline Information

```vim
function! g:CrystallineTablineFn()
  " The maximum supported statusline/tabline items in Vim
  let l:max_items = 80
  " The width of the screen
  let l:max_width = &columns

  " Start the right side of the tabline
  let l:right = '%='
  let l:max_items -= 1

  " Add a separator
  " Reuse the TabType group for the right section
  let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
  " One item for the separator group, one item to start the TabType group
  let l:max_items -= 2
  " Subtract the width of the separator
  let l:max_width -= 1

  " Add a label indicating if vim or neovim is being used
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  " Use strchars() to get the real visible width
  let l:max_width -= strchars(l:vimlabel)

  return crystalline#DefaultTabline({ 'max_items': l:max_items, 'max_width': l:max_width }) . l:right
endfunction

set showtabline=2
set guioptions-=e
```

## Full Example

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
    let l:s .= crystalline#Sep(1, 'Fill', 'B') . &paste ? 'PASTE ' : ' '
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
  let g:crystalline_group_suffix = g:GroupSuffix()
  let l:max_items = 80
  let l:max_width = &columns

  let l:right = '%='
  let l:max_items -= 1

  let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
  let l:max_items -= 2
  let l:max_width -= 1

  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  let l:max_width -= strchars(l:vimlabel)

  return crystalline#DefaultTabline({
        \ 'enable_sep': 1, 'max_items': l:max_items, 'max_width': l:max_width
        \ }) . l:right
endfunction

set showtabline=2
set guioptions-=e
set laststatus=2
let g:crystalline_auto_prefix_groups = 1
```
