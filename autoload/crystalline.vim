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

function! crystalline#bufferline(...) abort
  throw 'crystalline: crystalline#bufferline() is deprecated, use crystalline#default_tabline()'
endfunction

function! crystalline#hide_buf_tab(...) abort
  throw 'crystalline: crystalline#hide_buf_tab() is deprecated, use crystalline#default_hide_buffer()'
endfunction

function! crystalline#default_tablabel_parts(...) abort
  throw 'crystalline: crystalline#default_tablabel_parts() is deprecated, use crystalline#default_tab()'
endfunction

function! crystalline#default_tabwidth(...) abort
  throw 'crystalline: crystalline#default_tabwidth() is deprecated, use crystalline#default_tab()'
endfunction

" }}}

" General Utils {{{

function! crystalline#escape_statusline_string(str) abort
  return substitute(a:str, '%', '%%', 'g')
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

" }}}

" Statusline Utils {{{

function! crystalline#group(group) abort
  if g:crystalline_auto_prefix_mode_group
    return g:crystalline_mode_hi_groups[mode()] . a:group . g:crystalline_auto_add_group_suffix
  endif
  return a:group . g:crystalline_auto_add_group_suffix
endfunction

function! crystalline#mode_group(group) abort
  return g:crystalline_mode_hi_groups[mode()] . a:group . g:crystalline_auto_add_group_suffix
endfunction

function! crystalline#mode_sep_group(group) abort
  if g:crystalline_auto_prefix_mode_group
    return a:group
  endif
  return g:crystalline_mode_hi_groups[mode()] . a:group
endfunction

function! crystalline#hi_item(group) abort
  return '%#Crystalline' . crystalline#group(a:group) . '#'
endfunction

function! crystalline#mode_hi_item(group) abort
  return '%#Crystalline' . crystalline#mode_group(a:group) . '#'
endfunction

function! crystalline#mode_label() abort
  return g:crystalline_mode_labels[mode()]
endfunction

function! crystalline#mode_section(sep_index, left_group, right_group) abort
  let l:dir = get(g:crystalline_separators, a:sep_index, { 'dir': '>' }).dir

  if l:dir ==# '<'
    return crystalline#sep(a:sep_index, a:left_group, crystalline#mode_sep_group(a:right_group))
          \ . crystalline#mode_label()
  endif

  return crystalline#mode_hi_item(a:left_group)
        \ . crystalline#mode_label()
        \ . crystalline#sep(a:sep_index, crystalline#mode_sep_group(a:left_group), a:right_group)
endfunction

function! crystalline#update_statusline(winnr) abort
  call setwinvar(a:winnr, '&statusline', '%!g:CrystallineStatuslineFn(' . a:winnr . ')')
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
      call crystalline#generate_sep_hi(l:from_group, l:to_group)
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

function! crystalline#plain_sep(sep_index, left_group, right_group) abort
  let l:key = a:sep_index . a:left_group . a:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#get_sep(a:sep_index, a:left_group, a:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

function! crystalline#sep(sep_index, left_group, right_group) abort
  if g:crystalline_auto_prefix_mode_group
    let l:mode = g:crystalline_mode_hi_groups[mode()]
    let l:left_group = l:mode . a:left_group . g:crystalline_auto_add_group_suffix
    let l:right_group = l:mode . a:right_group . g:crystalline_auto_add_group_suffix
  else
    let l:left_group = a:left_group . g:crystalline_auto_add_group_suffix
    let l:right_group = a:right_group . g:crystalline_auto_add_group_suffix
  endif
  let l:key = a:sep_index . l:left_group . l:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#get_sep(a:sep_index, l:left_group, l:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

" }}}

" Tabline Utils {{{

function! crystalline#update_tabline() abort
  set tabline=%!g:CrystallineTablineFn()
endfunction

