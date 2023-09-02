function! crystalline#theme#dracula#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':                   [[236, 141], ['#282a36', '#bd93f9'], ''],
        \ 'B':                   [[253, 61],  ['#f8f8f2', '#6272a4'], ''],
        \ 'Fill':                [[253, 239], ['#f8f8f2', '#44475a'], ''],
        \ 'Fill1':               [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'TabFill1':            [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'InactiveA':           [[236, 61],  ['#282a36', '#6272a4'], ''],
        \ 'InactiveB':           [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'NormalModeFill1':     [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'NormalModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'InsertModeA':         [[236, 84],  ['#282a36', '#50fa7b'], ''],
        \ 'InsertModeFill1':     [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'InsertModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'VisualModeA':         [[236, 228], ['#282a36', '#f1fa8c'], ''],
        \ 'VisualModeFill1':     [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'VisualModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'ReplaceModeA':        [[236, 215], ['#282a36', '#ffb86c'], ''],
        \ 'ReplaceModeFill1':    [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'ReplaceModeTabFill1': [[253, 235], ['#f8f8f2', '#21222c'], ''],
        \ 'TerminalModeA':       [[236, 84],  ['#282a36', '#50fa7b'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
