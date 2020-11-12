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
  if mode() =~# '[nc]'
    return 'n'
  elseif mode() =~# '[it]'
    return 'i'
  elseif mode() =~# '[vVsS]'
    return 'v'
  elseif mode() ==# 'R'
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
    silent doautocmd <nomodeline> User CrystallineModeUpdate
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

function! crystalline#get_tab_strings()
  return [
        \ g:crystalline_tab_empty,
        \ g:crystalline_tab_mod,
        \ g:crystalline_tab_left,
        \ g:crystalline_tab_nomod
        \ ]
endfunction

function! crystalline#calculate_max_tabs(leftitems, tabitems, tabselitems, rightitems) abort
  " at max 80 items are allowed
  return (80 - a:leftitems - a:rightitems - a:tabselitems) / max([a:tabitems, 1])
endfunction

function! crystalline#default_tablabel_parts(buf, max_width) abort
  let [l:empty, l:mod, l:left, l:nomod] = crystalline#get_tab_strings()
  let l:right = getbufvar(a:buf, '&mod') ? l:mod : l:nomod
  let l:name = pathshorten(bufname(a:buf))
  let l:short_name = l:name[-a:max_width : ]
  if l:short_name ==# ''
    let l:short_name = l:empty
  endif
  return [l:left, l:name, l:short_name, l:right]
endfunction

function! crystalline#default_tablabel(buf, max_width) abort
  let [l:left, l:name, l:short_name, l:right] = crystalline#default_tablabel_parts(a:buf, a:max_width)
  return l:left . l:short_name . l:right
endfunction

function! crystalline#default_tabwidth() abort
  let [l:empty, l:mod, l:left, l:nomod] = crystalline#get_tab_strings()
  return len(l:empty) + len(l:left) + max([len(l:mod), len(l:nomod)])
endfunction

function! crystalline#hide_buf_tab(buf) abort
  return !bufexists(a:buf) || !buflisted(a:buf) || getbufvar(a:buf, '&ft') ==# 'qf'
endfunction

function! crystalline#buf_tabinfo(maxtabs) abort
  let l:curbuf = bufnr('%')
  let l:tabs = []
  let l:ntabs = 0
  let l:curtab = -1

  let l:HideBuf = function(get(g:, 'crystalline_hide_buf_tab', 'crystalline#hide_buf_tab'))

  for l:i in range(bufnr('$'))
    if !l:HideBuf(l:i + 1)
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

