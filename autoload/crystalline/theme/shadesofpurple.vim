function! crystalline#theme#shadesofpurple#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'InsertMode':  [[234, 10],  ['#1E1E3F', '#00FF00']],
        \ 'VisualMode':  [[234, 177], ['#1E1E3F', '#c991ff']],
        \ 'ReplaceMode': [[234, 204], ['#1E1E3F', '#FF628C']],
        \ '':            [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'Inactive':    [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'Fill':        [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'Tab':         [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'TabType':     [[140, 234], ['#A599E9', '#1E1E3F']],
        \ 'TabSel':      [[234, 140], ['#1E1E3F', '#A599E9']],
        \ 'TabFill':     [[140, 234], ['#A599E9', '#1E1E3F']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:

