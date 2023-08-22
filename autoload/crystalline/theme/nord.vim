function! crystalline#theme#nord#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[0, 6],  ['#3b4252', '#88C0D0'], ''],
        \ 'B':            [[0, 4],  ['#3b4252', '#81A1C1'], ''],
        \ 'Mid':          [[7, 8],  ['#e5e9f0', '#4C566A'], ''],
        \ 'InactiveA':    [[7, 8],  ['#e5e9f0', '#4C566A'], ''],
        \ 'InactiveB':    [[7, 8],  ['#e5e9f0', '#4C566A'], ''],
        \ 'InactiveMid':  [[7, 0],  ['#e5e9f0', '#3B4252'], ''],
        \ 'InsertModeA':  [[0, 15], ['#3b4252', '#A3BE8C'], ''],
        \ 'VisualModeA':  [[0, 14], ['#3b4252', '#8FBCBB'], ''],
        \ 'ReplaceModeA': [[0, 2],  ['#3b4252', '#A3BE8C'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
