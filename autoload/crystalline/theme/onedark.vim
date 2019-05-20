function! crystalline#theme#onedark#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[235, 114], ['#282c34', '#98c379']],
        \ 'InsertMode':  [[235, 39],  ['#282c34', '#61afef']],
        \ 'VisualMode':  [[235, 170], ['#282c34', '#c678dd']],
        \ 'ReplaceMode': [[235, 204], ['#282c34', '#e06c75']],
        \ '':            [[145, 236], ['#abb2bf', '#3e4452']],
        \ 'Inactive':    [[235, 145], ['#282c34', '#abb2bf']],
        \ 'Fill':        [[114, 236], ['#98c379', '#282c34']],
        \ 'Tab':         [[145, 236], ['#abb2bf', '#3e4452']],
        \ 'TabType':     [[145, 236], ['#abb2bf', '#3e4452']],
        \ 'TabSel':      [[235, 114], ['#282c34', '#98c379']],
        \ 'TabFill':     [[114, 236], ['#98c379', '#282c34']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
