function! crystalline#theme#solarized#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'A':            [[230, 245], ['#fdf6e3', '#93a1a1'], 'term=bold cterm=bold gui=bold'],
          \ 'B':            [[254, 241], ['#eee8d5', '#657b83']],
          \ 'Mid':          [[240, 235], ['#586e75', '#073642']],
          \ 'InactiveMid':  [[235, 241], ['#073642', '#657b83']],
          \ 'NormalModeA':  [[230, 245], ['#fdf6e3', '#93a1a1'], 'term=bold cterm=bold gui=bold'],
          \ 'InsertModeA':  [[230, 136], ['#fdf6e3', '#b58900'], 'term=bold cterm=bold gui=bold'],
          \ 'VisualModeA':  [[230, 125], ['#fdf6e3', '#d33682'], 'term=bold cterm=bold gui=bold'],
          \ 'ReplaceModeA': [[230, 160], ['#fdf6e3', '#dc322f'], 'term=bold cterm=bold gui=bold'],
          \ 'TabType':      [[254, 241], ['#eee8d5', '#657b83']],
          \ 'Tab':          [[254, 241], ['#eee8d5', '#657b83']],
          \ 'TabSel':       [[230, 245], ['#fdf6e3', '#93a1a1'], 'term=bold cterm=bold gui=bold'],
          \ 'TabMid':       [[240, 235], ['#586e75', '#073642']],
          \ })
  else
    call crystalline#generate_theme({
          \ 'A':            [[254, 241], ['#eee8d5', '#657b83'], 'term=bold cterm=bold gui=bold'],
          \ 'B':            [[254, 245], ['#eee8d5', '#93a1a1']],
          \ 'Mid':          [[245, 254], ['#93a1a1', '#eee8d5']],
          \ 'InactiveMid':  [[254, 244], ['#eee8d5', '#839496']],
          \ 'NormalModeA':  [[254, 241], ['#eee8d5', '#657b83'], 'term=bold cterm=bold gui=bold'],
          \ 'InsertModeA':  [[254, 136], ['#eee8d5', '#b58900'], 'term=bold cterm=bold gui=bold'],
          \ 'VisualModeA':  [[254, 125], ['#eee8d5', '#d33682'], 'term=bold cterm=bold gui=bold'],
          \ 'ReplaceModeA': [[254, 160], ['#eee8d5', '#dc322f'], 'term=bold cterm=bold gui=bold'],
          \ 'TabType':      [[254, 245], ['#eee8d5', '#93a1a1']],
          \ 'Tab':          [[254, 245], ['#eee8d5', '#93a1a1']],
          \ 'TabSel':       [[254, 241], ['#eee8d5', '#657b83'], 'term=bold cterm=bold gui=bold'],
          \ 'TabMid':       [[245, 254], ['#93a1a1', '#eee8d5']],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
