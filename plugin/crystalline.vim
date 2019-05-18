if get(g:, 'crystalline_enable_bufferline', 0) == 1
  call crystalline#enable_bufferline()
endif

if exists('g:crystalline_set_statusline_fn')
  call crystalline#set_statusline(g:crystalline_set_statusline_fn)
endif

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

" vim:set et sw=2 ts=2 fdm=marker:
