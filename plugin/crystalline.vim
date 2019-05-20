scriptencoding utf-8

" Helper Variables {{{

let g:crystalline_mode_labels = {
      \ 'n': ' NORMAL ',
      \ 'i': ' INSERT ',
      \ 'v': ' VISUAL ',
      \ 'R': ' REPLACE ',
      \ '': '',
      \ }

let g:crystalline_mode_hi_groups = {
      \ 'n': 'NormalMode',
      \ 'i': 'InsertMode',
      \ 'v': 'VisualMode',
      \ 'R': 'ReplaceMode',
      \ '': '',
      \ }

if get(g:, 'crystalline_enable_sep', 0)
  let g:crystalline_default_supported_sep = {
        \ 'NormalMode': ['', 'Fill', 'TabFill', 'Tab'],
        \ 'InsertMode': ['', 'Fill', 'TabFill', 'Tab'],
        \ 'VisualMode': ['', 'Fill', 'TabFill', 'Tab'],
        \ 'ReplaceMode': ['', 'Fill', 'TabFill', 'Tab'],
        \ '': ['Fill'],
        \ 'Inactive': [],
        \ 'Fill': [],
        \ 'Tab': ['TabSel', 'TabFill', 'NormalMode', 'InsertMode', 'VisualMode', 'ReplaceMode'],
        \ 'TabType': ['Tab', 'TabSel', 'TabFill', 'NormalMode', 'InsertMode', 'VisualMode', 'ReplaceMode'],
        \ 'TabSel': ['Tab', 'TabFill'],
        \ 'TabFill': [],
        \ }
  if exists('g:crystalline_supported_sep')
    call extend(g:crystalline_supported_sep, g:crystalline_default_supported_sep, 'keep')
  else
    let g:crystalline_supported_sep = copy(g:crystalline_default_supported_sep)
  endif
endif

let g:crystalline_hi_groups = [
        \ 'NormalMode',
        \ 'InsertMode',
        \ 'VisualMode',
        \ 'ReplaceMode',
        \ '',
        \ 'Inactive',
        \ 'Fill',
        \ 'Tab',
        \ 'TabType',
        \ 'TabSel',
        \ 'TabFill',
        \ ]

if !exists('g:crystalline_separators')
  let g:crystalline_separators = ['', '']
endif

" }}}

" Load User Settings {{{

if exists('g:crystalline_tabline_fn')
  call crystalline#set_tabline(g:crystalline_tabline_fn)
endif

if exists('g:crystalline_statusline_fn')
  call crystalline#set_statusline(g:crystalline_statusline_fn)
endif

if exists('g:crystalline_theme')
  call crystalline#set_theme(g:crystalline_theme)
endif

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
