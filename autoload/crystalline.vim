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
  return a:list[l:bounds[0] : l:bounds[1]]
endfunction

function! crystalline#pad_label(label, minwidth) abort
  let l:pad = a:minwidth - len(a:label)
  return l:pad <= 0 ? a:label : repeat(' ', l:pad / 2) . a:label . repeat(' ', l:pad / 2 + l:pad % 2)
endfunction

" }}}

" Status Line Utils {{{

function! crystalline#mode_type() abort
  if mode(1) =~# '[nc]'
    return 'n'
  elseif mode(1) =~# '[iRt]'
    return 'i'
  elseif mode(1) =~# '[vVsS]'
    return 'v'
  endif
  return ''
endfunction

function! crystalline#mode_color() abort
  return g:crystalline_mode_colors[crystalline#mode_type()]
endfunction

function! crystalline#mode_label() abort
  return g:crystalline_mode_labels[crystalline#mode_type()]
endfunction

function! crystalline#mode() abort
  let l:mode = crystalline#mode_type()
  return g:crystalline_mode_colors[l:mode] . g:crystalline_mode_labels[l:mode]
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

function! crystalline#tablabel_width(pad, tabpad, tab, curtab, ntabs, minwidth) abort
  let l:vtabs = get(g:, 'crystalline_visible_tabs', a:ntabs)
  let l:width = (&columns - a:pad) / l:vtabs

  if l:width < a:minwidth
    let l:width = a:minwidth
    " show only tabs on either side of the active tab that will be visible at the minimum width
    let l:extratabs = (&columns - a:pad - a:minwidth) / a:minwidth
    if !crystalline#in_clamped_range(a:tab - 1, a:curtab - 1, l:extratabs, a:ntabs)
      let g:in_range = 0
      return 0
    endif
  endif

  return l:width - a:tabpad
endfunction

function! crystalline#buftablabel(special, buf, pad, tab, curtab, ntabs) abort
  let [l:empty, l:mod, l:nomod, l:right] = a:special

  let l:left = getbufvar(a:buf, '&mod') ? l:mod : l:nomod
  let l:minwidth = len(l:empty) + max([len(l:mod), len(l:nomod)]) + len(l:right)

  let l:width = crystalline#tablabel_width(a:pad, len(l:left) + len(l:right), a:tab, a:curtab, a:ntabs, l:minwidth)
  if l:width == 0
    return ''
  endif

  let l:name = pathshorten(bufname(a:buf))[-l:width : ]
  if l:name ==# ''
    let l:name = l:empty
  endif

  " for some reason leftmost spacing is not shown except on the first tab
  let l:extrapad = a:tab == 1 ? '' : ' '
  return l:extrapad . crystalline#pad_label(l:left . l:name . l:right, l:minwidth)
endfunction

function! crystalline#tablabel(i) abort
  let l:buf = tabpagebuflist(a:i)[tabpagewinnr(a:i) - 1]
  return crystalline#buftablabel(['[No Name]', '+', ' ', ' '], l:buf, 6, a:i, tabpagenr(), tabpagenr('$'))
endfunction

function! crystalline#buflabel(i) abort
  let l:tab = get(g:crystalline_bufferline_tabnum, a:i, -1)
  let l:curtab = get(g:crystalline_bufferline_tabnum, bufnr('%'), -2)
  let l:ntabs = g:crystalline_bufferline_ntabs
  return crystalline#buftablabel(['[No Name]', '+', ' ', ' '], a:i, 9, l:tab, l:curtab, l:ntabs)
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
      let l:tabs += [(l:i + 1 == l:curbuf ? '%#CrystallineTabSel#' . l:label . '%#CrystallineTab#' : l:label)]
      let g:crystalline_bufferline_ntabs += 1
      let g:crystalline_bufferline_tabnum[l:i + 1] = g:crystalline_bufferline_ntabs
    endif
  endfor

  if g:crystalline_bufferline_ntabs > a:maxtabs
    let l:curtab = g:crystalline_bufferline_tabnum[l:curbuf]
    let l:tabs = crystalline#clamp_list(l:tabs, l:curtab - 1, a:maxtabs - 1, g:crystalline_bufferline_ntabs)
  endif
  let g:crystalline_visible_tabs = min([g:crystalline_bufferline_ntabs, a:maxtabs])

  return join(l:tabs, '')
endfunction

function! crystalline#tabline_tabs(maxtabs) abort
  let l:tabs = ''
  let l:ntabs = tabpagenr('$')
  let l:curtab = tabpagenr()
  let l:range = l:ntabs < a:maxtabs ? range(l:ntabs) :  crystalline#clamped_range(l:curtab - 1, a:maxtabs - 1, l:ntabs)
  let g:crystalline_visible_tabs = min([l:ntabs, a:maxtabs])
  for l:i in l:range
    let l:label = '%{crystalline#tablabel(' . (l:i + 1) . ')}'
    let l:tabs .= (l:i + 1 == l:curtab ? '%#CrystallineTabSel#' . l:label . '%#CrystallineTab#' : l:label)
  endfor
  return l:tabs
endfunction

" }}}

" Full Tab Lines {{{

function! crystalline#bufferline() abort
  let l:maxtabs = crystalline#calculate_max_tabs(2, 1, 2, 1)
  if tabpagenr('$') == 1
    let l:tabline = '%#CrystallineTabType# BUFFERS %#CrystallineTab#' . crystalline#tabline_buffers(l:maxtabs)
  else
    unlet! g:crystalline_bufferline_tabnum g:crystalline_bufferline_ntabs
    let l:tabline = '%#CrystallineTabType# TABS %#CrystallineTab#' . crystalline#tabline_tabs(l:maxtabs)
  endif
  return l:tabline . '%#CrystallineTabFill#'
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

function! crystalline#set_theme(theme) abort
  call function('crystalline#theme#' . a:theme . '#set_theme')()
endfunction

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
