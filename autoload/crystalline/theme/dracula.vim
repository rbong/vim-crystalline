function! crystalline#theme#dracula#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[16, 141], ['#282a36', '#bd93f9']],
        \ 'InsertMode':  [[16, 117], ['#8be9fd', '#282a36']],
        \ 'VisualMode':  [[16, 84],  ['#282a36', '#50fa7b']],
        \ 'ReplaceMode': [[16, 222], ['#282a36', '#ffc66d']],
        \ '':            [[15, 61],  ['#f8f8f2', '#5f6a8e']],
        \ 'Inactive':    [[15, 236], ['#f8f8f2', '#44475a']],
        \ 'Fill':        [[15, 236], ['#f8f8f2', '#44475a']],
        \ 'Tab':         [[15, 61],  ['#f8f8f2', '#5f6a8e']],
        \ 'TabType':     [[15, 61],  ['#f8f8f2', '#5f6a8e']],
        \ 'TabSel':      [[16, 141], ['#282a36', '#bd93f9'], 'term=bold cterm=bold gui=bold'],
        \ 'TabFill':     [[15, 236], ['#f8f8f2', '#44475a']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
