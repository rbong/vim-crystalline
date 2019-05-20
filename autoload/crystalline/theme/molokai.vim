function! crystalline#theme#molokai#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[232, 144], ['#080808', '#e6db74']],
        \ 'InsertMode':  [[232, 81],  ['#080808', '#66d9ef']],
        \ 'VisualMode':  [[232, 118], ['#080808', '#a6e22e']],
        \ 'ReplaceMode': [[232, 161], ['#080808', '#f92672']],
        \ '':            [[253, 16],  ['#f8f8f0', '#232526']],
        \ 'Inactive':    [[233, 67],  ['#1b1d1e', '#465457']],
        \ 'Fill':        [[253, 67],  ['#f8f8f0', '#465457']],
        \ 'Tab':         [[253, 16],  ['#f8f8f0', '#232526']],
        \ 'TabType':     [[253, 16],  ['#f8f8f0', '#232526']],
        \ 'TabSel':      [[232, 144], ['#080808', '#e6db74']],
        \ 'TabFill':     [[253, 67],  ['#f8f8f0', '#465457']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
