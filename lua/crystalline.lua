local module = {}

local function bool(value)
  return (value == true or value == 1) and true or false
end

local function get_default(dict, key, default)
  local value = dict[key]
  if value == nil then
    return default
  end
  return value
end

function module.tabs_or_buffers(opts)
  -- Get args
  opts = opts or vim.empty_dict()

  -- Get options
  local is_buffers = bool(get_default(opts, "is_buffers", 0))
  local enable_mouse = not is_buffers and bool(get_default(opts, "enable_mouse", 1))
  local enable_sep = bool(get_default(opts, "enable_sep", 0))
  local sep_index = get_default(opts, "sep_index", 0)
  local sep = get_default(vim.g.crystalline_separators, sep_index, { ch = "" })
  local dir = get_default(opts, "dir", sep.dir)
  local min_width = get_default(opts, "min_width", 24)
  local max_width = get_default(opts, "max_width", math.max(vim.o.columns, min_width))
  local min_tab_width = get_default(
    opts,
    "min_tab_width",
    vim.fn.strchars(vim.g.crystalline_tab_left .. vim.g.crystalline_tab_empty)
      + math.max(vim.fn.strchars(vim.g.crystalline_tab_mod), vim.fn.strchars(vim.g.crystalline_tab_nomod))
  )
  local min_tab_sel_width = get_default(opts, "min_tab_width", min_tab_width)
  local max_items = get_default(opts, "max_items", 80)

  -- Get group options
  local auto_prefix_mode_group = bool(get_default(opts, "auto_prefix_mode_group", vim.g.crystalline_auto_prefix_mode_group))
  local group_suffix = get_default(opts, "group_suffix", vim.g.crystalline_auto_add_group_suffix)
  local tab_group
  local tab_sel_group
  local tab_fill_group
  if auto_prefix_mode_group then
    local mode = vim.fn["crystalline#mode_group"]("")
    tab_group = get_default(opts, "tab_group", mode .. "Tab" .. group_suffix)
    tab_sel_group = get_default(opts, "tab_sel_group", mode .. "TabSel" .. group_suffix)
    tab_fill_group = get_default(opts, "tab_fill_group", mode .. "TabFill" .. group_suffix)
  else
    tab_group = get_default(opts, "tab_group", "Tab")
    tab_sel_group = get_default(opts, "tab_sel_group", "TabSel" .. group_suffix)
    tab_fill_group = get_default(opts, "tab_fill_group", "TabFill" .. group_suffix)
  end
  local left_group = get_default(opts, "left_group", dir == "<" and tab_fill_group or "")
  local right_group = get_default(opts, "right_group", dir == "<" and "" or tab_fill_group)

  -- Init variables
  local o = ""
  local tabsln = 0
  local width = 0
  local items = 0
  local sep_width = enable_sep and vim.fn.strchars(sep.ch) or 0
  local first_group = tab_group
  local last_group = tab_group

  -- Make sure there's room for leftmost/rightmost separator
  local enable_left_sep = enable_sep and left_group ~= ""
  local enable_right_sep = enable_sep and right_group ~= ""
  local lr_sep_width = 0
  if enable_left_sep then
    -- Count left sep
    width = width + sep_width
    items = items + 2
    lr_sep_width = sep_width
  else
    -- Count first group
    items = items + 1
  end
  if enable_right_sep then
    -- Count right sep
    width = width + sep_width
    items = items + 2
    lr_sep_width = sep_width
  elseif right_group ~= "" then
    -- Count right group
    items = items + 1
  end
  -- Count mouse terminator
  if enable_mouse then
    items = items + 1
  end

  -- Not enough room for any tabs
  if width + min_tab_sel_width > max_width or items > max_items then
    return ""
  end

  -- Get tab data
  local bufsel
  local tabselidx = -1
  local ntabs = 0
  local tabbufs = {}

  if bool(is_buffers) then
    bufsel = vim.fn.bufnr()
    for _, buf in pairs(vim.fn.getbufinfo()) do
      local bufnr = buf.bufnr
      if not bool(vim.fn["g:CrystallineHideBufferFn"](bufnr)) then
        ntabs = ntabs + 1
        tabbufs[ntabs] = bufnr
        if bufsel == bufnr then
          tabselidx = ntabs
        end
      end
    end
  else
    tabselidx = vim.fn.tabpagenr()
    ntabs = vim.fn.tabpagenr("$")
    for tabidx = 1, ntabs do
      tabbufs[tabidx] = vim.fn.tabpagebuflist(tabidx)[vim.fn.tabpagewinnr(tabidx)]
    end
  end

  -- No tabs
  if ntabs == 0 then
    return ""
  end

  -- Calculate remaining items for tabs
  local remaining_items = math.min(max_items - items, 80)
  -- Calculate max tabs
  local items_per_tab = enable_mouse and 1 or 0
  local max_tabs = ntabs
  if items_per_tab > 0 then
    max_tabs = math.floor(remaining_items / items_per_tab)
  end
  -- Calculate remaining width for tabs
  local remaining_width = max_width - lr_sep_width
  -- Calculate max tab width
  local max_tab_width = math.max(math.floor(remaining_width / math.min(ntabs, max_tabs)), min_tab_width + sep_width) - sep_width
  -- Calculate max selected tab width
  local max_tab_sel_width = math.max(max_tab_width, min_tab_sel_width)
  -- Handle different width for selected tabs
  if tabselidx > 0 and max_tab_sel_width ~= max_tab_width then
    -- Recalculate remaining width for non-selected tabs
    remaining_width = max_width - max_tab_sel_width - lr_sep_width
    -- Recalculate max tab width
    max_tab_width = math.max(math.floor(remaining_width / math.min(ntabs - 1, max_tabs)), min_tab_width + sep_width) - sep_width
  end

  -- Add selected tab first to ensure it's always added
  if tabselidx > 0 then
    local tabinfo = vim.fn["g:CrystallineTabFn"](tabbufs[tabselidx], max_tab_sel_width, true)
    local tab, tabwidth, tabitems = tabinfo[1], tabinfo[2], tabinfo[3]
    if enable_mouse then
      tabitems = tabitems + 1
      tab = "%" .. tabselidx .. "T" .. tab
    end
    o = o .. tab
    tabsln = tabsln + 1
    width = width + tabwidth
    items = items + tabitems
    first_group = tab_sel_group
    last_group = tab_sel_group
  end

  -- Add at least one tab to left of selected if present and there's space
  local add_left_tabs = tabselidx > 1 and tabsln < max_tabs and width < max_width and items < max_items
  if add_left_tabs then
    local tabinfo = vim.fn["g:CrystallineTabFn"](tabbufs[tabselidx - 1], max_tab_width, false)
    local tab, tabwidth, tabitems = tabinfo[1], tabinfo[2], tabinfo[3]
    if enable_sep then
      tab = tab .. vim.fn["crystalline#plain_sep"](sep_index, tab_group, first_group)
      tabwidth = tabwidth + sep_width
      tabitems = tabitems + 2
    elseif first_group == tab_sel_group then
      tab = tab .. "%#Crystalline" .. tab_sel_group .. "#"
      tabitems = tabitems + 1
    end
    if enable_mouse then
      tabitems = tabitems + 1
      tab = "%" .. (tabselidx - 1) .. "T" .. tab .. ""
    end
    add_left_tabs = width + tabwidth <= max_width and items + tabitems <= max_items
    if add_left_tabs then
      o = tab .. o
      tabsln = tabsln + 1
      width = width + tabwidth
      items = items + tabitems
      first_group = tab_group
    end
  end

  -- Add at least one tab to right of selected if present and there's space
  local add_right_tabs = tabsln < max_tabs and width < max_width and tabselidx > 0 and tabselidx < ntabs
  if add_right_tabs then
    local tabinfo = vim.fn["g:CrystallineTabFn"](tabbufs[tabselidx + 1], max_tab_width, false)
    local tab, tabwidth, tabitems = tabinfo[1], tabinfo[2], tabinfo[3]
    if enable_mouse then
      tabitems = tabitems + 1
      tab = "%" .. (tabselidx + 1) .. "T" .. tab
    end
    if enable_sep then
      tab = vim.fn["crystalline#plain_sep"](sep_index, last_group, tab_group) .. tab
      tabwidth = tabwidth + sep_width
      tabitems = tabitems + 2
    elseif last_group == tab_sel_group then
      tab = "%#Crystalline" .. tab_group .. "#" .. tab
      tabitems = tabitems + 1
    end
    add_right_tabs = width + tabwidth <= max_width and items + tabitems <= max_items
    if add_right_tabs then
      o = o .. tab
      tabsln = tabsln + 1
      width = width + tabwidth
      items = items + tabitems
      last_group = tab_group
    end
  end

  -- Get tab separator
  local tab_sep
  if enable_sep then
    tab_sep = vim.fn["crystalline#plain_sep"](sep_index, tab_group, tab_group)
  end

  -- Add tabs to left of selected
  local tabidx = add_left_tabs and (tabselidx - 2) or -1
  while tabidx > 0 and tabsln < max_tabs and width < max_width do
    local tabinfo = vim.fn["g:CrystallineTabFn"](tabbufs[tabidx], max_tab_width, false)
    local tab, tabwidth, tabitems = tabinfo[1], tabinfo[2], tabinfo[3]
    if enable_sep then
      tab = tab .. tab_sep
      tabwidth = tabwidth + sep_width
    end
    if enable_mouse then
      tabitems = tabitems + 1
      tab = "%" .. tabidx .. "T" .. tab
    end
    if width + tabwidth > max_width or items + tabitems > max_items then
      break
    end
    o = tab .. o
    tabsln = tabsln + 1
    width = width + tabwidth
    items = items + tabitems
    tabidx = tabidx - 1
  end

  -- Add other tabs to right of selected
  tabidx = add_right_tabs and tabselidx + 2 or ntabs + 1
  while tabidx <= ntabs and tabsln < max_tabs and width < max_width do
    local tabinfo = vim.fn["g:CrystallineTabFn"](tabbufs[tabidx], max_tab_width, false)
    local tab, tabwidth, tabitems = tabinfo[1], tabinfo[2], tabinfo[3]
    if enable_mouse then
      tabitems = tabitems + 1
      tab = "%" .. tabidx .. "T" .. tab
    end
    if enable_sep then
      tab = tab_sep .. tab
      tabwidth = tabwidth + sep_width
    end
    if width + tabwidth > max_width or items + tabitems > max_items then
      break
    end
    o = o .. tab
    tabsln = tabsln + 1
    width = width + tabwidth
    items = items + tabitems
    tabidx = tabidx + 1
  end

  if enable_left_sep then
    -- Draw left separator
    o = vim.fn["crystalline#plain_sep"](sep_index, left_group, first_group) .. o
  else
    -- Draw first group
    o = "%#Crystalline" .. first_group .. "#" .. o
  end

  if enable_right_sep then
    -- Draw right separator
    o = o .. vim.fn["crystalline#plain_sep"](sep_index, last_group, right_group)
  elseif right_group ~= "" then
    -- Draw right group
    o = o .. "%#Crystalline" .. right_group .. "#"
  end

  -- End final tab
  if enable_mouse then
    o = o .. "%T"
  end

  return o
end

return module
