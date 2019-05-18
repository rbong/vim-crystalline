" General Utils {{{

function! crystalline#clamped_range_bounds(curitem, items, maxitems) abort
  if a:curitem <= a:items / 2
    let l:start = 0
  elseif a:maxitems - a:items / 2 - 1 <= a:curitem
    let l:start = a:maxitems - a:items - 1
  else
    let l:start = a:curitem - a:items / 2
  endif
  return [l:start, l:start + a:items]
endfunction

function! crystalline#clamped_range(curitem, items, maxitems) abort
  let l:bounds = crystalline#clamped_range_bounds(a:curitem, a:items, a:maxitems)
  return range(l:bounds[0], l:bounds[1])
endfunction

function! crystalline#in_clamped_range(item, curitem, items, maxitems) abort
  let l:range = crystalline#clamped_range_bounds(a:curitem, a:items, a:maxitems)
  return l:range[0] <= a:item && a:item <= l:range[1]
endfunction

function! crystalline#clamp_list(list, curitem, items, maxitems) abort
  let l:bounds = crystalline#clamped_range_bounds(a:curitem, a:items, a:maxitems)
  let g:bounds = l:bounds
  return a:list[l:bounds[0] : l:bounds[1]]
endfunction

" }}}

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

function! crystalline#auto_statusline(current) abort
  return function(g:crystalline_auto_statusline_fn)(a:current)
endfunction

" }}}

" Tab Line Utils {{{

function! crystalline#calculate_max_tabs(leftitems, tabitems, tabselitems, rightitems) abort
  " at max 80 items are allowed
  return (80 - a:leftitems - a:rightitems - a:tabselitems) / a:tabitems
endfunction

function! crystalline#tablabel_width(pad, tab, curtab, ntabs, minwidth, tabpad) abort
  let l:vtabs = get(g:, 'crystalline_visible_tabs', a:ntabs)
  let l:width = (&columns - a:pad) / l:vtabs

  if l:width < a:minwidth
    let l:width = a:minwidth
    " show only tabs on either side of the actie tab that will be visible at the minimum width
    let l:extratabs = (&columns - a:pad - a:minwidth) / a:minwidth
    if !crystalline#in_clamped_range(a:tab - 1, a:curtab - 1, l:extratabs, l:vtabs)
      return 0
    endif
  endif

  return l:width - a:tabpad
endfunction

function! crystalline#buftablabel(buf, pad, tab, curtab, ntabs) abort
  let l:mod = getbufvar(a:buf, '&mod')

  " 13 is the minimum length of the label (no name buffer with pad)
  let l:width = crystalline#tablabel_width(a:pad, a:tab, a:curtab, a:ntabs, 13, l:mod ? 4 : 2)
  if l:width == 0
    return ''
  endif

  let l:name = pathshorten(bufname(a:buf))[-l:width : ]
  if l:name ==# ''
    let l:name = '[No Name]'
  endif

  return (l:mod ? ' + ' : ' ') . l:name . ' '
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
      let g:crystalline_bufferline_ntabs += 1
      let g:crystalline_bufferline_tabnum[l:i + 1] = g:crystalline_bufferline_ntabs
    endif
  endfor

  if g:crystalline_bufferline_ntabs > a:maxtabs
    let l:curtab = g:crystalline_bufferline_tabnum[l:curbuf]
    let l:tabs = crystalline#clamp_list(l:tabs, l:curtab - 1, 4, g:crystalline_bufferline_ntabs)
  endif
  let g:crystalline_visible_tabs = min([g:crystalline_bufferline_ntabs, a:maxtabs])

  return join(l:tabs, '')
endfunction

function! crystalline#tabline_tabs(maxtabs) abort
  let l:tabs = ''
  let l:ntabs = tabpagenr('$')
  let l:curtab = tabpagenr()
  let l:range = l:ntabs < a:maxtabs ? range(l:ntabs) :  crystalline#clamped_range(l:curtab - 1, 4, l:ntabs)
  let g:crystalline_visible_tabs = min([l:ntabs, a:maxtabs])
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
  let l:maxtabs = crystalline#calculate_max_tabs(2, 1, 2, 1)
  if tabpagenr('$') == 1
    let l:tabline = '%#CrystallineTabType# BUFFERS %#TabLine#' . crystalline#tabline_buffers(l:maxtabs)
  else
    unlet! g:crystalline_bufferline_tabnum g:crystalline_bufferline_ntabs
    let l:tabline = '%#CrystallineTabType# TABS %#TabLine#' . crystalline#tabline_tabs(l:maxtabs)
  endif
  return l:tabline . '%#TabLineFill#'
endfunction

" }}}

" Setting Management {{{

function! crystalline#set_statusline(fn) abort
  let g:crystalline_auto_statusline_fn = a:fn
  set statusline=%!crystalline#auto_statusline(1)
  augroup CrystallineAutoStatusline
    au!
    au BufWinEnter,WinEnter * setlocal statusline=%!crystalline#auto_statusline(1)
    au WinLeave * setlocal statusline=%!crystalline#auto_statusline(0)
    au CmdlineLeave : setlocal statusline=%!crystalline#auto_statusline(1)
    au CmdlineEnter : setlocal statusline=%!crystalline#auto_statusline(0)
  augroup END
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoStatusline
    au!
  augroup END
endfunction

function! crystalline#enable_bufferline() abort
  set tabline=%!crystalline#bufferline()
endfunction

function! crystalline#clear_tabline() abort
  set tabline=
endfunction

function! crystalline#color() abort
  let l:theme = get(g:, 'crystalline_theme_fn', 'crystalline#theme#default#set_theme')
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