function! crystalline#visual_tabinfo(tabs, curtab, ntabs, pad, tabpad, tabwidth, tablabel) abort
  if a:ntabs <= 0
    return [[], 0, -1]
  endif

  let l:total_width = &columns - a:pad
  let l:per_tab_width = l:total_width / a:ntabs
  let l:needed_width = a:tabwidth + a:tabpad
  if l:per_tab_width < l:needed_width
    let l:per_tab_width = l:needed_width
  endif
  let l:max_width = l:per_tab_width - a:tabpad

  let l:first = a:curtab > 0 ? a:curtab : 1
  let l:vbufs = [a:tabs[l:first - 1]]
  let l:vtabs = [function(a:tablabel)(l:vbufs[0], l:max_width)]
  let l:width = strchars(l:vtabs[0]) + a:tabpad
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
      let l:label = function(a:tablabel)(l:buf, l:max_width)
      let l:w = strchars(l:label) + a:tabpad
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
      let l:label = function(a:tablabel)(l:buf, l:max_width)
      let l:w = strchars(l:label) + a:tabpad
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
  let l:enable_sep = get(g:, 'crystalline_enable_sep', 0)
  let l:use_buffers = tabpagenr('$') == 1

  let l:items = get(a:, 1, 0)
  let l:width = get(a:, 2, 0)
  let l:show_mode = get(a:, 3, 0)
  let l:allow_mouse = get(a:, 4, 1) && !l:use_buffers
  let l:tablabel = get(a:, 5, 'crystalline#default_tablabel')
  let l:tabwidth = get(a:, 6, crystalline#default_tabwidth())
  let l:tabitems = get(a:, 7, 0) + (l:allow_mouse ? 1 : 0)
  let l:tabselitems = get(a:, 8, 0) + (l:enable_sep ? 4 : 2)

  if l:enable_sep
    let l:pad = 1
    let l:tabpad = strchars(g:crystalline_separators[0])
    let l:maxtabs = crystalline#calculate_max_tabs(3, l:tabitems, l:tabselitems, 2 + l:items)
  else
    let l:pad = 0
    let l:tabpad = 0
    let l:maxtabs = crystalline#calculate_max_tabs(2, l:tabitems, l:tabselitems, 1 + l:items)
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

  let [l:vtabs, l:vntabs, l:vcurtab] = crystalline#visual_tabinfo(l:tabs, l:curtab, l:ntabs, l:pad, l:tabpad, l:tabwidth, l:tablabel)
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

" Returns a dictionary with attributes of a highlight group.
" Returns an empty dictionary if the highlight group doesn't exist.
function! crystalline#synIDattrs(hlgroup) abort
  let l:id = synIDtrans(hlID(a:hlgroup))
  if !l:id
    return {}
  endif

  let l:result = {}

  for l:mode in g:crystalline_syn_modes
    let l:result[l:mode] = {}
    let l:result[l:mode]['attrs'] = []

    for l:attr in g:crystalline_syn_attrs
      if synIDattr(l:id, l:attr, l:mode)
        call add(l:result[l:mode].attrs, l:attr)
      endif
    endfor

    " term mode has no colors
    if l:mode ==# 'term'
      continue
    endif

    for l:color in g:crystalline_syn_colors
      " only gui mode has sp color
      if l:color ==# 'sp' && l:mode !=# 'gui'
        continue
      endif
      let l:res_color = synIDattr(l:id, l:color, l:mode)
      let l:result[l:mode][l:color] = !empty(l:res_color) ? l:res_color : 'NONE'
    endfor
  endfor

  return l:result
endfunction

" Translates crystalline#synIDattrs() into the format
" crystalline#generate_hi() understands.
function! crystalline#get_hl_attrs(group) abort
  let l:attrs = crystalline#synIDattrs('Crystalline' . a:group)
  if l:attrs == {}
    return []
  endif
  let l:retval = [[l:attrs.cterm.fg, l:attrs.cterm.bg], [l:attrs.gui.fg, l:attrs.gui.bg]]

  let l:retval_attrs = []
  for l:mode in keys(l:attrs)
    if !empty(l:attrs[l:mode].attrs)
      call add(l:retval_attrs, l:mode . '=' . join(l:attrs[l:mode].attrs, ','))
    endif
  endfor
  if !empty(l:retval_attrs)
    call add(l:retval, join(l:retval_attrs, ' '))
  endif

  return l:retval
endfunction

function! crystalline#generate_hi(group, attr) abort
  let l:cterm = a:attr[0]
  let l:gui = a:attr[1]
  let l:extra = len(a:attr) > 2 ? a:attr[2] : ''

  let l:hi = 'hi Crystalline' . a:group
  let l:hi .= ' guifg=' . l:gui[0] . ' guibg=' . l:gui[1]
  let l:hi .= ' ctermfg=' . l:cterm[0] . ' ctermbg=' . l:cterm[1]
  let l:hi .= ' ' . l:extra

  return l:hi
endfunction

function! crystalline#generate_theme(theme) abort
  let l:his = []

  for [l:group, l:attr] in items(a:theme)
    let l:his += [crystalline#generate_hi(l:group, l:attr)]
  endfor

  if len(l:his) > 0
    exec join(l:his, ' | ')
  endif
endfunction

function! crystalline#mode_hi() abort
  return g:crystalline_mode_hi_groups[crystalline#mode_type()]
endfunction

function! crystalline#generate_sep_hi(group_a, group_b) abort
  let l:attr_a = crystalline#get_hl_attrs(a:group_a)
  let l:attr_b = crystalline#get_hl_attrs(a:group_b)
  let l:sep_attr = [[l:attr_a[0][1], l:attr_b[0][1]], [l:attr_a[1][1], l:attr_b[1][1]]]
  if len(l:attr_a) > 2
    let l:sep_attr += [l:attr_a[2]]
  endif

  if a:group_a ==# 'TabType'
    let l:attr_type = has('gui_running') ? 1 : 0
    if l:attr_a[l:attr_type][1] == l:attr_b[l:attr_type][1]
      let g:crystalline_tab_type_fake_separators[a:group_b] = 1
    endif
  endif

  let l:sep_group = crystalline#get_sep_group(a:group_a, a:group_b)
  exec crystalline#generate_hi(l:sep_group, l:sep_attr)
endfunction

function! crystalline#sep(group_a, group_b, ch, left) abort
  let l:next_item = '%#Crystalline' . (a:left ? a:group_a : a:group_b) . '#'
  if !get(g:, 'crystalline_enable_sep', 0) || a:ch ==# ''
    return l:next_item
  endif
  if a:group_a == v:null || a:group_b == v:null
    return ''
  endif

  let l:sep_group = crystalline#get_sep_group(a:group_a, a:group_b)
  " Create if it doesn't exist
  if !has_key(g:crystalline_sep_hi_groups, l:sep_group)
    call crystalline#generate_sep_hi(a:group_a, a:group_b)
    let g:crystalline_sep_hi_groups[l:sep_group] = [a:group_a, a:group_b]
  endif

  if a:left == 0 && a:group_a ==# 'TabType' && has_key(g:crystalline_tab_type_fake_separators, a:group_b)
    let l:sep_item = g:crystalline_tab_separator
  else
    let l:sep_item = '%#Crystalline' . l:sep_group . '#' . a:ch
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
  call crystalline#set_local_statusline(1, win_getid())
  augroup CrystallineAutoStatusline
    au!
    au BufWinEnter,WinEnter * call crystalline#set_local_statusline(1, win_getid('#'))
    au WinLeave * call crystalline#set_local_statusline(0, win_getid())
    if exists('#CmdlineLeave') && exists('#CmdWinEnter') && exists('#CmdlineEnter')
      au CmdlineLeave : call crystalline#set_local_statusline(1,  win_getid())
      au CmdWinEnter : call crystalline#set_local_statusline(1, 0)
      au CmdlineEnter : call crystalline#set_local_statusline(0, win_getid())
    endif
  augroup END
endfunction

function! crystalline#default_ignore_fn(current)
  if exists('g:crystalline_ignore_filetype_fn')
    return '%!' .  function(g:crystalline_ignore_filetype_fn)(a:current)
  endif
  return "%#Crystalline" . (a:current ? crystalline#mode_hi() : 'Inactive' ) . "#%{&ft}"
endfunction

function! crystalline#set_local_statusline(current, win) abort
    " ignore custom list
    if exists('g:crystalline_ignore_filetype_list')
      \ && (index(g:crystalline_ignore_filetype_list, &filetype) > 0 || &filetype == '')
      exec "setlocal statusline=%!crystalline#default_ignore_fn(" . a:current . ')'
    else
      exec 'setlocal statusline=%!crystalline#get_statusline(' . a:current . ',' . a:win . ')'
    endif
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoStatusline
    au!
  augroup END
endfunction

function! crystalline#set_tabline(fn) abort
  if exists('+tabline')
    let g:crystalline_tabline_fn = a:fn
    set tabline=%!crystalline#get_tabline()
    augroup CrystallineAutoTabline
      au!
      au User CrystallineModeUpdate set tabline=%!crystalline#get_tabline()
      au InsertLeave * set tabline=%!crystalline#get_tabline()
    augroup END
  endif
endfunction

function! crystalline#clear_tabline() abort
  if exists('+tabline')
    set tabline=
    augroup CrystallineAutoTabline
      au!
    augroup END
  endif
endfunction

function! crystalline#apply_current_theme() abort
  let g:crystalline_mode = ''
  let g:crystalline_sep_hi_groups = {}
  let g:crystalline_tab_type_fake_separators = {}

  try
    call function('crystalline#theme#' . g:crystalline_theme . '#set_theme')()
  catch /^Vim\%((\a\+)\)\=:E118/
    " theme does not use autoload function
  endtry

  silent doautocmd <nomodeline> User CrystallineSetTheme
endfunction

function! crystalline#set_theme(theme) abort
  let g:crystalline_theme = a:theme
  call crystalline#apply_current_theme()
endfunction

function! crystalline#clear_theme() abort
  augroup CrystallineTheme
    au!
  augroup END
endfunction

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
