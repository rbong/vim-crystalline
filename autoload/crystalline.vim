" Status Line Utils {{{

function! crystalline#mode() abort
  let l:mode = mode(1)
  if l:mode =~# '[nc]'
    hi! link CrystallineMode CrystallineNormalMode
    return '%#CrystallineMode# NORMAL %#StatusLine#'
  elseif l:mode =~# '[iRt]'
    hi! link CrystallineMode CrystallineInsertMode
    return '%#CrystallineMode# INSERT %#StatusLine#'
  elseif l:mode =~# '[vVsS]'
    hi! link CrystallineMode CrystallineVisualMode
    return '%#CrystallineMode# VISUAL %#StatusLine#'
  endif
endfunction

" }}}

" Tab Line Utils {{{

function! crystalline#buftablabel(buf, padding, tab, curtab, ntabs) abort
  " padding is the length of the tab type label
  " 2 is the length of the spaces on either side of the label
  let l:maxlen = (&columns - a:padding) / a:ntabs - 2
  " 10 is the minimum length of the label
  if l:maxlen <= 9
    let l:maxlen = 10
    " at minimum 2 tabs will be shown on either side of the current tab
    if abs(a:curtab - a:tab) > 2
      return ''
    endif
  endif
  let l:name = pathshorten(bufname(a:buf))[-l:maxlen : ]
  if l:name ==# ''
    let l:name = '[No Name]'
  endif
  return ' ' . l:name . ' '
endfunction

function! crystalline#tablabel(i) abort
  let l:buf = tabpagebuflist(a:i)[tabpagewinnr(a:i) - 1]
  return crystalline#buftablabel(l:buf, 6, a:i, tabpagenr(), tabpagenr('$'))
endfunction

function! crystalline#buflabel(i) abort
  let l:tab = get(g:crystalline_bufferline_tabnum, a:i, -1)
  let l:curtab = get(g:crystalline_bufferline_tabnum, bufnr('%'), -2)
  let l:ntabs = g:crystalline_bufferline_ntabs
  return crystalline#buftablabel(a:i, 9, l:tab, l:curtab, l:ntabs)
endfunction

function! crystalline#tabline_buffers(maxtabs) abort
  let g:crystalline_bufferline_tabnum = {}
  let g:crystalline_bufferline_ntabs = 0

  let l:curbuf = bufnr('%')
  let l:range = range(bufnr('$'))
  let l:tabs = []
  for l:i in l:range
    if bufexists(l:i + 1) && buflisted(l:i + 1)
      let l:label = '%{crystalline#buflabel(' . (l:i + 1) . ')}'
      let l:tabs += [(l:i + 1 == l:curbuf ? '%#TabLineSel#' . l:label . '%#TabLine#' : l:label)]
      let g:crystalline_bufferline_tabnum[l:i + 1] = g:crystalline_bufferline_ntabs
      let g:crystalline_bufferline_ntabs += 1
    endif
  endfor
  if g:crystalline_bufferline_ntabs > a:maxtabs
    let l:curtab = g:crystalline_bufferline_tabnum[bufnr('%')]
    let l:tabs = l:tabs[max([0, l:curtab - 2]) : l:curtab + 2]
  endif
  return join(l:tabs, '')
endfunction

function! crystalline#tabline_tabs(maxtabs) abort
  let l:tabs = ''
  let l:ntabs = tabpagenr('$')
  let l:curtab = tabpagenr()
  let l:range = l:ntabs < a:maxtabs ? range(l:ntabs) :  range(max([l:curtab - 3, 0]), min([l:curtab + 1, ntabs]))
  for l:i in l:range
    let l:label = '%{crystalline#tablabel(' . (l:i + 1) . ')}'
    let l:tabs .= (l:i + 1 == l:curtab ? '%#TabLineSel#' . l:label . '%#TabLine#' : l:label)
  endfor
  return l:tabs
endfunction

" }}}

" Full Tab Lines {{{

function! crystalline#bufferline() abort
  call crystalline#color()
  " at maximum 80 items are allowed
  " 2 items set the buffer line type colors
  " 1 item sets the tab line fill colors
  " 2 items set the tab line selected colors
  let l:maxtabs = 75
  if tabpagenr('$') == 1
    let l:tabline = '%#BufferLineType# BUFFERS %#TabLine#' . crystalline#tabline_buffers(l:maxtabs)
  else
    unlet! g:crystalline_bufferline_tabnum g:crystalline_bufferline_ntabs
    let l:tabline = '%#BufferLineType# TABS %#TabLine#' . crystalline#tabline_tabs(l:maxtabs)
  endif
  return l:tabline . '%#TabLineFill#'
endfunction

" }}}

" Setting Management {{{

function! crystalline#set_statusline(fn) abort
  exec 'set statusline=%!' . a:fn . '(1)'
  augroup CrystallineAutoStatusline
    au!
    exec 'au BufWinEnter,WinEnter * setlocal statusline=%!' . a:fn . '(1)'
    exec 'au WinLeave * setlocal statusline=%!' . a:fn . '(0)'
    exec 'au CmdlineLeave : setlocal statusline=%!' . a:fn . '(1)'
    exec 'au CmdlineEnter : setlocal statusline=%!' . a:fn . '(0)'
  augroup END
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoStatusline
    au!
  augroup END
endfunction

function! crystalline#color() abort
  let l:theme = get(g:, 'crystalline_theme_fn', 'crystalline#theme#powerline#set_theme')
  call function(l:theme)()
endfunction

function! crystalline#set_theme(theme) abort
  let g:crystalline_theme_fn = 'crystalline#theme#' . a:theme . '#set_theme'
endfunction

function! crystalline#clear_theme() abort
  unlet! g:crystalline_theme_fn
endfunction

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
