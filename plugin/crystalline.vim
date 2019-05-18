if get(g:, 'crystalline_enable_bufferline', 0) == 1
  call crystalline#enable_bufferline()
endif

if exists('g:crystalline_set_statusline_fn')
  call crystalline#set_statusline(g:crystalline_set_statusline_fn)
endif

if exists('g:crystalline_theme')
  call crystalline#set_theme(g:crystalline_theme)
endif

" vim:set et sw=2 ts=2 fdm=marker:
