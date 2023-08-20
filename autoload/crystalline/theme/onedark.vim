function! crystalline#theme#onedark#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[235, 114], ['#282c34', '#98c379']],
        \ 'B':            [[145, 236], ['#abb2bf', '#3e4452']],
        \ 'Mid':          [[114, 236], ['#98c379', '#282c34']],
        \ 'InactiveMid':  [[235, 145], ['#282c34', '#abb2bf']],
        \ 'NormalModeA':  [[235, 114], ['#282c34', '#98c379']],
        \ 'InsertModeA':  [[235, 39],  ['#282c34', '#61afef']],
        \ 'VisualModeA':  [[235, 170], ['#282c34', '#c678dd']],
        \ 'ReplaceModeA': [[235, 204], ['#282c34', '#e06c75']],
        \ 'TabType':      [[235, 170], ['#282C34', '#C678DD']],
        \ 'Tab':          [[145, 236], ['#abb2bf', '#3e4452']],
        \ 'TabSel':       [[235, 114], ['#282c34', '#98c379']],
        \ 'TabMid':       [[114, 236], ['#98c379', '#282c34']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
