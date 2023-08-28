vim9script

export def TabsOrBuffers(_opts: dict<any>): string
  # Get args
  var opts = empty(_opts) ? _opts : {}

  # Get options
  var is_buffers = get(opts, 'is_buffers', 0)
  var enable_mouse = !is_buffers && get(opts, 'enable_mouse', 1)
  var enable_sep = get(opts, 'enable_sep', 0)
  var sep_index = get(opts, 'sep_index', 0)
  var sep = get(g:crystalline_separators, sep_index, { 'ch': '' })
  var dir = get(opts, 'dir', sep.dir)
  var min_width = get(opts, 'min_width', 24)
  var max_width = get(opts, 'max_width', max([&columns, min_width]))
  var min_tab_width = get(opts, 'min_tab_width',
        strchars(g:crystalline_tab_left .. g:crystalline_tab_empty)
        + max([strchars(g:crystalline_tab_mod), strchars(g:crystalline_tab_nomod)]))
  var min_tab_sel_width = get(opts, 'min_tab_width', min_tab_width)
  var max_items = get(opts, 'max_items', 80)

  # Get group options
  var enable_mode = get(opts, 'enable_mode', 0)
  var group_suffix = get(opts, 'group_suffix', '')
  var tab_group = ''
  var tab_sel_group = ''
  var tab_fill_group = ''
  if enable_mode
    var mode = crystalline#mode_group('')
    tab_group = get(opts, 'tab_group', mode .. 'Tab' .. group_suffix)
    tab_sel_group = get(opts, 'tab_sel_group', mode .. 'TabSel' .. group_suffix)
    tab_fill_group = get(opts, 'tab_fill_group', mode .. 'TabFill' .. group_suffix)
  else
    tab_group = get(opts, 'tab_group', 'Tab')
    tab_sel_group = get(opts, 'tab_sel_group', 'TabSel' .. group_suffix)
    tab_fill_group = get(opts, 'tab_fill_group', 'TabFill' .. group_suffix)
  endif
  var left_group = get(opts, 'left_group', dir ==# '<' ? tab_fill_group : '')
  var right_group = get(opts, 'right_group', dir ==# '<' ? '' : tab_fill_group)

  # Init variables
  var o = ''
  var tabsln = 0
  var width = 0
  var items = 0
  var sep_width = enable_sep ? strchars(sep.ch) : 0
  var first_group = tab_group
  var last_group = tab_group

  # Make sure there's room for leftmost/rightmost separator
  var enable_left_sep = enable_sep && left_group !=# ''
  var enable_right_sep = enable_sep && right_group !=# ''
  var lr_sep_width = 0
  if enable_left_sep
    # Count left sep
    width += sep_width
    items += 2
    lr_sep_width = sep_width
  else
    # Count first group
    items += 1
  endif
  if enable_right_sep
    # Count right sep
    width += sep_width
    items += 2
    lr_sep_width = sep_width
  elseif right_group !=# ''
    # Count right group
    items += 1
  endif
  # Count mouse terminator
  if enable_mouse
    items += 1
  endif

  # Not enough room for any tabs
  if width + min_tab_sel_width > max_width || items > max_items
    return ''
  endif

  # Get tab data
  var tabselidx = -1
  var ntabs = 0
  var tabbufs = []
  if is_buffers
    var bufsel = bufnr()
    if exists('*getbufinfo')
      for buf in getbufinfo()
        var bufnr = buf.bufnr
        if !g:CrystallineHideBufferFn(bufnr)
          if bufsel == bufnr
            tabselidx = ntabs
          endif
          add(tabbufs, bufnr)
          ntabs += 1
        endif
      endfor
    else
      for bufnr in range(1, bufnr('$'))
        if bufexists(bufnr) && !g:CrystallineHideBufferFn(bufnr)
          if bufsel == bufnr
            tabselidx = ntabs
          endif
          add(tabbufs, bufnr)
          ntabs += 1
        endif
      endfor
    endif
  else
    tabselidx = tabpagenr() - 1
    ntabs = tabpagenr('$')
    for tabidx in range(1, ntabs)
      add(tabbufs, tabpagebuflist(tabidx)[tabpagewinnr(tabidx) - 1])
    endfor
  endif

  # No tabs
  if ntabs == 0
    return ''
  endif

  # Calculate remaining items for tabs
  var remaining_items = min([max_items - items, 80])
  # Calculate max tabs
  var items_per_tab = enable_mouse ? 1 : 0
  var max_tabs = remaining_items / items_per_tab
  # Calculate remaining width for tabs
  var remaining_width = max_width - lr_sep_width
  # Calculate max tab width
  var max_tab_width = max([remaining_width / min([ntabs, max_tabs]), min_tab_width + sep_width]) - sep_width
  # Calculate max selected tab width
  var max_tab_sel_width = max([max_tab_width, min_tab_sel_width])
  # Handle different width for selected tabs
  if tabselidx >= 0 && max_tab_sel_width != max_tab_width
    # Recalculate remaining width for non-selected tabs
    remaining_width = max_width - max_tab_sel_width - lr_sep_width
    # Recalculate max tab width
    max_tab_width = max([remaining_width / min([ntabs - 1, max_tabs]), min_tab_width + sep_width]) - sep_width
  endif

  # Add selected tab first to ensure it's always added
  if tabselidx >= 0
    var [tab, tabwidth, tabitems] = g:CrystallineTabFn(tabbufs[tabselidx], max_tab_sel_width, v:true)
    if enable_mouse
      tabitems += 1
      tab = '%' .. (tabselidx + 1) .. 'T' .. tab
    endif
    o ..= tab
    tabsln += 1
    width += tabwidth
    items += tabitems
    first_group = tab_sel_group
    last_group = tab_sel_group
  endif

  # Add at least one tab to left of selected if present and there's space
  var add_left_tabs = tabselidx >= 1 && tabsln < max_tabs && width < max_width && items < max_items
  if add_left_tabs
    var [tab, tabwidth, tabitems] = g:CrystallineTabFn(tabbufs[tabselidx - 1], max_tab_width, v:false)
    if enable_sep
      tab ..= crystalline#sep(sep_index, tab_group, first_group)
      tabwidth += sep_width
      tabitems += 2
    elseif first_group ==# tab_sel_group
      tab ..= '%#Crystalline' .. tab_sel_group .. '#'
      tabitems += 1
    endif
    if enable_mouse
      tabitems += 1
      tab = '%' .. tabselidx .. 'T' .. tab .. ''
    endif
    add_left_tabs = width + tabwidth <= max_width && items + tabitems <= max_items
    if add_left_tabs
      o = tab .. o
      tabsln += 1
      width += tabwidth
      items += tabitems
      first_group = tab_group
    endif
  endif

  # Add at least one tab to right of selected if present and there's space
  var add_right_tabs = tabsln < max_tabs && width < max_width && tabselidx + 1 < ntabs
  if add_right_tabs
    var [tab, tabwidth, tabitems] = g:CrystallineTabFn(tabbufs[tabselidx + 1], max_tab_width, v:false)
    if enable_mouse
      tabitems += 1
      tab = '%' .. (tabselidx + 2) .. 'T' .. tab
    endif
    if enable_sep
      tab = crystalline#sep(sep_index, first_group, tab_group) .. tab
      tabwidth += sep_width
      tabitems += 2
    elseif last_group ==# tab_sel_group
      tab = '%#Crystalline' .. tab_group .. '#' .. tab
      tabitems += 1
    endif
    add_right_tabs = width + tabwidth <= max_width && items + tabitems <= max_items
    if add_right_tabs
      o ..= tab
      tabsln += 1
      width += tabwidth
      items += tabitems
      last_group = tab_group
    endif
  endif

  # Get tab separator
  var tab_sep = ''
  if enable_sep
    tab_sep = crystalline#sep(sep_index, tab_group, tab_group)
  endif

  # Add tabs to left of selected
  var tabidx = add_left_tabs ? tabselidx - 2 : -1
  while tabidx >= 0 && tabsln < max_tabs && width < max_width
    var [tab, tabwidth, tabitems] = g:CrystallineTabFn(tabbufs[tabidx], max_tab_width, v:false)
    if enable_sep
      tab ..= tab_sep
      tabwidth += sep_width
    endif
    if enable_mouse
      tabitems += 1
      tab = '%' .. (tabidx + 1) .. 'T' .. tab
    endif
    if width + tabwidth > max_width || items + tabitems > max_items
      break
    endif
    o = tab .. o
    tabsln += 1
    width += tabwidth
    items += tabitems
    tabidx -= 1
  endwhile

  # Add other tabs to right of selected
  tabidx = add_right_tabs ? tabselidx + 2 : ntabs
  while tabidx < ntabs && tabsln < max_tabs && width < max_width
    var [tab, tabwidth, tabitems] = g:CrystallineTabFn(tabbufs[tabidx], max_tab_width, v:false)
    if enable_mouse
      tabitems += 1
      tab = '%' .. (tabidx + 1) .. 'T' .. tab
    endif
    if enable_sep
      tab = tab_sep .. tab
      tabwidth += sep_width
    endif
    if width + tabwidth > max_width || items + tabitems > max_items
      break
    endif
    o ..= tab
    tabsln += 1
    width += tabwidth
    items += tabitems
    tabidx += 1
  endwhile

  if enable_left_sep
    # Draw left separator
    o = crystalline#sep(sep_index, left_group, first_group) .. o
  else
    # Draw first group
    o = '%#Crystalline' .. first_group .. '#' .. o
  endif

  if enable_right_sep
    # Draw right separator
    o ..= crystalline#sep(sep_index, last_group, right_group)
  elseif right_group !=# ''
    # Draw right group
    o ..= '%#Crystalline' .. right_group .. '#'
  endif

  # End final tab
  if enable_mouse
    o ..= '%T'
  endif

  return o
enddef
