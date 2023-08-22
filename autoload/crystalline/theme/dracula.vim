function! crystalline#theme#dracula#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                  [[236, 141], ['#282a36', '#BD93F9'], ''],
        \ 'B':                  [[253, 61],  ['#f8f8f2', '#6272A4'], ''],
        \ 'Mid':                [[253, 239], ['#f8f8f2', '#44475A'], ''],
        \ 'Mid1':               [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'TabMid1':            [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InactiveA':          [[236, 61],  ['#282a36', '#6272A4'], ''],
        \ 'InactiveB':          [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'NormalModeMid1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'NormalModeTabMid1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InsertModeA':        [[236, 84],  ['#282a36', '#50FA7B'], ''],
        \ 'InsertModeMid1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'InsertModeTabMid1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'VisualModeA':        [[236, 228], ['#282a36', '#F1FA8C'], ''],
        \ 'VisualModeMid1':     [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'VisualModeTabMid1':  [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'ReplaceModeA':       [[236, 215], ['#282a36', '#FFB86C'], ''],
        \ 'ReplaceModeMid1':    [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'ReplaceModeTabMid1': [[253, 235], ['#f8f8f2', '#21222C'], ''],
        \ 'TerminalModeA':      [[236, 84],  ['#282a36', '#50FA7B'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