function! crystalline#default_tab(buf, max_width, is_sel) abort
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

  return [crystalline#escape_statusline_string(l:tab), l:tabwidth, 0]
endfunction

function! crystalline#default_hide_buffer(buf) abort
  return (!buflisted(a:buf) && bufnr('%') != a:buf) || getbufvar(a:buf, '&ft') ==# 'qf'
endfunction

if has('nvim')
  function! crystalline#tabs_or_buffers(...) abort
    return v:lua.require('crystalline').tabs_or_buffers(get(a:, 1, {}))
  endfunction
elseif has('vim9script')
  function! crystalline#tabs_or_buffers(...) abort
    return crystalline#vim9#TabsOrBuffers(get(a:, 1, {}))
  endfunction
else
  function! crystalline#tabs_or_buffers(...) abort
    " Get args
    let l:opts = get(a:, 1, {})

    " Get options
    let l:is_buffers = get(l:opts, 'is_buffers', 0)
    let l:enable_mouse = !l:is_buffers && get(l:opts, 'enable_mouse', 1)
    let l:enable_sep = get(l:opts, 'enable_sep', 0)
    let l:sep_index = get(l:opts, 'sep_index', 0)
    let l:sep = get(g:crystalline_separators, l:sep_index, { 'ch': '' })
    let l:dir = get(l:opts, 'dir', l:sep.dir)
    let l:min_width = get(l:opts, 'min_width', 24)
    let l:max_width = get(l:opts, 'max_width', max([&columns, l:min_width]))
    let l:min_tab_width = get(l:opts, 'min_tab_width',
          \ strchars(g:crystalline_tab_left . g:crystalline_tab_empty)
          \ + max([strchars(g:crystalline_tab_mod), strchars(g:crystalline_tab_nomod)]))
    let l:min_tab_sel_width = get(l:opts, 'min_tab_width', l:min_tab_width)
    let l:max_items = get(l:opts, 'max_items', 80)

    " Get group options
    let l:auto_prefix_mode_group = get(l:opts, 'auto_prefix_mode_group', g:crystalline_auto_prefix_mode_group)
    let l:group_suffix = get(l:opts, 'group_suffix', g:crystalline_auto_add_group_suffix)
    if l:auto_prefix_mode_group
      let l:mode = g:crystalline_mode_hi_groups[mode()]
      let l:tab_group = get(l:opts, 'tab_group', l:mode . 'Tab' . l:group_suffix)
      let l:tab_sel_group = get(l:opts, 'tab_sel_group', l:mode . 'TabSel' . l:group_suffix)
      let l:tab_fill_group = get(l:opts, 'tab_fill_group', l:mode . 'TabFill' . l:group_suffix)
    else
      let l:tab_group = get(l:opts, 'tab_group', 'Tab')
      let l:tab_sel_group = get(l:opts, 'tab_sel_group', 'TabSel' . l:group_suffix)
      let l:tab_fill_group = get(l:opts, 'tab_fill_group', 'TabFill' . l:group_suffix)
    endif
    let l:left_group = get(l:opts, 'left_group', l:dir ==# '<' ? l:tab_fill_group : '')
    let l:right_group = get(l:opts, 'right_group', l:dir ==# '<' ? '' : l:tab_fill_group)

    " Init variables
    let l:o = ''
    let l:tabsln = 0
    let l:width = 0
    let l:items = 0
    let l:sep_width = l:enable_sep ? strchars(l:sep.ch) : 0
    let l:first_group = l:tab_group
    let l:last_group = l:tab_group

    " Make sure there's room for leftmost/rightmost separator
    let l:enable_left_sep = l:enable_sep && l:left_group !=# ''
    let l:enable_right_sep = l:enable_sep && l:right_group !=# ''
    let l:lr_sep_width = 0
    if l:enable_left_sep
      " Count left sep
      let l:width += l:sep_width
      let l:items += 2
      let l:lr_sep_width = l:sep_width
    else
      " Count first group
      let l:items += 1
    endif
    if l:enable_right_sep
      " Count right sep
      let l:width += l:sep_width
      let l:items += 2
      let l:lr_sep_width = l:sep_width
    elseif l:right_group !=# ''
      " Count right group
      let l:items += 1
    endif
    " Count mouse terminator
    if l:enable_mouse
      let l:items += 1
    endif

    " Not enough room for any tabs
    if l:width + l:min_tab_sel_width > l:max_width || l:items > l:max_items
      return ''
    endif

    " Get tab data
    let l:tabselidx = -1
    let l:ntabs = 0
    let l:tabbufs = []
    if l:is_buffers
      let l:bufsel = bufnr()
      if exists('*getbufinfo')
        for l:buf in getbufinfo()
          let l:bufnr = l:buf.bufnr
          if !g:CrystallineHideBufferFn(l:bufnr)
            if l:bufsel == l:bufnr
              let l:tabselidx = l:ntabs
            endif
            call add(l:tabbufs, l:bufnr)
            let l:ntabs += 1
          endif
        endfor
      else
        for l:bufnr in range(1, bufnr('$'))
          if bufexists(l:bufnr) && !g:CrystallineHideBufferFn(l:bufnr)
            if l:bufsel == l:bufnr
              let l:tabselidx = l:ntabs
            endif
            call add(l:tabbufs, l:bufnr)
            let l:ntabs += 1
          endif
        endfor
      endif
    else
      let l:tabselidx = tabpagenr() - 1
      let l:ntabs = tabpagenr('$')
      for l:tabidx in range(1, l:ntabs)
        call add(l:tabbufs, tabpagebuflist(l:tabidx)[tabpagewinnr(l:tabidx) - 1])
      endfor
    endif

    " No tabs
    if ntabs == 0
      return ''
    endif

    " Calculate remaining items for tabs
    let l:remaining_items = min([l:max_items - l:items, 80])
    " Calculate max tabs
    let l:items_per_tab = l:enable_mouse ? 1 : 0
    let l:max_tabs = l:items_per_tab <= 0 ? ntabs : l:remaining_items / l:items_per_tab
    " Calculate remaining width for tabs
    let l:remaining_width = l:max_width - l:lr_sep_width
    " Calculate max tab width
    let l:max_tab_width = max([l:remaining_width / min([l:ntabs, l:max_tabs]), l:min_tab_width + l:sep_width]) - l:sep_width
    " Calculate max selected tab width
    let l:max_tab_sel_width = max([l:max_tab_width, l:min_tab_sel_width])
    " Handle different width for selected tabs
    if l:tabselidx >= 0 && l:max_tab_sel_width != l:max_tab_width
      " Recalculate remaining width for non-selected tabs
      let l:remaining_width = l:max_width - l:max_tab_sel_width - l:lr_sep_width
      " Recalculate max tab width
      let l:max_tab_width = max([l:remaining_width / min([l:ntabs - 1, l:max_tabs]), l:min_tab_width + l:sep_width]) - l:sep_width
    endif

    " Add selected tab first to ensure it's always added
    if l:tabselidx >= 0
      let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabselidx], l:max_tab_sel_width, v:true)
      if l:enable_mouse
        let l:tabitems += 1
        let l:tab = '%' . (l:tabselidx + 1) . 'T' . l:tab
      endif
      let l:o .= l:tab
      let l:tabsln += 1
      let l:width += l:tabwidth
      let l:items += l:tabitems
      let l:first_group = l:tab_sel_group
      let l:last_group = l:tab_sel_group
    endif

    " Add at least one tab to left of selected if present and there's space
    let l:add_left_tabs = l:tabselidx >= 1 && l:tabsln < l:max_tabs && l:width < l:max_width && l:items < l:max_items
    if l:add_left_tabs
      let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabselidx - 1], l:max_tab_width, v:false)
      if l:enable_sep
        let l:tab .= crystalline#plain_sep(l:sep_index, l:tab_group, l:first_group)
        let l:tabwidth += l:sep_width
        let l:tabitems += 2
      elseif l:first_group ==# l:tab_sel_group
        let l:tab .= '%#Crystalline' . l:tab_sel_group . '#'
        let l:tabitems += 1
      endif
      if l:enable_mouse
        let l:tabitems += 1
        let l:tab = '%' . l:tabselidx . 'T' . l:tab . ''
      endif
      let l:add_left_tabs = l:width + l:tabwidth <= l:max_width && l:items + l:tabitems <= l:max_items
      if l:add_left_tabs
        let l:o = l:tab . l:o
        let l:tabsln += 1
        let l:width += l:tabwidth
        let l:items += l:tabitems
        let l:first_group = l:tab_group
      endif
    endif

    " Add at least one tab to right of selected if present and there's space
    let l:add_right_tabs = l:tabsln < l:max_tabs && l:width < l:max_width && l:tabselidx + 1 < l:ntabs
    if l:add_right_tabs
      let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabselidx + 1], l:max_tab_width, v:false)
      if l:enable_mouse
        let l:tabitems += 1
        let l:tab = '%' . (l:tabselidx + 2) . 'T' . l:tab
      endif
      if l:enable_sep
        let l:sep = crystalline#plain_sep(l:sep_index, l:first_group, l:tab_group)
        let l:tab = l:sep . l:tab
        let l:tabwidth += l:sep_width
        let l:tabitems += 2
      elseif l:last_group ==# l:tab_sel_group
        let l:tab = '%#Crystalline' . l:tab_group . '#' . l:tab
        let l:tabitems += 1
      endif
      let l:add_right_tabs = l:width + l:tabwidth <= l:max_width && l:items + l:tabitems <= l:max_items
      if l:add_right_tabs
        let l:o .= l:tab
        let l:tabsln += 1
        let l:width += l:tabwidth
        let l:items += l:tabitems
        let l:last_group = l:tab_group
      endif
    endif

    " Get tab separator
    if l:enable_sep
      let l:tab_sep = crystalline#plain_sep(l:sep_index, l:tab_group, l:tab_group)
    endif

    " Add tabs to left of selected
    let l:tabidx = l:add_left_tabs ? l:tabselidx - 2 : -1
    while l:tabidx >= 0 && l:tabsln < l:max_tabs && l:width < l:max_width
      let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabidx], l:max_tab_width, v:false)
      if l:enable_sep
        let l:tab .= l:tab_sep
        let l:tabwidth += l:sep_width
      endif
      if l:enable_mouse
        let l:tabitems += 1
        let l:tab = '%' . (l:tabidx + 1) . 'T' . l:tab
      endif
      if l:width + l:tabwidth > l:max_width || l:items + l:tabitems > l:max_items
        break
      endif
      let l:o = l:tab . l:o
      let l:tabsln += 1
      let l:width += l:tabwidth
      let l:items += l:tabitems
      let l:tabidx -= 1
    endwhile

    " Add other tabs to right of selected
    let l:tabidx = l:add_right_tabs ? l:tabselidx + 2 : l:ntabs
    while l:tabidx < l:ntabs && l:tabsln < l:max_tabs && l:width < l:max_width
      let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabidx], l:max_tab_width, v:false)
      if l:enable_mouse
        let l:tabitems += 1
        let l:tab = '%' . (l:tabidx + 1) . 'T' . l:tab
      endif
      if l:enable_sep
        let l:tab = l:tab_sep . l:tab
        let l:tabwidth += l:sep_width
      endif
      if l:width + l:tabwidth > l:max_width || l:items + l:tabitems > l:max_items
        break
      endif
      let l:o .= l:tab
      let l:tabsln += 1
      let l:width += l:tabwidth
      let l:items += l:tabitems
      let l:tabidx += 1
    endwhile

    if l:enable_left_sep
      " Draw left separator
      let l:o = crystalline#plain_sep(l:sep_index, l:left_group, l:first_group) . l:o
    else
      " Draw first group
      let l:o = '%#Crystalline' . l:first_group . '#' . l:o
    endif

    if l:enable_right_sep
      " Draw right separator
      let l:o .= crystalline#plain_sep(l:sep_index, l:last_group, l:right_group)
    elseif l:right_group !=# ''
      " Draw right group
      let l:o .= '%#Crystalline' . l:right_group . '#'
    endif

    " End final tab
    if l:enable_mouse
      let l:o .= '%T'
    endif

    return l:o
  endfunction
endif

function! crystalline#tabs(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif
  let l:opts.is_buffers = 0
  return crystalline#tabs_or_buffers(l:opts)
endfunction

function! crystalline#buffers(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif
  let l:opts.is_buffers = 1
  return crystalline#tabs_or_buffers(l:opts)
endfunction

function! crystalline#tab_type_label(...) abort
  if get(a:, 1, 0)
    return g:crystalline_buffers_tab_type_label
  endif
  return g:crystalline_tabs_tab_type_label
endfunction

function! crystalline#default_tabline_is_buffers() abort
  return tabpagenr('$') == 1
endfunction

function! crystalline#default_tabline(...) abort
  if has_key(a:, 1)
    let l:opts = copy(a:1)
  else
    let l:opts = {}
  endif

  let l:is_buffers = crystalline#default_tabline_is_buffers()
  let l:tab_type = crystalline#tab_type_label(l:is_buffers)
  let l:opts.is_buffers = l:is_buffers
  let l:opts.left_group = 'TabType'
  let l:opts.max_items = min([get(l:opts, 'max_items', 80), 80]) - 1
  let l:opts.max_width = get(l:opts, 'max_width', &columns) - strchars(l:tab_type)

  return '%#CrystallineTabType#'
        \ . l:tab_type
        \ . crystalline#tabs_or_buffers(l:opts)
