" Load User Settings {{{

if exists('g:crystalline_tabline_fn')
  call crystalline#set_tabline(g:crystalline_tabline_fn)
endif

if exists('g:crystalline_statusline_fn')
  call crystalline#set_statusline(g:crystalline_statusline_fn)
endif

" }}}

" Helper Variables {{{

let g:crystalline_mode_colors = {
      \ 'n': '%#CrystallineNormalMode#',
      \ 'i': '%#CrystallineInsertMode#',
      \ 'v': '%#CrystallineVisualMode#',
      \ '': '',
      \ }

let g:crystalline_mode_labels = {
      \ 'n': ' NORMAL ',
      \ 'i': ' INSERT ',
      \ 'v': ' VISUAL ',
      \ '': '',
      \ }

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
