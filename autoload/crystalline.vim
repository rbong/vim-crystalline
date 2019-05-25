" General Utils {{{

function! crystalline#clamp(curitem, items, maxitems) abort
  if a:curitem <= a:items / 2
    let l:start = 0
  elseif a:maxitems - a:items / 2 - 1 <= a:curitem
    let l:start = a:maxitems - a:items - 1
  else
    let l:start = a:curitem - a:items / 2
  endif
  return [l:start, l:start + a:items]
endfunction

" }}}

" Status Line Utils {{{

function! crystalline#mode_type() abort
  if mode(1) =~# '[nc]'
    return 'n'
  elseif mode(1) =~# '[it]'
    return 'i'
  elseif mode(1) =~# '[vVsS]'
    return 'v'
  elseif mode(1) ==# 'R'
    return 'R'
  endif
  return ''
endfunction

function! crystalline#mode_color() abort
  return '%#Crystalline' . crystalline#mode_hi() . '#'
endfunction

function! crystalline#mode_label() abort
  return g:crystalline_mode_labels[crystalline#mode_type()]
endfunction

function! crystalline#mode() abort
  return crystalline#mode_color() . crystalline#mode_label()
endfunction

function! crystalline#trigger_mode_update() abort
  let l:mode = crystalline#mode_type()
  if get(g:, 'crystalline_mode', '') !=# l:mode
    let g:crystalline_mode = l:mode
    silent doautocmd User CrystallineModeUpdate
  endif
endfunction

function! crystalline#get_statusline(current, win) abort
  call crystalline#trigger_mode_update()
  try
    return function(g:crystalline_statusline_fn)(a:current, winwidth(win_id2win(a:win)))
  catch /^Vim\%((\a\+)\)\=:E118/
    return function(g:crystalline_statusline_fn)(a:current)
  endtry
endfunction

" }}}

" Tab Line Utils {{{

function! crystalline#calculate_max_tabs(leftitems, tabitems, tabselitems, rightitems) abort
  " at max 80 items are allowed
  return (80 - a:leftitems - a:rightitems - a:tabselitems) / max([a:tabitems, 1])
endfunction

function! crystalline#tablabel(buf, max_width) abort
  let [l:empty, l:mod, l:left, l:nomod] = g:crystalline_tab_special
  let l:right = getbufvar(a:buf, '&mod') ? l:mod : l:nomod
  let l:name = pathshorten(bufname(a:buf))[-a:max_width : ]
  if l:name ==# ''
    let l:name = l:empty
  endif
  return l:left . l:name . l:right
endfunction

function! crystalline#buf_tabinfo(maxtabs) abort
  let l:curbuf = bufnr('%')
  let l:tabs = []
  let l:ntabs = 0
  let l:curtab = -1

  for l:i in range(bufnr('$'))
    if bufexists(l:i + 1) && buflisted(l:i + 1)
      call add(l:tabs, l:i + 1)
      let l:ntabs += 1
      if l:i + 1 == l:curbuf
        let l:curtab = l:ntabs
      endif
    endif
  endfor

  if l:ntabs > a:maxtabs
    if l:curtab < 0
      let l:tabs = l:tabs[0 : a:maxtabs]
    else
      let l:clamp = crystalline#clamp(l:curtab - 1, a:maxtabs - 1, l:ntabs)
      let l:tabs = l:tabs[l:clamp[0] : l:clamp[1]]
      let l:curtab -= l:clamp[0]
    endif
    let l:ntabs = a:maxtabs
  endif

  return [l:tabs, l:ntabs, l:curtab]
endfunction

function! crystalline#tabinfo(maxtabs) abort
  let l:tabs = []
  let l:ntabs = tabpagenr('$')
  let l:curtab = tabpagenr()

  if l:ntabs > a:maxtabs
    let l:clamp = crystalline#clamp(tabpagenr() - 1, a:maxtabs - 1, l:ntabs)
    let l:range = range(l:clamp[0], l:clamp[1])
    let l:curtab -= l:clamp[0]
    let l:ntabs = a:maxtabs
  else
    let l:range = range(l:ntabs)
  endif

  for l:i in l:range
    let l:buf = tabpagebuflist(l:i + 1)[tabpagewinnr(l:i + 1) - 1]
    call add(l:tabs, l:buf)
  endfor

  return [l:tabs, l:ntabs, l:curtab]
endfunction

function! crystalline#visual_tabinfo(tabs, curtab, ntabs, pad, tabpad) abort
  if a:ntabs <= 0
    return [[], 0, -1]
  endif

  let [l:empty, l:mod, l:left, l:nomod] = g:crystalline_tab_special

  let l:total_width = &columns - a:pad
  let l:per_tab_width = l:total_width / a:ntabs
  let l:needed_width = len(l:empty) + len(l:left) + max([len(l:mod), len(l:nomod)]) + a:tabpad
  if l:per_tab_width < l:needed_width
    let l:per_tab_width = l:needed_width
  endif
  let l:max_width = l:per_tab_width - a:tabpad

  let l:first = a:curtab > 0 ? a:curtab : 1
  let l:vbufs = [a:tabs[l:first - 1]]
  let l:vtabs = [crystalline#tablabel(l:vbufs[0], l:max_width)]
  let l:width = len(l:vtabs[0]) + a:tabpad
  let l:vcurtab = 1
  let l:vntabs = 1

  let l:offset = 1
  let l:right_cutoff = 0
  let l:left_cutoff = 0
  while 1
    let l:added_tab = 0
    let l:left = l:first - l:offset
    let l:right = l:first + l:offset

    if l:right <= a:ntabs && !l:right_cutoff
      let l:buf = a:tabs[l:right - 1]
      let l:label = crystalline#tablabel(l:buf, l:max_width)
      let l:w = len(l:label) + a:tabpad
      if l:width + l:w <= l:total_width
        call add(l:vbufs, l:buf)
        call add(l:vtabs, l:label)
        let l:width += l:w
        let l:added_tab = 1
        let l:vntabs += 1
      else
        let l:right_cutoff = 1
      endif
    endif

    if l:left > 0 && !l:left_cutoff
      let l:buf = a:tabs[l:left - 1]
      let l:label = crystalline#tablabel(l:buf, l:max_width)
      let l:w = len(l:label) + a:tabpad
      if l:width + l:w <= l:total_width
        let l:vbufs = [l:buf] + l:vbufs
        let l:vtabs = [l:label] + l:vtabs
        let l:width += l:w
        let l:added_tab = 1
        let l:vntabs += 1
        let l:vcurtab += 1
      else
        let l:left_cutoff = 1
      endif
    endif

    if !l:added_tab
      break
    endif
    let l:offset += 1
  endwhile

  return [l:vtabs, l:vntabs, l:vcurtab]
endfunction

function! crystalline#tab_sep(tab, curtab, ntabs, show_mode) abort
  if a:tab == 0
    let l:group_a = 'TabType'
  elseif a:tab == a:curtab
    if a:show_mode
      let l:group_a = g:crystalline_mode_hi_groups[crystalline#mode_type()]
    else
      let l:group_a = 'TabSel'
    endif
  else
    let l:group_a = 'Tab'
  endif

  if a:tab == a:ntabs
    let l:group_b = 'TabFill'
  elseif a:tab + 1 == a:curtab
    if a:show_mode
      let l:group_b = g:crystalline_mode_hi_groups[crystalline#mode_type()]
    else
      let l:group_b = 'TabSel'
    endif
  else
    let l:group_b = 'Tab'
  endif

  if l:group_a ==# 'Tab' && l:group_b ==# 'Tab'
    return get(g:, 'crystalline_enable_sep', 0) ? g:crystalline_tab_separator : ''
  endif

  return crystalline#right_sep(l:group_a, l:group_b)
endfunction

function! crystalline#bufferline(...) abort
  let l:use_buffers = tabpagenr('$') == 1

  let l:items = get(a:, 1, 0)
  let l:width = get(a:, 2, 0)
  let l:show_mode = get(a:, 3, 0)
  let l:allow_mouse = get(a:, 4, 1) && !l:use_buffers

  let l:tabitems = l:allow_mouse ? 1 : 0

  if get(g:, 'crystalline_enable_sep', 0)
    let l:pad = 1
    let l:tabpad = strchars(g:crystalline_separators[0])
    let l:maxtabs = crystalline#calculate_max_tabs(3, l:tabitems, 4, 2 + l:items)
  else
    let l:pad = 0
    let l:tabpad = 0
    let l:maxtabs = crystalline#calculate_max_tabs(2, l:tabitems, 2, 1 + l:items)
  endif

  if l:use_buffers
    let l:pad += l:width + 9
    let [l:tabs, l:ntabs, l:curtab] = crystalline#buf_tabinfo(l:maxtabs)
    let l:tabline = '%#CrystallineTabType# BUFFERS '
  else
    let l:pad += l:width + 6
    let [l:tabs, l:ntabs, l:curtab] = crystalline#tabinfo(l:maxtabs)
    let l:tabline = '%#CrystallineTabType# TABS '
  endif

  let [l:vtabs, l:vntabs, l:vcurtab] = crystalline#visual_tabinfo(l:tabs, l:curtab, l:ntabs, l:pad, l:tabpad)
  let l:tabline .= crystalline#tab_sep(0, l:vcurtab, l:vntabs, l:show_mode)
  for l:i in range(l:vntabs)
    if l:allow_mouse
      let l:tabline .= '%' . (l:i + 1) . 'T'
    endif
    let l:tabline .= l:vtabs[l:i] . crystalline#tab_sep(l:i + 1, l:vcurtab, l:vntabs, l:show_mode)
  endfor
  if l:allow_mouse
    let l:tabline .= '%T'
  endif

  return l:tabline
endfunction

function! crystalline#get_tabline() abort
  return function(g:crystalline_tabline_fn)()
endfunction

" }}}

" Theme Utils {{{

function! crystalline#get_sep_group(group_a, group_b) abort
  return a:group_a . 'To' . (a:group_b ==# '' ? 'Line' : a:group_b)
endfunction

function! crystalline#generate_hi(group, attr) abort
  let l:cterm = a:attr[0]
  let l:gui = a:attr[1]
  let l:extra = len(a:attr) > 2 ? a:attr[2] : ''

  let l:hi = 'hi Crystalline' . a:group
  if has('gui_running')
    let l:hi .= ' guifg=' . l:gui[0] . ' guibg=' . l:gui[1]
  else
    let l:hi .= ' ctermfg=' . l:cterm[0] . ' ctermbg=' . l:cterm[1]
  endif
  let l:hi .= ' ' . l:extra

  return l:hi
endfunction

function! crystalline#generate_theme(theme) abort
  let l:his = []

  unlet! g:crystalline_tab_type_fake_separator

  for l:group in g:crystalline_hi_groups
    let l:attr = get(a:theme, l:group, v:none)
    if type(l:attr) == v:t_none
      continue
    endif
    let l:his += [crystalline#generate_hi(l:group, l:attr)]

    if !get(g:, 'crystalline_enable_sep', 0)
      continue
    endif

    for l:group_b in g:crystalline_supported_sep[l:group]
      let l:attr_b = get(a:theme, l:group_b, v:none)
      if type(l:attr) == v:t_none
        continue
      endif

      let l:sep_attr = [[l:attr[0][1], l:attr_b[0][1]], [l:attr[1][1], l:attr_b[1][1]]]
      if len(l:attr) > 2
        let l:sep_attr += [l:attr[2]]
      endif

      if l:group ==# 'TabType'
        let l:attr_type = has('gui_running') ? 1 : 0
        if l:attr[l:attr_type][1] == l:attr_b[l:attr_type][1]
          let g:crystalline_tab_type_fake_separator = l:group_b
        endif
      endif

      let l:sep_group = crystalline#get_sep_group(l:group, l:group_b)
      let l:his += [crystalline#generate_hi(l:sep_group, l:sep_attr)]
    endfor
  endfor

  if len(l:his) > 0
    exec join(l:his, ' | ')
  endif
endfunction

function! crystalline#mode_hi() abort
  return g:crystalline_mode_hi_groups[crystalline#mode_type()]
endfunction

function! crystalline#sep(group_a, group_b, ch, left) abort
  let l:next_item = '%#Crystalline' . (a:left ? a:group_a : a:group_b) . '#'
  if !get(g:, 'crystalline_enable_sep', 0) || a:ch ==# ''
    return l:next_item
  endif
  if type(a:group_a) == v:t_none || type(a:group_b) == v:t_none
    return ''
  endif
  if a:left == 0 && a:group_a ==# 'TabType' && get(g:, 'crystalline_tab_type_fake_separator', ' ') == a:group_b
    let l:sep_item = g:crystalline_tab_separator
  else
    let l:sep_item = '%#Crystalline' . crystalline#get_sep_group(a:group_a, a:group_b) . '#' . a:ch
  endif
  return l:sep_item . l:next_item
endfunction

function! crystalline#mode_sep(group_b, ch, left) abort
  return crystalline#sep(crystalline#mode_hi(), a:group_b, a:ch, a:left)
endfunction

function! crystalline#right_sep(group_a, group_b) abort
  return crystalline#sep(a:group_a, a:group_b, g:crystalline_separators[0], 0)
endfunction

function! crystalline#left_sep(group_a, group_b) abort
  return crystalline#sep(a:group_a, a:group_b, g:crystalline_separators[1], 1)
endfunction

function! crystalline#right_mode_sep(group) abort
  return crystalline#mode_sep(a:group, g:crystalline_separators[0], 0)
endfunction

function! crystalline#left_mode_sep(group) abort
  return crystalline#mode_sep(a:group, g:crystalline_separators[1], 1)
endfunction

" }}}

" Setting Management {{{

function! crystalline#set_statusline(fn) abort
  let g:crystalline_statusline_fn = a:fn
  exec 'set statusline=%!crystalline#get_statusline(1,' . win_getid() . ')'
  augroup CrystallineAutoStatusline
    au!
    au BufWinEnter,WinEnter * exec 'setlocal statusline=%!crystalline#get_statusline(1,' . win_getid('#') . ')'
    au WinLeave * exec 'setlocal statusline=%!crystalline#get_statusline(0,' . win_getid() . ')'
    au CmdlineLeave : exec 'setlocal statusline=%!crystalline#get_statusline(1,' . win_getid() . ')'
    au CmdWinEnter : exec 'setlocal statusline=%!crystalline#get_statusline(1,0)'
    au CmdlineEnter : exec 'setlocal statusline=%!crystalline#get_statusline(0,' . win_getid() . ')'
  augroup END
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoStatusline
    au!
  augroup END
endfunction

function! crystalline#set_tabline(fn) abort
  let g:crystalline_tabline_fn = a:fn
  set tabline=%!crystalline#get_tabline()
  augroup CrystallineAutoTabline
    au!
    au User CrystallineModeUpdate set tabline=%!crystalline#get_tabline()
    au InsertLeave * set tabline=%!crystalline#get_tabline()
  augroup END
endfunction

function! crystalline#clear_tabline() abort
  set tabline=
  augroup CrystallineAutoTabline
    au!
  augroup END
endfunction

function! crystalline#set_theme(theme) abort
  let g:crystalline_mode = ''
  let g:crystalline_theme = a:theme
  call function('crystalline#theme#' . a:theme . '#set_theme')()
  silent doautocmd User CrystallineSetTheme
  augroup CrystallineTheme
    au!
    au ColorScheme * call function('crystalline#theme#' . g:crystalline_theme . '#set_theme')()
          \ | silent doautocmd User CrystallineSetTheme
  augroup END
endfunction

function! crystalline#clear_theme() abort
  augroup CrystallineTheme
    au!
  augroup END
endfunction

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
