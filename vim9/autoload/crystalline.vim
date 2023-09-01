if !has('vim9script')
  finish
endif

vim9script

# Statusline Utils {{{

export def PlainSep(sep_index: number, left_group: string, right_group: string): string
  var key = sep_index .. left_group .. right_group
  if !has_key(g:crystalline_sep_cache, key)
    g:crystalline_sep_cache[key] = crystalline#GetSep(sep_index, left_group, right_group)
  endif
  return g:crystalline_sep_cache[key]
enddef

export def Sep(sep_index: number, _left_group: string, _right_group: string): string
  var left_group: string
  var right_group: string
  if g:crystalline_auto_prefix_groups
    if g:crystalline_inactive
      left_group = 'Inactive' .. _left_group .. g:crystalline_group_suffix
      right_group = 'Inactive' .. _right_group .. g:crystalline_group_suffix
    else
      var m = g:crystalline_mode_hi_groups[mode()]
      left_group = m .. _left_group .. g:crystalline_group_suffix
      right_group = m .. _right_group .. g:crystalline_group_suffix
    endif
  else
    left_group = _left_group .. g:crystalline_group_suffix
    right_group = _right_group .. g:crystalline_group_suffix
  endif
  var key = sep_index .. left_group .. right_group
  if !has_key(g:crystalline_sep_cache, key)
    g:crystalline_sep_cache[key] = crystalline#GetSep(sep_index, left_group, right_group)
  endif
  return g:crystalline_sep_cache[key]
enddef

# }}}

# Tabline Utils {{{

export def DefaultTab(buf: number, max_width: number, is_sel: bool): list<any>
  # Return early
  if max_width <= 0
    return ['', 0]
  endif

  # Get left/right components
  var left = g:crystalline_tab_left
  var right = getbufvar(buf, '&mod') ? g:crystalline_tab_mod : g:crystalline_tab_nomod
  var lr_width = strchars(left) + strchars(right)
  var max_name_width = max_width - lr_width

  # Get name
  var name = bufname(buf)
  var name_width: number
  if name == ''
    name = g:crystalline_tab_empty
    name_width = strchars(name)
  else
    name = pathshorten(name)
    name_width = strchars(name)
    if name_width > max_name_width
      var split_name = split(name, '/')
      if len(split_name) > g:crystalline_tab_min_path_parts
        name = join(split_name[-g:crystalline_tab_min_path_parts : ], '/')
        name_width = strchars(name)
      endif
    endif
  endif

  # Shorten tab
  var tab: string
  var tabwidth: number
  if max_name_width <= 0
    tab = strcharpart(name, name_width - max_width)
    tabwidth = min([name_width, max_width])
  else
    tab = left .. strcharpart(name, name_width - max_name_width) .. right
    tabwidth = lr_width + min([name_width, max_name_width])
  endif

  return [crystalline#EscapeStatuslineString(tab), tabwidth]
enddef

export def DefaultHideBuffer(buf: number): bool
  return (!buflisted(buf) && bufnr('%') != buf) || getbufvar(buf, '&ft') == 'qf'
enddef

export def TabsOrBuffers(_opts: dict<any>): string
  # Get args
  var opts = empty(_opts) ? {} : _opts

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
  var max_tabs = max([1, get(opts, 'max_tabs', 26)])

  # Get group options
  var auto_prefix_groups = get(opts, 'auto_prefix_groups', g:crystalline_auto_prefix_groups)
  var group_suffix = get(opts, 'group_suffix', g:crystalline_group_suffix)
  var tab_group = ''
  var tab_sel_group = ''
  var tab_fill_group = ''
  if auto_prefix_groups
    var m = g:crystalline_mode_hi_groups[mode()]
    tab_group = get(opts, 'tab_group', m .. 'Tab' .. group_suffix)
    tab_sel_group = get(opts, 'tab_sel_group', m .. 'TabSel' .. group_suffix)
    tab_fill_group = get(opts, 'tab_fill_group', m .. 'TabFill' .. group_suffix)
  else
    tab_group = get(opts, 'tab_group', 'Tab' .. group_suffix)
    tab_sel_group = get(opts, 'tab_sel_group', 'TabSel' .. group_suffix)
    tab_fill_group = get(opts, 'tab_fill_group', 'TabFill' .. group_suffix)
  endif
  var left_group = get(opts, 'left_group', dir == '<' ? tab_fill_group : '')
  var right_group = get(opts, 'right_group', dir == '<' ? '' : tab_fill_group)

  # Init variables
  var o = ''
  var tab_count = 0
  var width = 0
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
    lr_sep_width = sep_width
  endif
  if enable_right_sep
    # Count right sep
    width += sep_width
    lr_sep_width = sep_width
  endif

  # Get tab data
  var tabselidx = -1
  var ntabs = 0
  var tabbufs = []
  if is_buffers
    var bufsel = bufnr()
    if exists('*getbufinfo')
      for buf in getbufinfo()
        var buf_bufnr = buf.bufnr
        if !g:CrystallineHideBufferFn(buf_bufnr)
          if bufsel == buf_bufnr
            tabselidx = ntabs
          endif
          add(tabbufs, buf_bufnr)
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
    var [tab, tabwidth] = g:CrystallineTabFn(tabbufs[tabselidx], max_tab_sel_width, v:true)
    if enable_mouse
      tab = '%' .. (tabselidx + 1) .. 'T' .. tab
    endif
    o ..= tab
    tab_count += 1
    width += tabwidth
    first_group = tab_sel_group
    last_group = tab_sel_group
  endif

  # Add at least one tab to left of selected if present and there's space
  var add_left_tabs = tabselidx > 0 && tabselidx < ntabs && width < max_width && tab_count < max_tabs
  if add_left_tabs
    var [tab, tabwidth] = g:CrystallineTabFn(tabbufs[tabselidx - 1], max_tab_width, v:false)
    if enable_sep
      tab ..= PlainSep(sep_index, tab_group, first_group)
      tabwidth += sep_width
    elseif first_group == tab_sel_group
      tab ..= '%#Crystalline' .. tab_sel_group .. '#'
    endif
    if enable_mouse
      tab = '%' .. tabselidx .. 'T' .. tab .. ''
    endif
    add_left_tabs = width + tabwidth <= max_width
    if add_left_tabs
      o = tab .. o
      tab_count += 1
      width += tabwidth
      first_group = tab_group
    endif
  endif

  # Add at least one tab to right of selected if present and there's space
  var add_right_tabs = width < max_width && tabselidx + 1 < ntabs && tab_count < max_tabs
  if add_right_tabs
    var [tab, tabwidth] = g:CrystallineTabFn(tabbufs[tabselidx + 1], max_tab_width, v:false)
    if enable_mouse
      tab = '%' .. (tabselidx + 2) .. 'T' .. tab
    endif
    if enable_sep
      tab = PlainSep(sep_index, last_group, tab_group) .. tab
      tabwidth += sep_width
    elseif last_group == tab_sel_group
      tab = '%#Crystalline' .. tab_group .. '#' .. tab
    endif
    add_right_tabs = width + tabwidth <= max_width
    if add_right_tabs
      o ..= tab
      tab_count += 1
      width += tabwidth
      last_group = tab_group
    endif
  endif

  # Get tab separator
  var tab_sep = ''
  if enable_sep
    tab_sep = PlainSep(sep_index, tab_group, tab_group)
  endif

  # Add tabs to left of selected
  var tabidx = add_left_tabs ? tabselidx - 2 : -1
  while tabidx >= 0 && width < max_width && tab_count < max_tabs
    var [tab, tabwidth] = g:CrystallineTabFn(tabbufs[tabidx], max_tab_width, v:false)
    if enable_sep
      tab ..= tab_sep
      tabwidth += sep_width
    endif
    if enable_mouse
      tab = '%' .. (tabidx + 1) .. 'T' .. tab
    endif
    if width + tabwidth > max_width
      break
    endif
    o = tab .. o
    tab_count += 1
    width += tabwidth
    tabidx -= 1
  endwhile

  # Add other tabs to right of selected
  tabidx = add_right_tabs ? tabselidx + 2 : ntabs
  while tabidx < ntabs && width < max_width && tab_count < max_tabs
    var [tab, tabwidth] = g:CrystallineTabFn(tabbufs[tabidx], max_tab_width, v:false)
    if enable_mouse
      tab = '%' .. (tabidx + 1) .. 'T' .. tab
    endif
    if enable_sep
      tab = tab_sep .. tab
      tabwidth += sep_width
    endif
    if width + tabwidth > max_width
      break
    endif
    o ..= tab
    tab_count += 1
    width += tabwidth
    tabidx += 1
  endwhile

  if enable_left_sep
    # Draw left separator
    o = PlainSep(sep_index, left_group, first_group) .. o
  else
    # Draw first group
    o = '%#Crystalline' .. first_group .. '#' .. o
  endif

  if enable_right_sep
    # Draw right separator
    o ..= PlainSep(sep_index, last_group, right_group)
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

# }}}

# vim:set et sw=2 ts=2 fdm=marker:
