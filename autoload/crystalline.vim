" Deprecated Functions {{{

function! crystalline#mode(...) abort
  throw 'crystalline: crystalline#mode() is deprecated, use crystalline#ModeSection()'
endfunction

function! crystalline#mode_hi(...) abort
  throw 'crystalline: crystalline#mode_hi() is deprecated, use crystalline#ModeGroup()'
endfunction

function! crystalline#mode_label(...) abort
  throw 'crystalline: crystalline#mode_label() is deprecated, use crystalline#ModeLabel()'
endfunction

function! crystalline#mode_sep(...) abort
  throw 'crystalline: crystalline#mode_sep() is deprecated, use crystalline#Sep() with crystalline#ModeGroup()'
endfunction

function! crystalline#right_sep(...) abort
  throw 'crystalline: crystalline#RightSep() is deprecated, use crystalline#Sep()'
endfunction

function! crystalline#left_sep(...) abort
  throw 'crystalline: crystalline#LeftSep() is deprecated, use crystalline#Sep()'
endfunction

function! crystalline#right_mode_sep(...) abort
  throw 'crystalline: crystalline#right_mode_sep() is deprecated, use crystalline#Sep() with crystalline#ModeGroup()'
endfunction

function! crystalline#left_mode_sep(...) abort
  throw 'crystalline: crystalline#left_mode_sep() is deprecated, use crystalline#Sep() with crystalline#ModeGroup()'
endfunction

function! crystalline#bufferline(...) abort
  throw 'crystalline: crystalline#bufferline() is deprecated, use crystalline#DefaultTabline()'
endfunction

function! crystalline#hide_buf_tab(...) abort
  throw 'crystalline: crystalline#hide_buf_tab() is deprecated, use crystalline#DefaultHideBuffer()'
endfunction

function! crystalline#default_tablabel_parts(...) abort
  throw 'crystalline: crystalline#default_tablabel_parts() is deprecated, use crystalline#DefaultTab()'
endfunction

function! crystalline#default_tabwidth(...) abort
  throw 'crystalline: crystalline#default_tabwidth() is deprecated, use crystalline#DefaultTab()'
endfunction

" }}}

" General Utils {{{

function! crystalline#EscapeStatuslineString(str) abort
  return substitute(a:str, '%', '%%', 'g')
endfunction

function! crystalline#LeftPad(s, ...) abort
  if empty(a:s)
    return ''
  endif
  let l:amount = a:0 >= 1 ? a:1 : 1
  let l:char = a:0 >= 2 ? a:2 : ' '
  return repeat(l:char, l:amount) . a:s
endfunction

function! crystalline#RightPad(s, ...) abort
  if empty(a:s)
    return ''
  endif
  let l:amount = a:0 >= 1 ? a:1 : 1
  let l:char = a:0 >= 2 ? a:2 : ' '
  return a:s . repeat(l:char, l:amount)
endfunction

function! crystalline#Profile(loops) abort
  let l:start = reltime()
  for _ in range(a:loops)
    redraw!
  endfor
  let l:end = reltime()
  let l:time = reltimefloat(reltime(l:start, l:end)) / a:loops
  echo printf('redraw time: %f seconds', l:time)
endfunction

" }}}

" Statusline Utils {{{

function! crystalline#Group(group) abort
  if g:crystalline_auto_prefix_mode_group
    return g:crystalline_mode_hi_groups[mode()] . a:group . g:crystalline_group_suffix
  endif
  return a:group . g:crystalline_group_suffix
endfunction

function! crystalline#ModeGroup(group) abort
  return g:crystalline_mode_hi_groups[mode()] . a:group . g:crystalline_group_suffix
endfunction

function! crystalline#ModeSepGroup(group) abort
  if g:crystalline_auto_prefix_mode_group
    return a:group
  endif
  return g:crystalline_mode_hi_groups[mode()] . a:group
endfunction

function! crystalline#HiItem(group) abort
  return '%#Crystalline' . crystalline#Group(a:group) . '#'
endfunction

function! crystalline#ModeHiItem(group) abort
  return '%#Crystalline' . crystalline#ModeGroup(a:group) . '#'
endfunction

function! crystalline#ModeLabel() abort
  return g:crystalline_mode_labels[mode()]
endfunction

function! crystalline#ModeSection(sep_index, left_group, right_group) abort
  let l:dir = get(g:crystalline_separators, a:sep_index, { 'dir': '>' }).dir

  if l:dir ==# '<'
    return crystalline#Sep(a:sep_index, a:left_group, crystalline#ModeSepGroup(a:right_group))
          \ . crystalline#ModeLabel()
  endif

  return crystalline#ModeHiItem(a:left_group)
        \ . crystalline#ModeLabel()
        \ . crystalline#Sep(a:sep_index, crystalline#ModeSepGroup(a:left_group), a:right_group)
endfunction

function! crystalline#UpdateStatusline(winnr) abort
  call setwinvar(a:winnr, '&statusline', '%!g:CrystallineStatuslineFn(' . a:winnr . ')')
endfunction

function! crystalline#GetSep(sep_index, left_group, right_group) abort
  if a:left_group == v:null || a:right_group == v:null
    return ''
  endif

  if a:left_group ==# a:right_group
    let l:next_item = ''
  else
    let l:next_item = '%#Crystalline' . a:right_group . '#'
  endif

  if !get(g:, 'crystalline_enable_sep', 1)
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
    let l:sep_group = l:from_group . 'To' . l:to_group

    " Create separator highlight group if it doesn't exist
    if !has_key(g:crystalline_sep_hi_groups, l:sep_group)
      call crystalline#GenerateSepHi(l:from_group, l:to_group)
      let g:crystalline_sep_hi_groups[l:sep_group] = [l:from_group, l:to_group]
    endif

    if get(g:crystalline_skip_sep_groups, l:sep_group, 0)
      " Skip separator highlight group
      let l:sep_item = l:sep.alt_ch
    elseif get(g:crystalline_alt_sep_groups, l:sep_group, 0)
      if l:sep.dir ==# '<'
        return l:next_item . l:sep.alt_ch
      endif
      let l:sep_item = l:sep.alt_ch
    else
      let l:sep_item = '%#Crystalline' . l:sep_group . '#' . l:ch
    endif
  endif

  return l:sep_item . l:next_item
endfunction

function! crystalline#PlainSep(sep_index, left_group, right_group) abort
  let l:key = a:sep_index . a:left_group . a:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#GetSep(a:sep_index, a:left_group, a:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

function! crystalline#Sep(sep_index, left_group, right_group) abort
  if g:crystalline_auto_prefix_mode_group
    let l:mode = g:crystalline_mode_hi_groups[mode()]
    let l:left_group = l:mode . a:left_group . g:crystalline_group_suffix
    let l:right_group = l:mode . a:right_group . g:crystalline_group_suffix
  else
    let l:left_group = a:left_group . g:crystalline_group_suffix
    let l:right_group = a:right_group . g:crystalline_group_suffix
  endif
  let l:key = a:sep_index . l:left_group . l:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#GetSep(a:sep_index, l:left_group, l:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

" }}}

" Tabline Utils {{{

function! crystalline#UpdateTabline() abort
  set tabline=%!g:CrystallineTablineFn()
endfunction

