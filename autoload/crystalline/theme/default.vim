function! crystalline#theme#default#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[17,  190], ['#00005f', '#dfff00']],
        \ 'InsertMode':  [[17,  45],  ['#00005f', '#00dfff']],
        \ 'VisualMode':  [[232, 214], ['#000000', '#ffaf00']],
        \ 'ReplaceMode': [[255, 124], ['#ffffff', '#af0000']],
        \ '':            [[255, 238], ['#ffffff', '#444444']],
        \ 'Inactive':    [[239, 234], ['#4e4e4e', '#1c1c1c']],
        \ 'Fill':        [[85,  234], ['#9cffd3', '#202020']],
        \ 'Tab':         [[255, 238], ['#ffffff', '#444444']],
        \ 'TabType':     [[232, 214], ['#000000', '#ffaf00']],
        \ 'TabSel':      [[17,  190], ['#00005f', '#dfff00']],
        \ 'TabFill':     [[85,  234], ['#9cffd3', '#202020']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
