" Deprecated Functions {{{

function! crystalline#mode(...) abort
  throw 'crystalline: crystalline#mode() is deprecated, use crystalline#mode_section()'
endfunction

function! crystalline#mode_hi(...) abort
  throw 'crystalline: crystalline#mode_hi() is deprecated, use crystalline#mode_group()'
endfunction

function! crystalline#mode_sep(...) abort
  throw 'crystalline: crystalline#mode_sep() is deprecated, use crystalline#sep() with crystalline#mode_group()'
endfunction

function! crystalline#right_sep(...) abort
  throw 'crystalline: crystalline#right_sep() is deprecated, use crystalline#sep()'
endfunction

function! crystalline#left_sep(...) abort
  throw 'crystalline: crystalline#left_sep() is deprecated, use crystalline#sep()'
endfunction

function! crystalline#right_mode_sep(...) abort
  throw 'crystalline: crystalline#right_mode_sep() is deprecated, use crystalline#sep() with crystalline#mode_group()'
endfunction

function! crystalline#left_mode_sep(...) abort
  throw 'crystalline: crystalline#left_mode_sep() is deprecated, use crystalline#sep() with crystalline#mode_group()'
endfunction

" }}}

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

function! crystalline#escape_statusline_string(str) abort
  return substitute(a:str, '%', '%%', 'g')
endfunction

" }}}

" Status Line Utils {{{

function! crystalline#mode_group(group) abort
  return g:crystalline_mode_hi_groups[mode()] . a:group
endfunction

function! crystalline#mode_color(group) abort
  return '%#Crystalline' . crystalline#mode_group(a:group) . '#'
endfunction

function! crystalline#mode_label() abort
  return g:crystalline_mode_labels[mode()]
endfunction

function! crystalline#mode_section(sep_index, mode_group, right_group) abort
  return crystalline#mode_color(a:mode_group)
        \ . crystalline#mode_label()
        \ . crystalline#sep(a:sep_index, crystalline#mode_group(a:mode_group), a:right_group)
endfunction

function! crystalline#trigger_mode_update() abort
  let l:mode = mode()
  if get(g:, 'crystalline_mode', '') !=# l:mode
    let g:crystalline_mode = l:mode
    silent doautocmd <nomodeline> User CrystallineModeUpdate
  endif
endfunction

function! crystalline#get_statusline(current, win) abort
  call crystalline#trigger_mode_update()
  let l:ctx = {
        \ 'curr': a:current,
        \ 'w': winwidth(win_id2win(a:win))
        \ }
  try
    return g:CrystallineStatuslineFn(l:ctx)
  catch /^Vim\%((\a\+)\)\=:E\%(118\|728\|735\)/
    echoerr 'vim-crystalline: use of deprecated args detected, see :help g:CrystallineStatuslineFn'
    throw v:exception
  endtry
endfunction

function! crystalline#init_auto_updates() abort
  augroup CrystallineAutoStatusline
    au!
    if exists('g:CrystallineStatuslineFn') || exists('*g:CrystallineStatuslineFn')
      au BufWinEnter,WinEnter * exec 'setlocal statusline=%!crystalline#get_statusline(v:true,' . win_getid('#') . ')'
      au WinLeave * exec 'setlocal statusline=%!crystalline#get_statusline(v:false,' . win_getid() . ')'
      if exists('#CmdlineLeave') && exists('#CmdWinEnter') && exists('#CmdlineEnter')
        au CmdlineLeave : exec 'setlocal statusline=%!crystalline#get_statusline(v:true,' . win_getid() . ')'
        au CmdWinEnter : exec 'setlocal statusline=%!crystalline#get_statusline(v:true,0)'
        au CmdlineEnter : exec 'setlocal statusline=%!crystalline#get_statusline(v:false,' . win_getid() . ')'
      endif
    endif
    au ModeChanged * call crystalline#trigger_mode_update()
    au InsertLeave * call crystalline#trigger_mode_update()
    au OptionSet * call crystalline#trigger_mode_update()
  augroup END
endfunction

function! crystalline#profile(loops) abort
  let l:start = reltime()
  for _ in range(a:loops)
    redraw!
  endfor
  let l:end = reltime()
  let l:time = reltimefloat(reltime(l:start, l:end)) / a:loops
  echo printf('redraw time: %f seconds', l:time)
endfunction

function! crystalline#get_sep(sep_index, left_group, right_group) abort
  if a:left_group == v:null || a:right_group == v:null
    return ''
  endif

  if a:left_group ==# a:right_group
    let l:next_item = ''
  else
    let l:next_item = '%#Crystalline' . a:right_group . '#'
  endif

  if !get(g:, 'crystalline_enable_sep', 0)
    return l:next_item
  endif

  let l:sep = get(g:crystalline_separators, a:sep_index, {})

  if empty(l:sep)
    return l:next_item
  endif

  let l:ch = l:sep.ch

  if l:sep.dir ==# '<'
    let l:from_group = a:right_group
    let l:to_group = a:left_group
  else
    let l:from_group = a:left_group
    let l:to_group = a:right_group
  endif

  if a:left_group ==# a:right_group
    let l:sep_item = l:sep.alt_ch
  else
    let l:sep_group = crystalline#get_sep_group(l:from_group, l:to_group)

    " Create separator highlight group if it doesn't exist
    if !has_key(g:crystalline_sep_hi_groups, l:sep_group)
      call crystalline#generate_sep_hi(l:from_group, l:to_group)
      let g:crystalline_sep_hi_groups[l:sep_group] = [l:from_group, l:to_group]
    endif

    " Check for same-color separator groups
    if get(g:crystalline_same_bg_sep_groups, l:sep_group, 0)
      let l:sep_item = l:sep.alt_ch
    else
      let l:sep_item = '%#Crystalline' . l:sep_group . '#' . l:ch
    endif
  endif

  return l:sep_item . l:next_item
endfunction

function! crystalline#sep(sep_index, left_group, right_group) abort
  let l:key = a:sep_index . a:left_group . a:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#get_sep(a:sep_index, a:left_group, a:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

" }}}

" Tab Line Utils {{{

function! crystalline#get_tab_strings() abort
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
  let l:name = crystalline#escape_statusline_string(pathshorten(bufname(a:buf)))
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
  return !bufexists(a:buf) || (!buflisted(a:buf) && bufnr('%') != a:buf) || getbufvar(a:buf, '&ft') ==# 'qf'
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

function! crystalline#visual_tabinfo(tabs, curtab, ntabs, pad, tabpad, tabwidth) abort
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
  let l:vtabs = [g:CrystallineTablabelFn(l:vbufs[0], l:max_width)]
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
      let l:label = g:CrystallineTablabelFn(l:buf, l:max_width)
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
      let l:label = g:CrystallineTablabelFn(l:buf, l:max_width)
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

function! crystalline#tab_sep(tab, curtab, ntabs, tab_sel_group) abort
  if a:tab == 0
    let l:left_group = 'TabType'
  elseif a:tab == a:curtab
    let l:left_group = a:tab_sel_group
  else
    let l:left_group = 'Tab'
  endif

  if a:tab == a:ntabs
    let l:right_group = 'TabMid'
  elseif a:tab + 1 == a:curtab
    let l:right_group = a:tab_sel_group
  else
    let l:right_group = 'Tab'
  endif

  return crystalline#sep(g:crystalline_tab_sep_index, l:left_group, l:right_group)
endfunction

function! crystalline#bufferline(...) abort
  let l:enable_sep = get(g:, 'crystalline_enable_sep', 0)

  let l:opts = get(a:, 1, {})

  if type(l:opts) == v:t_number
    echoerr 'crystalline: deprecated args detected to crystalline#bufferline()'
    let l:opts = {}
  endif

  let l:used_items = get(l:opts, 'used_items', 0)
  let l:used_width = get(l:opts, 'used_width', 0)
  let l:tab_sel_group = get(l:opts, 'tab_sel_group', 'TabSel')
  let l:show_tab_type = get(l:opts, 'show_tab_type', 1)
  let l:use_tabs = get(l:opts, 'use_tabs', tabpagenr('$') > 1)
  let l:allow_mouse = get(l:opts, 'allow_mouse', 1) && l:use_tabs
  let l:tabwidth = get(l:opts, 'tabwidth', crystalline#default_tabwidth())
  let l:tabitems = get(l:opts, 'tabitems', 0) + (l:allow_mouse ? 1 : 0)
  let l:tabselitems = get(l:opts, 'tabselitems', 0) + (l:enable_sep ? 4 : 2)

  if l:enable_sep
    let l:pad = 1
    let l:tabpad = strchars(g:crystalline_separators[g:crystalline_tab_sep_index].ch)
    let l:maxtabs = crystalline#calculate_max_tabs(3, l:tabitems, l:tabselitems, 2 + l:used_items)
  else
    let l:pad = 0
    let l:tabpad = 0
    let l:maxtabs = crystalline#calculate_max_tabs(2, l:tabitems, l:tabselitems, 1 + l:used_items)
  endif

  if l:show_tab_type
    if l:use_tabs
      let l:pad += l:used_width + 6
      let [l:tabs, l:ntabs, l:curtab] = crystalline#tabinfo(l:maxtabs)
      let l:tabline = '%#CrystallineTabType# TABS '
    else
      let l:pad += l:used_width + 9
      let [l:tabs, l:ntabs, l:curtab] = crystalline#buf_tabinfo(l:maxtabs)
      let l:tabline = '%#CrystallineTabType# BUFFERS '
    endif
  endif

  let [l:vtabs, l:vntabs, l:vcurtab] = crystalline#visual_tabinfo(l:tabs, l:curtab, l:ntabs, l:pad, l:tabpad, l:tabwidth)
  let l:tabline .= crystalline#tab_sep(0, l:vcurtab, l:vntabs, l:tab_sel_group)
  for l:i in range(l:vntabs)
    if l:allow_mouse
      let l:tabline .= '%' . (l:i + 1) . 'T'
    endif
    let l:tabline .= l:vtabs[l:i] . crystalline#tab_sep(l:i + 1, l:vcurtab, l:vntabs, l:tab_sel_group)
  endfor
  if l:allow_mouse
    let l:tabline .= '%T'
  endif

  return l:tabline
endfunction

" }}}

" Theme Utils {{{

function! crystalline#get_sep_group(left_group, right_group) abort
  return a:left_group . 'To' . a:right_group
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

function! crystalline#generate_hi(group, attrs) abort
  let l:has_attrs = 0

  let l:hi = 'hi Crystalline' . a:group

  for [l:i, l:j, l:name] in g:crystalline_theme_attrs
    let l:value = a:attrs[l:i][l:j]
    if !(l:value is '')
      let l:hi .= ' ' . l:name . '=' . l:value
      let l:has_attrs = 1
    endif
  endfor

  let l:extra = get(a:attrs, 2, '')
  if !empty(l:extra)
    let l:hi .= ' ' . l:extra
    let l:has_attrs = 1
  endif

  if !l:has_attrs
    let l:hi .= ' NONE'
  endif

  return l:hi
endfunction

function! crystalline#get_empty_theme_attrs() abort
  return [['', ''], ['', ''], '']
endfunction

function! crystalline#set_theme_fallback_attrs(theme, style, group) abort
  let l:full_group = a:style . a:group

  if !has_key(a:theme, l:full_group)
    " set default attrs
    let l:attrs = crystalline#get_empty_theme_attrs()
    let a:theme[l:full_group] = l:attrs
  else
    let l:attrs = a:theme[l:full_group]
  endif

  " pad length
  while len(l:attrs) < 2
    let l:attrs += [['', '']]
  endwhil
  if len(l:attrs) < 3
    let l:attrs += ['']
  endif

  " get fallback attrs
  " assume this function is called in fallback order unless otherwise noted
  if a:group ==# 'A' || a:group ==# 'B' || a:group ==# 'Mid'
    if a:style is ''
      let l:fallback_attrs = crystalline#get_empty_theme_attrs()
    else
      let l:fallback_attrs = get(a:theme, a:group, crystalline#get_empty_theme_attrs())
    endif
  elseif a:group ==# 'Tab'
    " ensure inactive mid is set
    let [l:fallback_attrs, l:_] = crystalline#set_theme_fallback_attrs(a:theme, 'Inactive', 'Mid')
  elseif a:group ==# 'TabSel'
    let l:fallback_attrs = a:theme[a:style . 'A']
  elseif a:group ==# 'TabMid'
    let l:fallback_attrs = a:theme[a:style . 'Mid']
  elseif a:group ==# 'TabType'
    let l:fallback_attrs = a:theme[a:style . 'B']
  elseif a:group =~# '\d$'
    " variant
    let l:fallback_attrs = a:theme[substitute(l:full_group, '\d\+$', '', '')]
  else
    let l:fallback_attrs = crystalline#get_empty_theme_attrs()
  endif

  " set default attributes
  let l:has_attrs = 0
  for [l:i, l:j, l:_] in g:crystalline_theme_attrs
    if l:attrs[l:i][l:j] is ''
      let l:attrs[l:i][l:j] = l:fallback_attrs[l:i][l:j]
    else
      let l:has_attrs = 1
    endif
  endfor

  " set default extra attributes
  if !l:has_attrs && empty(l:attrs[2])
    let l:attrs[2] = l:fallback_attrs[2]
  endif

  return [l:attrs, l:fallback_attrs]
endfunction

function! crystalline#generate_theme(theme) abort
  let l:theme = deepcopy(a:theme)
  let l:his = []

  " set fallback attributes
  for l:style in g:crystalline_theme_styles
    for l:group in g:crystalline_theme_groups
      call crystalline#set_theme_fallback_attrs(l:theme, l:style.name, l:group.name)
      for l:variant in range(1, g:crystalline_max_theme_variants)
        call crystalline#set_theme_fallback_attrs(l:theme, l:style.name, l:group.name . l:variant)
      endfor
    endfor
  endfor

  " generate highlight groups
  for [l:group, l:attr] in items(l:theme)
    let l:hi = crystalline#generate_hi(l:group, l:attr)
    if !empty(l:hi)
      let l:his += [l:hi]
    endif
  endfor

  " execute highlight groups
  if len(l:his) > 0
    exec join(l:his, ' | ')
  endif
endfunction

function! crystalline#generate_sep_hi(left_group, right_group) abort
  if get(g:, 'crystalline_no_generate_sep_hi')
    return
  endif

  if (a:left_group == 'Fill' || a:right_group == 'Fill') && !get(g:, 'crystalline_did_warn_deprecated_hi_groups')
    echoerr 'crystalline: use of deprecated highlight groups detected, see :help crystalline-highlight-groups'
    let g:crystalline_did_warn_deprecated_hi_groups = 1
  endif

  let l:attr_a = crystalline#get_hl_attrs(a:left_group)
  let l:attr_b = crystalline#get_hl_attrs(a:right_group)

  if empty(l:attr_a) || empty(l:attr_b)
    return
  endif

  let l:sep_attr = [[l:attr_a[0][1], l:attr_b[0][1]], [l:attr_a[1][1], l:attr_b[1][1]]]
  if len(l:attr_a) > 2
    let l:sep_attr += [l:attr_a[2]]
  endif

  let l:attr_type = has('gui_running') ? 1 : 0
  if l:attr_a[l:attr_type][1] == l:attr_b[l:attr_type][1]
    let g:crystalline_same_bg_sep_groups[crystalline#get_sep_group(a:left_group, a:right_group)] = 1
  endif

  let l:sep_group = crystalline#get_sep_group(a:left_group, a:right_group)
  exec crystalline#generate_hi(l:sep_group, l:sep_attr)
endfunction

function! crystalline#get_airline_attrs(theme_name, style, group) abort
  let l:pal = g:['airline#themes#' . a:theme_name . '#palette']

  if !has_key(get(l:pal, a:style, {}), a:group)
    return crystalline#get_empty_theme_attrs()
  endif

  let l:attrs = l:pal[a:style][a:group]

  " rearrange attributes into crystalline order
  return [[l:attrs[2], l:attrs[3]], [l:attrs[0], l:attrs[1]], get(l:attrs, 4, '')]
endfunction

function! crystalline#get_airline_style_attrs(theme_name, airline_style, style, has_tabs) abort
  let l:is_default_style = a:style ==# ''
  let l:has_tabs = a:style !=# 'Inactive'
  let l:groups = {}

  for l:group in g:crystalline_theme_groups
    let l:name = l:group.name
    let l:airline_group = get(l:group, 'airline_group')
    if empty(l:airline_group)
      continue
    endif

    if !a:has_tabs && l:name =~# '^Tab'
      continue
    endif

    let l:airline_style = empty(l:airline_group[0]) ? a:airline_style : l:airline_group[0]
    let l:airline_group = l:airline_group[1]

    let l:groups[a:style . l:name] = crystalline#get_airline_attrs(a:theme_name, l:airline_style, l:airline_group)

    for [l:variant, l:suffix] in [[1, '_modified'], [2, '_paste']]
      let l:groups[a:style . l:name . l:variant] = crystalline#get_airline_attrs(a:theme_name, l:airline_style . l:suffix, l:airline_group)
    endfor
  endfor

  return l:groups
endfunction

function! crystalline#port_airline_theme(theme_name) abort
  " get all style attributes
  let l:groups = {}
  for l:style in g:crystalline_theme_styles
    let l:name = l:style.name
    let l:airline_style = get(l:style, 'airline_style')
    if empty(l:airline_style)
      continue
    endif
    call extend(l:groups, crystalline#get_airline_style_attrs(a:theme_name, l:airline_style, l:name, get(l:style, 'has_tabs', 1)))
  endfor

  " get fallbacks and filter duplicate styles
  let l:unique_groups = {}
  for l:style in g:crystalline_theme_styles
    for l:group in g:crystalline_theme_groups
      for l:variant in ['', '0', '1']
        let [l:attrs, l:fallback_attrs] = crystalline#set_theme_fallback_attrs(l:groups, l:style.name, l:group.name . l:variant)
        let l:str_attrs = string(l:attrs)
        if l:str_attrs !=# string(l:fallback_attrs)
          let l:unique_groups[l:style.name . l:group.name . l:variant] = l:str_attrs
        endif
      endfor
    endfor
  endfor
  let l:groups = l:unique_groups

  " find max group length for padding
  let l:max_group_len = 0
  for [l:group, l:rules] in items(l:groups)
    if len(l:group) > l:max_group_len
      let l:max_group_len = len(l:group)
    endif
  endfor

  " build output
  let l:o = 'call crystalline#generate_theme({'
  for l:style in g:crystalline_theme_styles
    for l:group in g:crystalline_theme_groups
      for l:variant in ['', '0', '1']
        let l:group_name = l:style.name . l:group.name . l:variant
        if has_key(l:groups, l:group_name)
          let l:attrs = l:groups[l:group_name]
          let l:o .= "\n      \\ '" . l:group_name . "': " . repeat(' ', l:max_group_len - len(l:group_name)) . l:attrs . ','
        endif
      endfor
    endfor
  endfor
  let l:o .= "\n      \\ })"

  return l:o
endfunction

" }}}

" Padding Utils {{{

function! crystalline#left_pad(s, ...) abort
  if empty(a:s)
    return ''
  endif
  let l:amount = a:0 >= 1 ? a:1 : 1
  let l:char = a:0 >= 2 ? a:2 : ' '
  return repeat(l:char, l:amount) . a:s
endfunction

function! crystalline#right_pad(s, ...) abort
  if empty(a:s)
    return ''
  endif
  let l:amount = a:0 >= 1 ? a:1 : 1
  let l:char = a:0 >= 2 ? a:2 : ' '
  return a:s . repeat(l:char, l:amount)
endfunction

" }}}

" Setting Management {{{

function! crystalline#init_statusline() abort
  exec 'set statusline=%!crystalline#get_statusline(1,' . win_getid() . ')'
  call crystalline#init_auto_updates()
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoStatusline
    au!
  augroup END
endfunction

function! crystalline#init_tabline() abort
  if exists('+tabline')
    set tabline=%!g:CrystallineTablineFn()
    augroup CrystallineAutoTabline
      au!
      au User CrystallineModeUpdate set tabline=%!g:CrystallineTablineFn()
    augroup END
    call crystalline#init_auto_updates()
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
  let g:crystalline_same_bg_sep_groups = {}
  let g:crystalline_sep_cache = {}

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
