scriptencoding utf-8

runtime plugin/crystalline.vim

describe 'crystalline'
  after
    " Unload files
    %bd
    " Clear statusline/tabline
    call crystalline#ClearStatusline()
    call crystalline#ClearTabline()
    " Clear options
    delfunction! g:CrystallineStatuslineFn
    unlet! g:CrystallineStatuslineFn
    delfunction! g:CrystallineTablineFn
    unlet! g:CrystallineTablineFn
    delfunction! g:CrystallineTabFn
    unlet! g:CrystallineTabFn
    delfunction! g:CrystallineHideBufferFn
    unlet! g:CrystallineHideBufferFn
    unlet! g:crystalline_separators
    unlet! g:crystalline_auto_prefix_groups
    unlet! g:crystalline_group_suffix
    " Reset settings
    runtime plugin/crystalline.vim
  end

  it 'does not overwrite settings by default'
    Expect &statusline ==# ''
    Expect &tabline ==# ''
  end

  it 'sets the statusline'
    function! g:CrystallineStatuslineFn(winnr)
      return '__STATUSLINE__:' . a:winnr
    endfunction
    source plugin/crystalline.vim
    Expect &statusline ==# '%!crystalline#GetStatusline(1000)'
    Expect crystalline#GetStatusline(1000) ==# '__STATUSLINE__:1'
  end

  it 'sets the tabline'
    function! g:CrystallineTablineFn()
      return '__TABLINE__'
    endfunction
    source plugin/crystalline.vim
    Expect &tabline ==# '%!crystalline#GetTabline()'
    Expect crystalline#GetTabline() ==# '__TABLINE__'
  end

  it 'draws default separators'
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineAToB#%#CrystallineB#'
    Expect crystalline#Sep(0, 'A', 'A') ==# ''
    Expect crystalline#Sep(1, 'A', 'B') ==# '%#CrystallineBToA#%#CrystallineB#'
    Expect crystalline#Sep(1, 'A', 'A') ==# ''
  end

  it 'draws custom separators'
    let g:crystalline_separators = [
          \ { 'ch': '>', 'alt_ch': ')', 'dir': '>' },
          \ { 'ch': '<', 'alt_ch': '(', 'dir': '<' }
          \ ]
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineAToB#>%#CrystallineB#'
    Expect crystalline#Sep(0, 'A', 'A') ==# ')'
    Expect crystalline#Sep(1, 'A', 'B') ==# '%#CrystallineBToA#<%#CrystallineB#'
    Expect crystalline#Sep(1, 'A', 'A') ==# '('
  end

  it 'adds the current mode to groups'
    Expect crystalline#ModeGroup('A') ==# 'CommandModeA'
  end

  it 'draws tabs'
    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3

    normal 2gt
    Expect crystalline#DefaultTabline() ==# '%#CrystallineTabType# TABS '
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%#CrystallineTabSel#%2T /t/2 '
          \ . '%#CrystallineTab#%3T /t/3 '
          \ . '%#CrystallineTabFill#%T'
  end

  it 'draws buffers'
    e /tmp/1
    try
      bd! #
    catch /.*/
    endtry
    e /tmp/2
    e /tmp/3

    buffer /tmp/2
    Expect crystalline#DefaultTabline() ==# '%#CrystallineTabType# BUFFERS '
          \ . '%#CrystallineTab# /t/1 '
          \ . '%#CrystallineTabSel# /t/2 '
          \ . '%#CrystallineTab# /t/3 '
          \ . '%#CrystallineTabFill#'
  end

  it 'draws tabs with separators'
    e /tmp/1
    for l:i in range(2, 5)
      exec 'tabe /tmp/' . l:i
    endfor

    normal 1gt
    Expect crystalline#DefaultTabline({ 'enable_sep': 1 }) ==# '%#CrystallineTabType# TABS %#CrystallineTabTypeToTabSel#'
          \ . '%#CrystallineTabSel#%1T /t/1 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%2T /t/2 '
          \ . '%3T /t/3 '
          \ . '%4T /t/4 '
          \ . '%5T /t/5 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    normal 2gt
    Expect crystalline#DefaultTabline({ 'enable_sep': 1 }) ==# '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%2T /t/2 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%3T /t/3 '
          \ . '%4T /t/4 '
          \ . '%5T /t/5 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    normal 4gt
    Expect crystalline#DefaultTabline({ 'enable_sep': 1 }) ==# '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 '
          \ . '%3T /t/3 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%4T /t/4 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%5T /t/5 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    normal 5gt
    Expect crystalline#DefaultTabline({ 'enable_sep': 1 }) ==# '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 '
          \ . '%3T /t/3 '
          \ . '%4T /t/4 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%5T /t/5 %#CrystallineTabSelToTabFill#'
          \ . '%#CrystallineTabFill#%T'
  end

  it 'allows custom tabs'
    unlet! g:CrystallineTabFn
    function! g:CrystallineTabFn(tabnr, bufnr, max_width, is_sel) abort
      return [' tab ', 5]
    endfunction

    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3
    Expect crystalline#Tabs({ 'enable_mouse': 0 }) ==# '%#CrystallineTab# tab  tab %#CrystallineTabSel# tab %#CrystallineTabFill#'
  end

  it 'does not exceed max width'
    e /tmp/1
    for l:i in range(2, 5)
      exec 'tabe /tmp/' . l:i
    endfor
    normal 3gt

    let l:five_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 '
          \ . '%5T /t/5 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:four_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:three_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:two_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:one_tab = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTabFill#'
          \ . '%#CrystallineTabFill#%T'

    " Tabline: ' TABS > /t/1 > /t/2 > /t/3 > /t/4 > /t/5 >'
    "   Width:  1        10        20        30        40
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 42 }) ==# l:five_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 41 }) ==# l:four_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 35 }) ==# l:four_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 34 }) ==# l:three_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 28 }) ==# l:three_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 27 }) ==# l:two_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 21 }) ==# l:two_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 20 }) ==# l:one_tab
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_width': 0 }) ==# l:one_tab
  end

  it 'does not exceed max tabs'
    e /tmp/1
    for l:i in range(2, 5)
      exec 'tabe /tmp/' . l:i
    endfor
    normal 3gt

    let l:five_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 '
          \ . '%5T /t/5 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:four_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%1T /t/1 '
          \ . '%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:three_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab#%4T /t/4 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:two_tabs = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#'
          \ . '%#CrystallineTab#%2T /t/2 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTabFill#'
          \ . '%#CrystallineTabFill#%T'
    let l:one_tab = '%#CrystallineTabType# TABS %#CrystallineTabTypeToTabSel#'
          \ . '%#CrystallineTabSel#%3T /t/3 %#CrystallineTabSelToTabFill#'
          \ . '%#CrystallineTabFill#%T'

    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 6 }) ==# l:five_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 5 }) ==# l:five_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 4 }) ==# l:four_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 3 }) ==# l:three_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 2 }) ==# l:two_tabs
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 1 }) ==# l:one_tab
    Expect crystalline#DefaultTabline({ 'enable_sep': 1, 'max_tabs': 0 }) ==# l:one_tab
  end

  it 'does not modify groups by default'
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineAToB#%#CrystallineB#'
    Expect crystalline#HiItem('A') ==# '%#CrystallineA#'

    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3
    normal 2gt
    Expect crystalline#Tabs({ 'enable_mouse': 0, 'enable_sep': 1 }) ==# '%#CrystallineTab# /t/1 %#CrystallineTabToTabSel#'
          \ . '%#CrystallineTabSel# /t/2 %#CrystallineTabSelToTab#'
          \ . '%#CrystallineTab# /t/3 %#CrystallineTabToTabFill#'
          \ . '%#CrystallineTabFill#'
  end

  it 'auto-prefixes mode'
    let g:crystalline_auto_prefix_groups = 1
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineCommandModeAToCommandModeB#%#CrystallineCommandModeB#'
    Expect crystalline#HiItem('A') ==# '%#CrystallineCommandModeA#'

    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3
    normal 2gt
    Expect crystalline#Tabs({ 'enable_mouse': 0, 'enable_sep': 1 }) ==# '%#CrystallineCommandModeTab# /t/1 %#CrystallineCommandModeTabToCommandModeTabSel#'
          \ . '%#CrystallineCommandModeTabSel# /t/2 %#CrystallineCommandModeTabSelToCommandModeTab#'
          \ . '%#CrystallineCommandModeTab# /t/3 %#CrystallineCommandModeTabToCommandModeTabFill#'
          \ . '%#CrystallineCommandModeTabFill#'
  end

  it 'auto-prefixes inactive'
    let g:crystalline_auto_prefix_groups = 1
    let g:crystalline_inactive = 1
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineInactiveAToInactiveB#%#CrystallineInactiveB#'
    Expect crystalline#HiItem('A') ==# '%#CrystallineInactiveA#'

    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3
    normal 2gt
    Expect crystalline#Tabs({ 'enable_mouse': 0, 'enable_sep': 1 }) ==# '%#CrystallineCommandModeTab# /t/1 %#CrystallineCommandModeTabToCommandModeTabSel#'
          \ . '%#CrystallineCommandModeTabSel# /t/2 %#CrystallineCommandModeTabSelToCommandModeTab#'
          \ . '%#CrystallineCommandModeTab# /t/3 %#CrystallineCommandModeTabToCommandModeTabFill#'
          \ . '%#CrystallineCommandModeTabFill#'
  end

  it 'adds group suffix'
    let g:crystalline_group_suffix = '1'
    Expect crystalline#Sep(0, 'A', 'B') ==# '%#CrystallineA1ToB1#%#CrystallineB1#'
    Expect crystalline#HiItem('A') ==# '%#CrystallineA1#'

    e /tmp/1
    tabe /tmp/2
    tabe /tmp/3
    normal 2gt
    Expect crystalline#Tabs({ 'enable_mouse': 0, 'enable_sep': 1, 'group_suffix': '1' }) ==# '%#CrystallineTab1# /t/1 %#CrystallineTab1ToTabSel1#'
          \ . '%#CrystallineTabSel1# /t/2 %#CrystallineTabSel1ToTab1#'
          \ . '%#CrystallineTab1# /t/3 %#CrystallineTab1ToTabFill1#'
          \ . '%#CrystallineTabFill1#'
  end
end

" vim:set et sw=2 ts=2 fdm=marker:
