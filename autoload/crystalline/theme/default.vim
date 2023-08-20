function! crystalline#theme#default#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[17,  190], ['#00005f', '#dfff00']],
        \ 'B':            [[255, 238], ['#ffffff', '#444444']],
        \ 'Mid':          [[85,  234], ['#9cffd3', '#202020']],
        \ 'InactiveMid':  [[239, 234], ['#4e4e4e', '#1c1c1c']],
        \ 'NormalModeA':  [[17,  190], ['#00005f', '#dfff00']],
        \ 'InsertModeA':  [[17,  45],  ['#00005f', '#00dfff']],
        \ 'VisualModeA':  [[232, 214], ['#000000', '#ffaf00']],
        \ 'ReplaceModeA': [[255, 124], ['#ffffff', '#af0000']],
        \ 'TabType':      [[232, 214], ['#000000', '#ffaf00']],
        \ 'Tab':          [[255, 238], ['#ffffff', '#444444']],
        \ 'TabSel':       [[17,  190], ['#00005f', '#dfff00']],
        \ 'TabMid':       [[85,  234], ['#9cffd3', '#202020']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
