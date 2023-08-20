function! crystalline#theme#shadesofpurple#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'B':            [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'Mid':          [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'InactiveMid':  [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'NormalModeA':  [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'InsertModeA':  [[234, 10],  ['#1E1E3F', '#00FF00']],
        \ 'VisualModeA':  [[234, 177], ['#1E1E3F', '#c991ff']],
        \ 'ReplaceModeA': [[234, 204], ['#1E1E3F', '#FF628C']],
        \ 'TabType':      [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'Tab':          [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'TabSel':       [[234, 226], ['#1E1E3F', '#FAD000']],
        \ 'TabMid':       [[140, 234], ['#A599E9', '#1E1E3F']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:

