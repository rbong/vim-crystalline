scriptencoding utf-8

function! DefaultLine(...)
  return '__DEFAULT__ %f'
endfunction

function! CurrentStatusLine(current)
  return '__CURRENT__ ' . a:current
endfunction

function! WidthStatusLine(current, width)
  return '__WIDTH__ ' . a:width
endfunction

function! LoadCrystalline()
endfunction

function! CleanCrystalline()
  unlet! g:crystalline_statusline_fn
  unlet! g:crystalline_tabline_fn
  unlet! g:crystalline_theme
  unlet! g:crystalline_enable_sep
  unlet! g:crystalline_mode
  unlet! g:crystalline_separators
  unlet! g:crystalline_tab_separator
  call crystalline#clear_statusline()
  call crystalline#clear_tabline()
  call crystalline#clear_theme()
  hi clear
endfunction

describe 'g:crystalline_statusline_fn'
  before
    let g:crystalline_statusline_fn = 'DefaultLine'
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'sets the statusline'
    Expect &statusline ==# '%!crystalline#get_statusline(1,' . win_getid() . ')'
  end

  it 'defines an autogroup'
    Expect exists('#CrystallineAutoStatusline') == 1
  end
end

describe 'g:crystalline_tabline_fn'
  before
    let g:crystalline_tabline_fn = 'DefaultLine'
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'sets the tabline'
    Expect &tabline ==# '%!crystalline#get_tabline()'
  end

  it 'defines an autogroup'
    Expect exists('#CrystallineAutoTabline') == 1
  end
end

describe 'g:crystalline_theme'
  before
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'loads the "default" theme by default'
    Expect g:crystalline_theme ==# 'default'
  end

  it 'defines highlight groups'
    hi CrystallineNormalMode
    hi CrystallineInsertMode
    hi CrystallineVisualMode
    hi CrystallineReplaceMode
    hi Crystalline
    hi CrystallineInactive
    hi CrystallineFill
    hi CrystallineTab
    hi CrystallineTabType
    hi CrystallineTabSel
    hi CrystallineTabFill
  end
end

describe 'g:crystalline_*_separator(s)'
  before
    let g:crystalline_enable_sep = 1
  end

  after
    call CleanCrystalline()
  end

  it 'sets the default separators'
    source plugin/crystalline.vim
    Expect g:crystalline_separators == ['', '']
    Expect g:crystalline_tab_separator ==# ''
  end

  it 'allows overriding separators'
    let g:crystalline_separators = ['>', '<']
    let g:crystalline_tab_separator = '-'
    source plugin/crystalline.vim
    Expect g:crystalline_separators == ['>', '<']
    Expect g:crystalline_tab_separator ==# '-'
  end
end

describe 'crystalline#get_statusline'
  before
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
    augroup Test
      au!
    augroup END
  end

  it 'returns the statusline setting'
    let g:crystalline_statusline_fn = 'DefaultLine'
    Expect crystalline#get_statusline(1, 0) ==# '__DEFAULT__ %f'
  end

  it 'passes the current window'
    let g:crystalline_statusline_fn = 'CurrentStatusLine'
    Expect crystalline#get_statusline(1, 0) ==# '__CURRENT__ 1'
    Expect crystalline#get_statusline(0, 0) ==# '__CURRENT__ 0'
  end

  it 'passes the window width'
    let g:crystalline_statusline_fn = 'WidthStatusLine'
    Expect crystalline#get_statusline(0, 0) ==# '__WIDTH__ ' . winwidth(0)
  end

  it 'triggers a mode update'
    let g:crystalline_statusline_fn = 'DefaultLine'
    let g:test_mode = ''
    augroup Test
      au!
      au User CrystallineModeUpdate let g:test_mode = g:crystalline_mode
    augroup END
    call crystalline#get_statusline(0, 0)
    Expect g:test_mode ==# 'n'
  end
end

describe 'crystalline#get_tabline'
  before
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'returns the tabline setting'
    let g:crystalline_tabline_fn = 'DefaultLine'
    Expect crystalline#get_tabline() ==# '__DEFAULT__ %f'
  end
end

describe 'crystalline#mode'
  before
    new
    source plugin/crystalline.vim
  end

  after
    close!
    call CleanCrystalline()
  end

  it 'returns the current mode'
    Expect crystalline#mode() ==# '%#CrystallineNormalMode# NORMAL '
    exe "normal! i\<c-r>=crystalline#mode()\<cr>"
    Expect getline(1) ==# '%#CrystallineInsertMode# INSERT '
    exe "normal! V\"=crystalline#mode()\<cr>p"
    Expect getline(1) ==# '%#CrystallineVisualMode# VISUAL '
    exe "normal! 0R\<c-r>=crystalline#mode()\<cr>"
    Expect getline(1) ==# '%#CrystallineReplaceMode# REPLACE '
  end
end

describe 'crystalline#sep'
  before
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'returns next group when separators disabled'
    Expect crystalline#sep('', 'Fill', '>', 0) ==# '%#CrystallineFill#'
    Expect crystalline#sep('', 'Fill', '<', 1) ==# '%#Crystalline#'
  end

  it 'returns separators when enabled'
    let g:crystalline_enable_sep = 1
    Expect crystalline#sep('', 'Fill', '>', 0) ==# '%#CrystallineToFill#>%#CrystallineFill#'
    Expect crystalline#sep('', 'Fill', '<', 1) ==# '%#CrystallineToFill#<%#Crystalline#'
  end

  it 'automatically creates nonexistent separator highlight groups'
    let g:crystalline_enable_sep = 1
    Expect crystalline#sep('', 'Fill', '>', 0) ==# '%#CrystallineToFill#>%#CrystallineFill#'
    Expect crystalline#sep('Fill', '', '>', 0) ==# '%#CrystallineFillToLine#>%#Crystalline#'
    hi CrystallineToFill
    hi CrystallineFillToLine
  end

  it 'dynamically creates separator highlight groups'
    let g:crystalline_enable_sep = 1
    hi CrystallineTestGroupA ctermfg=1 ctermbg=2 guifg=#111111 guibg=#222222
    hi CrystallineTestGroupB ctermfg=3 ctermbg=4 guifg=#333333 guibg=#444444
    Expect crystalline#sep('TestGroupA', 'TestGroupB', '>', 0) ==# '%#CrystallineTestGroupAToTestGroupB#>%#CrystallineTestGroupB#'
    hi CrystallineTestGroupAToTestGroupB
    let attrs = crystalline#synIDattrs('CrystallineTestGroupAToTestGroupB')
    Expect attrs.cterm.fg == '2'
    Expect attrs.cterm.bg == '4'
    Expect attrs.gui.fg == '#222222'
    Expect attrs.gui.bg == '#444444'
  end

  it 'adds separator highlight groups to g:crystalline_sep_hi_groups'
    let g:crystalline_enable_sep = 1
    Expect g:crystalline_sep_hi_groups == {}
    call crystalline#sep('', 'Fill', '>', 0)
    Expect g:crystalline_sep_hi_groups == {'ToFill': ['', 'Fill']}
  end

end

describe 'crystalline#apply_current_theme'
  before
    set background=dark
    let g:crystalline_enable_sep = 1
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'recomputes separator highlight groups'
    call crystalline#sep('', 'Fill', '>', 0)
    let attrs = crystalline#synIDattrs('CrystallineToFill')
    Expect attrs == {'gui': {'bg': '#202020', 'fg': '#444444', 'attrs': [], 'sp': 'NONE'}, 'term': {'attrs': []}, 'cterm': {'bg': '234', 'fg': '238', 'attrs': []}}

    let g:crystalline_theme = 'gruvbox'
    call crystalline#apply_current_theme()

    call crystalline#sep('', 'Fill', '>', 0)
    let attrs = crystalline#synIDattrs('CrystallineToFill')
    Expect attrs == {'gui': {'bg': '#3c3836', 'fg': '#504945', 'attrs': [], 'sp': 'NONE'}, 'term': {'attrs': []}, 'cterm': {'bg': '237', 'fg': '239', 'attrs': []}}
  end

  it 'empties out g:crystalline_sep_hi_groups'
    call crystalline#sep('', 'Fill', '>', 0)
    call crystalline#apply_current_theme()
    Expect g:crystalline_sep_hi_groups == {}
  end

end

describe 'crystalline#synIDattrs'
  before
    source plugin/crystalline.vim
  end

  after
    call CleanCrystalline()
  end

  it 'returns correct values'
    hi TestHighlightGroup
          \ ctermfg=1 ctermbg=2
          \ guifg=green guibg=#222222 guisp=#333333
          \ term=bold
          \ cterm=bold,italic,strikethrough
          \ gui=reverse,standout,underline
    let attrs = crystalline#synIDattrs('TestHighlightGroup')
    Expect attrs.cterm.fg == '1'
    Expect attrs.cterm.bg == '2'
    Expect attrs.gui.fg == 'green'
    Expect attrs.gui.bg == '#222222'
    Expect attrs.gui.sp == '#333333'
    Expect sort(attrs.term.attrs) == ['bold']
    Expect sort(attrs.cterm.attrs) == ['bold', 'italic', 'strikethrough']
    Expect sort(attrs.gui.attrs) == ['reverse', 'standout', 'underline']
  end

end

describe 'crystalline#bufferline'
  before
    source plugin/crystalline.vim
    %bd!
  end

  after
    call CleanCrystalline()
    %bd!
  end

  it 'returns buffers when there is one tab'
    edit a
    edit b
    edit c
    bprev
    Expect crystalline#bufferline(0, 0, 0) == '%#CrystallineTabType# BUFFERS %#CrystallineTab# a %#CrystallineTabSel# b %#CrystallineTab# c %#CrystallineTabFill#'
  end

  it 'returns tabs when there is more than one'
    edit a
    tabedit b
    tabedit c
    tabprev
    Expect crystalline#bufferline(0, 0, 0) == '%#CrystallineTabType# TABS %#CrystallineTab#%1T a %#CrystallineTabSel#%2T b %#CrystallineTab#%3T c %#CrystallineTabFill#%T'
  end

  it 'includes separators when enabled'
    let g:crystalline_enable_sep = 1
    edit a
    tabedit b
    tabedit c
    Expect crystalline#bufferline(0, 0, 0) == '%#CrystallineTabType# TABS %#CrystallineTabTypeToTab#%#CrystallineTab#%1T a %2T b %#CrystallineTabToTabSel#%#CrystallineTabSel#%3T c %#CrystallineTabSelToTabFill#%#CrystallineTabFill#%T'
  end

  it 'shows the current mode when enabled'
    edit a
    edit b
    Expect crystalline#bufferline(0, 0, 1) == '%#CrystallineTabType# BUFFERS %#CrystallineTab# a %#CrystallineNormalMode# b %#CrystallineTabFill#'
    exec "normal i\<c-r>=crystalline#bufferline(0, 0, 1)\<cr>"
    Expect getline(1) ==# '%#CrystallineTabType# BUFFERS %#CrystallineTab# a %#CrystallineInsertMode# b %#CrystallineTabFill#'
  end
end

" vim:set et sw=2 ts=2 fdm=marker:
