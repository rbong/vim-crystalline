function! crystalline#theme#hybrid#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'A':            [[193, 65],  ['#d7ffaf', '#5F875F'], 'term=bold cterm=bold gui=bold'],
          \ 'B':            [[250, 235], ['#c5c8c6', '#282a2e']],
          \ 'Mid':          [[250, 237], ['#c5c8c6', '#373b41']],
          \ 'InactiveMid':  [[243, 236], ['#707880', '#303030']],
          \ 'NormalModeA':  [[193, 65],  ['#d7ffaf', '#5F875F'], 'term=bold cterm=bold gui=bold'],
          \ 'InsertModeA':  [[250, 110], ['#c5c8c6', '#81a2be'], 'term=bold cterm=bold gui=bold'],
          \ 'VisualModeA':  [[250, 167], ['#c5c8c6', '#cc6666'], 'term=bold cterm=bold gui=bold'],
          \ 'ReplaceModeA': [[189, 60],  ['#d7d7ff', '#5F5F87'], 'term=bold cterm=bold gui=bold'],
          \ 'TabType':      [[250, 167], ['#c5c8c6', '#cc6666']],
          \ 'Tab':          [[250, 235], ['#c5c8c6', '#282a2e']],
          \ 'TabSel':       [[193, 65],  ['#d7ffaf', '#5F875F']],
          \ 'TabMid':       [[250, 237], ['#c5c8c6', '#373b41']],
          \ })
  else
    call crystalline#generate_theme({
          \ 'A':            [[22, 194], ['#005f00', '#d7ffd7'], 'term=bold cterm=bold gui=bold'],
          \ 'B':            [[16, 252], ['#000000', '#d0d0d0']],
          \ 'Mid':          [[16, 250], ['#000000', '#bcbcbc']],
          \ 'InactiveMid':  [[59, 247], ['#5f5f5f', '#9e9e9e']],
          \ 'NormalModeA':  [[22, 194], ['#005f00', '#d7ffd7'], 'term=bold cterm=bold gui=bold'],
          \ 'InsertModeA':  [[16, 17],  ['#000000', '#00005f'], 'term=bold cterm=bold gui=bold'],
          \ 'VisualModeA':  [[16, 224], ['#000000', '#ffd7d7'], 'term=bold cterm=bold gui=bold'],
          \ 'ReplaceModeA': [[53, 189], ['#5f005f', '#d7d7ff'], 'term=bold cterm=bold gui=bold'],
          \ 'TabType':      [[16, 224], ['#000000', '#ffd7d7']],
          \ 'Tab':          [[16, 252], ['#000000', '#d0d0d0']],
          \ 'TabSel':       [[22, 194], ['#005f00', '#d7ffd7']],
          \ 'TabMid':       [[16, 250], ['#000000', '#bcbcbc']],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