function! crystalline#DefaultTab(buf, max_width, is_sel) abort
  " Return early
  if a:max_width <= 0
    return ''
  endif

  " Get left/right components
  let l:left = g:crystalline_tab_left
  let l:right = getbufvar(a:buf, '&mod') ? g:crystalline_tab_mod : g:crystalline_tab_nomod
  let l:lr_width = strchars(l:left) + strchars(l:right)
  let l:max_name_width = a:max_width - l:lr_width

  " Get name
  let l:name = bufname(a:buf)
  if l:name ==# ''
    let l:name = g:crystalline_tab_empty
    let l:name_width = strchars(l:name)
  else
    let l:name = pathshorten(l:name)
    let l:name_width = strchars(l:name)
    if l:name_width > l:max_name_width
      let l:split_name = split(l:name, '/')
      if len(l:split_name) > g:crystalline_tab_min_path_parts
        let l:name = join(split(l:name, '/')[-g:crystalline_tab_min_path_parts:], '/')
        let l:name_width = strchars(l:name)
      endif
    endif
  endif

  " Shorten tab
  if l:max_name_width <= 0
    let l:tab = strcharpart(l:name, l:name_width - a:max_width)
    let l:tabwidth = min([l:name_width, a:max_width])
  else
    let l:tab = l:left . strcharpart(l:name, l:name_width - l:max_name_width) . l:right
    let l:tabwidth = l:lr_width + min([l:name_width, l:max_name_width])
  endif

  return [crystalline#EscapeStatuslineString(l:tab), l:tabwidth, 0]
endfunction

function! crystalline#DefaultHideBuffer(buf) abort
  return (!buflisted(a:buf) && bufnr('%') != a:buf) || getbufvar(a:buf, '&ft') ==# 'qf'
endfunction

function! crystalline#Tabs(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif
  let l:opts.is_buffers = 0
  return crystalline#TabsOrBuffers(l:opts)
endfunction

function! crystalline#Buffers(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif
  let l:opts.is_buffers = 1
  return crystalline#TabsOrBuffers(l:opts)
endfunction

function! crystalline#TabTypeLabel(...) abort
  if get(a:, 1, 0)
    return g:crystalline_buffers_tab_type_label
  endif
  return g:crystalline_tabs_tab_type_label
endfunction

function! crystalline#DefaultTablineIsBuffers() abort
  return tabpagenr('$') == 1
endfunction

function! crystalline#DefaultTabline(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif

  let l:is_buffers = crystalline#DefaultTablineIsBuffers()
  let l:tab_type = crystalline#TabTypeLabel(l:is_buffers)
  let l:opts.is_buffers = l:is_buffers
  let l:opts.left_group = 'TabType'
  let l:opts.max_items = min([get(l:opts, 'max_items', 80), 80]) - 1
  let l:opts.max_width = get(l:opts, 'max_width', &columns) - strchars(l:tab_type)

  return '%#CrystallineTabType#'
        \ . l:tab_type
        \ . crystalline#TabsOrBuffers(l:opts)
endfunction

" }}}

" Theme Utils {{{

" Returns a dictionary with attributes of a highlight group.
" Returns an empty dictionary if the highlight group doesn't exist.
function! crystalline#SynIDattrs(hlgroup) abort
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

" Translates crystalline#SynIDattrs() into the format
" crystalline#GenerateHi() understands.
function! crystalline#GetHlAttrs(group) abort
  let l:attrs = crystalline#SynIDattrs('Crystalline' . a:group)
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

function! crystalline#GenerateHi(group, attrs) abort
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

function! crystalline#GetEmptyThemeAttrs() abort
  return [['', ''], ['', ''], '']
endfunction

function! crystalline#SetThemeFallbackAttrs(theme, style, group) abort
  let l:full_group = a:style . a:group

  if !has_key(a:theme, l:full_group)
    " set default attrs
    let l:attrs = crystalline#GetEmptyThemeAttrs()
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
  if a:group ==# 'A' || a:group ==# 'B' || a:group ==# 'Fill'
    if a:style is ''
      let l:fallback_attrs = crystalline#GetEmptyThemeAttrs()
    else
      let l:fallback_attrs = get(a:theme, a:group, crystalline#GetEmptyThemeAttrs())
    endif
  elseif a:group ==# 'Tab'
    " ensure inactive mid is set
    let [l:fallback_attrs, l:_] = crystalline#SetThemeFallbackAttrs(a:theme, 'Inactive', 'Fill')
  elseif a:group ==# 'TabSel'
    let l:fallback_attrs = a:theme[a:style . 'A']
  elseif a:group ==# 'TabFill'
    let l:fallback_attrs = a:theme[a:style . 'Fill']
  elseif a:group ==# 'TabType'
    let l:fallback_attrs = a:theme[a:style . 'B']
  elseif a:group =~# '\d$'
    " variant
    let l:fallback_attrs = a:theme[substitute(l:full_group, '\d\+$', '', '')]
  else
    let l:fallback_attrs = crystalline#GetEmptyThemeAttrs()
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

function! crystalline#GenerateTheme(theme) abort
  let l:theme = deepcopy(a:theme)
  let l:his = []

  " set fallback attributes
  for l:style in g:crystalline_theme_styles
    for l:group in g:crystalline_theme_groups
      call crystalline#SetThemeFallbackAttrs(l:theme, l:style.name, l:group.name)
      for l:variant in range(1, g:crystalline_max_theme_variants)
        call crystalline#SetThemeFallbackAttrs(l:theme, l:style.name, l:group.name . l:variant)
      endfor
    endfor
  endfor

  " generate highlight groups
  for [l:group, l:attr] in items(l:theme)
    let l:hi = crystalline#GenerateHi(l:group, l:attr)
    if !empty(l:hi)
      let l:his += [l:hi]
    endif
  endfor

  " execute highlight groups
  if len(l:his) > 0
    exec join(l:his, ' | ')
  endif
endfunction

function! crystalline#GenerateSepHi(from_group, to_group) abort
  if get(g:, 'crystalline_no_generate_sep_hi')
    return
  endif

  if (a:from_group == '' || a:to_group == '') && !get(g:, 'crystalline_did_warn_deprecated_hi_groups')
    echoerr 'crystalline: use of deprecated highlight groups detected, see :help crystalline-highlight-groups'
    let g:crystalline_did_warn_deprecated_hi_groups = 1
  endif

  let l:sep_group = a:from_group . 'To' . a:to_group

  let l:attr_a = crystalline#GetHlAttrs(a:from_group)
  let l:attr_b = crystalline#GetHlAttrs(a:to_group)

  if empty(l:attr_a) || empty(l:attr_b)
    return
  endif

  let l:attr_type = has('gui_running') ? 1 : 0
  if l:attr_a[l:attr_type] == l:attr_b[l:attr_type]
    let g:crystalline_skip_sep_groups[l:sep_group] = 1
    return
  elseif l:attr_a[l:attr_type][1] == l:attr_b[l:attr_type][1]
    let g:crystalline_alt_sep_groups[l:sep_group] = 1
    return
  endif

  let l:sep_attr = [[l:attr_a[0][1], l:attr_b[0][1]], [l:attr_a[1][1], l:attr_b[1][1]]]
  if len(l:attr_a) > 2
    let l:sep_attr += [l:attr_a[2]]
  endif

  exec crystalline#GenerateHi(l:sep_group, l:sep_attr)
endfunction

function! crystalline#GetAirlineAttrs(theme_name, style, group) abort
  let l:pal = g:['airline#themes#' . a:theme_name . '#palette']

  if !has_key(get(l:pal, a:style, {}), a:group)
    return crystalline#GetEmptyThemeAttrs()
  endif

  let l:attrs = l:pal[a:style][a:group]

  let l:extra = get(l:attrs, 4, '')
  if l:extra !=# ''
    let l:extra = 'cterm=' . l:extra . ' gui=' . l:extra
  endif

  " rearrange attributes into crystalline order
  return [[l:attrs[2], l:attrs[3]], [l:attrs[0], l:attrs[1]], l:extra]
endfunction

function! crystalline#GetAirlineStyleAttrs(theme_name, airline_style, style) abort
  let l:is_default_style = a:style ==# ''
  let l:has_tabs = a:style !=# 'Inactive'
  let l:groups = {}

  for l:group in g:crystalline_theme_groups
    let l:name = l:group.name
    let l:airline_group = get(l:group, 'airline_group')
    if empty(l:airline_group)
      continue
    endif

    if a:style ==# 'Inactive' && l:name =~# '^Tab'
      continue
    endif

    let l:airline_style = empty(l:airline_group[0]) ? a:airline_style : l:airline_group[0]
    let l:airline_group = l:airline_group[1]

    let l:groups[a:style . l:name] = crystalline#GetAirlineAttrs(a:theme_name, l:airline_style, l:airline_group)

    for [l:variant, l:suffix] in [[1, '_modified'], [2, '_paste']]
      let l:groups[a:style . l:name . l:variant] = crystalline#GetAirlineAttrs(a:theme_name, l:airline_style . l:suffix, l:airline_group)
    endfor
  endfor

  return l:groups
endfunction

function! crystalline#PortAirlineTheme(theme_name) abort
  " get all style attributes
  let l:groups = {}
  for l:style in g:crystalline_theme_styles
    let l:name = l:style.name
    let l:airline_style = get(l:style, 'airline_style')
    if empty(l:airline_style)
      continue
    endif
    call extend(l:groups, crystalline#GetAirlineStyleAttrs(a:theme_name, l:airline_style, l:name))
  endfor

  " get fallbacks and filter duplicate styles
  let l:unique_groups = {}
  for l:style in g:crystalline_theme_styles
    for l:group in g:crystalline_theme_groups
      for l:variant in ['', '0', '1']
        let [l:attrs, l:fallback_attrs] = crystalline#SetThemeFallbackAttrs(l:groups, l:style.name, l:group.name . l:variant)
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
  let l:o = 'call crystalline#GenerateTheme({'
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

" Setting Management {{{

function! crystalline#InitStatusline() abort
  augroup CrystallineAutoUpdateStatusline
    au!
    au BufWinEnter,WinEnter * call crystalline#UpdateStatusline(winnr())
    au WinLeave * call crystalline#UpdateStatusline(winnr())
    if exists('#CmdlineLeave') && exists('#CmdWinEnter') && exists('#CmdlineEnter')
      au CmdlineLeave : call crystalline#UpdateStatusline(winnr())
      au CmdWinEnter : call crystalline#UpdateStatusline(winnr())
      au CmdlineEnter : call crystalline#UpdateStatusline(winnr())
    endif
  augroup END
  call crystalline#UpdateStatusline(winnr())
endfunction

function! crystalline#ClearStatusline() abort
  set statusline=
  augroup CrystallineAutoUpdateStatusline
    au!
  augroup END
endfunction

function! crystalline#InitTabline() abort
  if exists('+tabline')
    augroup CrystallineAutoUpdateTabline
      au!
      au ModeChanged * call crystalline#UpdateTabline()
      au InsertLeave * call crystalline#UpdateTabline()
    augroup END
    call crystalline#UpdateTabline()
  endif
endfunction

function! crystalline#ClearTabline() abort
  if exists('+tabline')
    set tabline=
    augroup CrystallineAutoUpdateTabline
      au!
    augroup END
  endif
endfunction

function! crystalline#ApplyCurrentTheme() abort
  let g:crystalline_mode = ''
  let g:crystalline_sep_hi_groups = {}
  let g:crystalline_skip_sep_groups = {}
  let g:crystalline_alt_sep_groups = {}
  let g:crystalline_sep_cache = {}

  try
    call function('crystalline#theme#' . g:crystalline_theme . '#SetTheme')()
  catch /^Vim\%((\a\+)\)\=:E118:/
    " theme does not use autoload function
  endtry

  silent doautocmd <nomodeline> User CrystallineSetTheme
endfunction

function! crystalline#SetTheme(theme) abort
  let g:crystalline_theme = a:theme
  call crystalline#ApplyCurrentTheme()
endfunction

function! crystalline#ClearTheme() abort
  return crystalline#SetTheme('default')
endfunction

" }}}

" Load Optimized Functions {{{

let s:scriptdir = expand('<sfile>:p:h:h')

if has('nvim')
  exec 'source ' . s:scriptdir . '/nvim/autoload/crystalline.vim'
elseif has('vim9script')
  exec 'source ' . s:scriptdir . '/vim9/autoload/crystalline.vim'
else
  exec 'source ' . s:scriptdir . '/legacy/autoload/crystalline.vim'
endif

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
