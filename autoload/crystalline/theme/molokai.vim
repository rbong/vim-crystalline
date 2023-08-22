function! crystalline#theme#molokai#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'B':                [[253, 16],  ['#f8f8f0', '#232526'], ''],
        \ 'Mid':              [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'Mid1':             [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'Tab1':             [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'InactiveA':        [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveB':        [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveMid':      [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveMid1':     [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'NormalModeMid1':   [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'NormalModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'CommandModeTab1':  [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'InsertModeA':      [[232, 81],  ['#080808', '#66d9ef'], ''],
        \ 'InsertModeMid1':   [[232, 81],  ['#080808', '#66d9ef'], ''],
        \ 'InsertModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'VisualModeA':      [[232, 118], ['#080808', '#a6e22e'], ''],
        \ 'VisualModeMid1':   [[232, 118], ['#080808', '#a6e22e'], ''],
        \ 'VisualModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'ReplaceModeA':     [[232, 161], ['#080808', '#f92672'], ''],
        \ 'ReplaceModeMid1':  [[232, 161], ['#080808', '#f92672'], ''],
        \ 'ReplaceModeTab1':  [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'TerminalModeTab1': [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
