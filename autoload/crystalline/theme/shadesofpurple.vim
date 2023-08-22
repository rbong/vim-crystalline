function! crystalline#theme#shadesofpurple#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[10,  236], ['#00ff00', '#2d2b55'], ''],
        \ 'B':            [[195, 234], ['#e1efff', '#1e1e3f'], ''],
        \ 'Mid':          [[140, 235], ['#a599e9', '#1f1f41'], ''],
        \ 'InactiveA':    [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'InactiveB':    [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'InactiveMid':  [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'InsertModeA':  [[195, 236], ['#e1efff', '#2d2b55'], 'bold'],
        \ 'VisualModeA':  [[195, 236], ['#e1efff', '#2d2b55'], 'bold'],
        \ 'ReplaceModeA': [[214, 236], ['#ff9d00', '#2d2b55'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:

