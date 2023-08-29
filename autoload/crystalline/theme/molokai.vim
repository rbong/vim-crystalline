function! crystalline#theme#molokai#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':                [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'B':                [[253, 16],  ['#f8f8f0', '#232526'], ''],
        \ 'Fill':             [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'Fill1':            [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'Tab1':             [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'InactiveA':        [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveB':        [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveFill':     [[233, 67],  ['#1b1d1e', '#465457'], ''],
        \ 'InactiveFill1':    [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'NormalModeFill1':  [[232, 144], ['#080808', '#e6db74'], ''],
        \ 'NormalModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'CommandModeTab1':  [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'InsertModeA':      [[232, 81],  ['#080808', '#66d9ef'], ''],
        \ 'InsertModeFill1':  [[232, 81],  ['#080808', '#66d9ef'], ''],
        \ 'InsertModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'VisualModeA':      [[232, 118], ['#080808', '#a6e22e'], ''],
        \ 'VisualModeFill1':  [[232, 118], ['#080808', '#a6e22e'], ''],
        \ 'VisualModeTab1':   [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'ReplaceModeA':     [[232, 161], ['#080808', '#f92672'], ''],
        \ 'ReplaceModeFill1': [[232, 161], ['#080808', '#f92672'], ''],
        \ 'ReplaceModeTab1':  [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ 'TerminalModeTab1': [[253, 67],  ['#f8f8f0', '#465457'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
