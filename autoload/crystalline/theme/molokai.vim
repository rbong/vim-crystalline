function! crystalline#theme#molokai#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[232, 144], ['#080808', '#e6db74']],
        \ 'B':            [[253, 16],  ['#f8f8f0', '#232526']],
        \ 'Mid':          [[253, 67],  ['#f8f8f0', '#465457']],
        \ 'InactiveMid':  [[233, 67],  ['#1b1d1e', '#465457']],
        \ 'NormalModeA':  [[232, 144], ['#080808', '#e6db74']],
        \ 'InsertModeA':  [[232, 81],  ['#080808', '#66d9ef']],
        \ 'VisualModeA':  [[232, 118], ['#080808', '#a6e22e']],
        \ 'ReplaceModeA': [[232, 161], ['#080808', '#f92672']],
        \ 'TabType':      [[232, 118], ['#080808', '#a6e22e']],
        \ 'Tab':          [[253, 16],  ['#f8f8f0', '#232526']],
        \ 'TabSel':       [[232, 144], ['#080808', '#e6db74']],
        \ 'TabMid':       [[253, 67],  ['#f8f8f0', '#465457']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
