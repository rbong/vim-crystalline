if has('vim9script') || has('nvim')
  finish
endif

" Statusline Utils {{{

function! crystalline#PlainSep(sep_index, left_group, right_group) abort
  let l:key = a:sep_index . a:left_group . a:right_group
  if !has_key(g:crystalline_sep_cache, l:key)
    let g:crystalline_sep_cache[l:key] = crystalline#GetSep(a:sep_index, a:left_group, a:right_group)
  endif
  return g:crystalline_sep_cache[l:key]
endfunction

function! crystalline#Sep(sep_index, left_group, right_group) abort
  if g:crystalline_auto_prefix_groups
    if g:crystalline_inactive
      let l:left_group = 'Inactive' . a:left_group . g:crystalline_group_suffix
      let l:right_group = 'Inactive' . a:right_group . g:crystalline_group_suffix
    else
      let l:m = g:crystalline_mode_hi_groups[mode()]
      let l:left_group = l:m . a:left_group . g:crystalline_group_suffix
      let l:right_group = l:m . a:right_group . g:crystalline_group_suffix
    endif
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
        let l:name = join(l:split_name[-g:crystalline_tab_min_path_parts:], '/')
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

function! crystalline#TabsOrBuffers(...) abort
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
  let l:auto_prefix_groups = get(l:opts, 'auto_prefix_groups', g:crystalline_auto_prefix_groups)
  let l:group_suffix = get(l:opts, 'group_suffix', g:crystalline_group_suffix)
  if l:auto_prefix_groups
    let l:m = g:crystalline_mode_hi_groups[mode()]
    let l:tab_group = get(l:opts, 'tab_group', l:m . 'Tab' . l:group_suffix)
    let l:tab_sel_group = get(l:opts, 'tab_sel_group', l:m . 'TabSel' . l:group_suffix)
    let l:tab_fill_group = get(l:opts, 'tab_fill_group', l:m . 'TabFill' . l:group_suffix)
  else
    let l:tab_group = get(l:opts, 'tab_group', 'Tab' . l:group_suffix)
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

  " Get tab data
  let l:tabselidx = -1
  let l:ntabs = 0
  let l:tabbufs = []
  if l:is_buffers
    let l:bufsel = bufnr()
    if exists('*getbufinfo')
      for l:buf in getbufinfo()
        let l:buf_bufnr = l:buf.bufnr
        if !g:CrystallineHideBufferFn(l:buf_bufnr)
          if l:bufsel == l:buf_bufnr
            let l:tabselidx = l:ntabs
          endif
          call add(l:tabbufs, l:buf_bufnr)
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
  let l:add_left_tabs = l:tabselidx >= 1 && l:width < l:max_width && l:items < l:max_items
  if l:add_left_tabs
    let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabselidx - 1], l:max_tab_width, v:false)
    if l:enable_sep
      let l:tab .= crystalline#PlainSep(l:sep_index, l:tab_group, l:first_group)
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
  let l:add_right_tabs = l:width < l:max_width && l:tabselidx + 1 < l:ntabs
  if l:add_right_tabs
    let [l:tab, l:tabwidth, l:tabitems] = g:CrystallineTabFn(l:tabbufs[l:tabselidx + 1], l:max_tab_width, v:false)
    if l:enable_mouse
      let l:tabitems += 1
      let l:tab = '%' . (l:tabselidx + 2) . 'T' . l:tab
    endif
    if l:enable_sep
      let l:sep = crystalline#PlainSep(l:sep_index, l:last_group, l:tab_group)
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
    let l:tab_sep = crystalline#PlainSep(l:sep_index, l:tab_group, l:tab_group)
  endif

  " Add tabs to left of selected
  let l:tabidx = l:add_left_tabs ? l:tabselidx - 2 : -1
  while l:tabidx >= 0 && l:width < l:max_width
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
  while l:tabidx < l:ntabs && l:width < l:max_width
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
    let l:o = crystalline#PlainSep(l:sep_index, l:left_group, l:first_group) . l:o
  else
    " Draw first group
    let l:o = '%#Crystalline' . l:first_group . '#' . l:o
  endif

  if l:enable_right_sep
    " Draw right separator
    let l:o .= crystalline#PlainSep(l:sep_index, l:last_group, l:right_group)
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

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