endfunction

" }}}

" Theme Utils {{{

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
  if a:group ==# 'A' || a:group ==# 'B' || a:group ==# 'Fill'
    if a:style is ''
      let l:fallback_attrs = crystalline#get_empty_theme_attrs()
    else
      let l:fallback_attrs = get(a:theme, a:group, crystalline#get_empty_theme_attrs())
    endif
  elseif a:group ==# 'Tab'
    " ensure inactive mid is set
    let [l:fallback_attrs, l:_] = crystalline#set_theme_fallback_attrs(a:theme, 'Inactive', 'Fill')
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

function! crystalline#generate_sep_hi(from_group, to_group) abort
  if get(g:, 'crystalline_no_generate_sep_hi')
    return
  endif

  if (a:from_group == '' || a:to_group == '') && !get(g:, 'crystalline_did_warn_deprecated_hi_groups')
    echoerr 'crystalline: use of deprecated highlight groups detected, see :help crystalline-highlight-groups'
    let g:crystalline_did_warn_deprecated_hi_groups = 1
  endif

  let l:sep_group = a:from_group . 'To' . a:to_group

  let l:attr_a = crystalline#get_hl_attrs(a:from_group)
  let l:attr_b = crystalline#get_hl_attrs(a:to_group)

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

  exec crystalline#generate_hi(l:sep_group, l:sep_attr)
endfunction

function! crystalline#get_airline_attrs(theme_name, style, group) abort
  let l:pal = g:['airline#themes#' . a:theme_name . '#palette']

  if !has_key(get(l:pal, a:style, {}), a:group)
    return crystalline#get_empty_theme_attrs()
  endif

  let l:attrs = l:pal[a:style][a:group]

  let l:extra = get(l:attrs, 4, '')
  if l:extra !=# ''
    let l:extra = 'cterm=' . l:extra . ' gui=' . l:extra
  endif

  " rearrange attributes into crystalline order
  return [[l:attrs[2], l:attrs[3]], [l:attrs[0], l:attrs[1]], l:extra]
endfunction

function! crystalline#get_airline_style_attrs(theme_name, airline_style, style) abort
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
    call extend(l:groups, crystalline#get_airline_style_attrs(a:theme_name, l:airline_style, l:name))
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
  augroup CrystallineAutoUpdateStatusline
    au!
    au BufWinEnter,WinEnter * call crystalline#update_statusline(winnr())
    au WinLeave * call crystalline#update_statusline(winnr())
    if exists('#CmdlineLeave') && exists('#CmdWinEnter') && exists('#CmdlineEnter')
      au CmdlineLeave : call crystalline#update_statusline(winnr())
      au CmdWinEnter : call crystalline#update_statusline(winnr())
      au CmdlineEnter : call crystalline#update_statusline(winnr())
    endif
  augroup END
  call crystalline#update_statusline(winnr())
endfunction

function! crystalline#clear_statusline() abort
  set statusline=
  augroup CrystallineAutoUpdateStatusline
    au!
  augroup END
endfunction

function! crystalline#init_tabline() abort
  if exists('+tabline')
    augroup CrystallineAutoUpdateTabline
      au!
      au ModeChanged * call crystalline#update_tabline()
      au InsertLeave * call crystalline#update_tabline()
    augroup END
    call crystalline#update_tabline()
  endif
endfunction

function! crystalline#clear_tabline() abort
  if exists('+tabline')
    set tabline=
    augroup CrystallineAutoUpdateTabline
      au!
    augroup END
  endif
endfunction

function! crystalline#apply_current_theme() abort
  let g:crystalline_mode = ''
  let g:crystalline_sep_hi_groups = {}
  let g:crystalline_skip_sep_groups = {}
  let g:crystalline_alt_sep_groups = {}
  let g:crystalline_sep_cache = {}

  try
    call function('crystalline#theme#' . g:crystalline_theme . '#set_theme')()
  catch /^Vim\%((\a\+)\)\=:E118:/
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
