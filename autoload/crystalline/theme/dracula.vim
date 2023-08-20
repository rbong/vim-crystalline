function! crystalline#theme#dracula#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[16, 141], ['#282a36', '#bd93f9']],
        \ 'B':            [[15, 61],  ['#f8f8f2', '#5f6a8e']],
        \ 'Mid':          [[15, 236], ['#f8f8f2', '#44475a']],
        \ 'InactiveMid':  [[15, 236], ['#f8f8f2', '#44475a']],
        \ 'NormalModeA':  [[16, 141], ['#282a36', '#bd93f9']],
        \ 'InsertModeA':  [[16, 117], ['#8be9fd', '#282a36']],
        \ 'VisualModeA':  [[16, 84],  ['#282a36', '#50fa7b']],
        \ 'ReplaceModeA': [[16, 222], ['#282a36', '#ffc66d']],
        \ 'TabType':      [[16, 228], ['#282a36', '#f1fa8c']],
        \ 'Tab':          [[15, 61],  ['#f8f8f2', '#5f6a8e']],
        \ 'TabSel':       [[16, 141], ['#282a36', '#bd93f9'], 'term=bold cterm=bold gui=bold'],
        \ 'TabMid':       [[15, 236], ['#f8f8f2', '#44475a']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
