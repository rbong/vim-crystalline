function! crystalline#theme#dracula#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                   [[236, 141], ['#282a36', '#BD93F9'], ''],
        \ 'B':                   [[253, 61],  ['#f8f8f2', '#6272A4'], ''],
        \ 'Fill':                [[253, 239], ['#f8f8f2', '#44475A'], ''],
        \ 'Fill1':               [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'TabFill1':            [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InactiveA':           [[236, 61],  ['#282a36', '#6272A4'], ''],
        \ 'InactiveB':           [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'NormalModeFill1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'NormalModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InsertModeA':         [[236, 84],  ['#282a36', '#50FA7B'], ''],
        \ 'InsertModeFill1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InsertModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'VisualModeA':         [[236, 228], ['#282a36', '#F1FA8C'], ''],
        \ 'VisualModeFill1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'VisualModeTabFill1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'ReplaceModeA':        [[236, 215], ['#282a36', '#FFB86C'], ''],
        \ 'ReplaceModeFill1':    [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'ReplaceModeTabFill1': [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'TerminalModeA':       [[236, 84],  ['#282a36', '#50FA7B'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
