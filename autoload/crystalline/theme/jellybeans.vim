function! crystalline#theme#jellybeans#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':                [[189, 25],  ['#d8dee9', '#0d61ac'], ''],
        \ 'B':                [[231, 235], ['#ffffff', '#262626'], ''],
        \ 'Fill':             [[59,  233], ['#4f5b66', '#151515'], ''],
        \ 'Fill1':            [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'Tab1':             [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'InactiveA':        [[243, 235], ['#666666', '#262626'], ''],
        \ 'InactiveB':        [[59,  233], ['#4f5b66', '#151515'], ''],
        \ 'InactiveFill1':    [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'NormalModeFill1':  [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'NormalModeTab1':   [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'CommandModeTab1':  [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'InsertModeA':      [[231, 22],  ['#ffffff', '#437019'], ''],
        \ 'InsertModeFill':   [[231, 233], ['#ffffff', '#151515'], ''],
        \ 'InsertModeFill1':  [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'InsertModeTab1':   [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'VisualModeA':      [[231, 88],  ['#ffffff', '#870000'], ''],
        \ 'VisualModeFill':   [[231, 233], ['#ffffff', '#151515'], ''],
        \ 'VisualModeFill1':  [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'VisualModeTab1':   [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'ReplaceModeA':     [[88,  233], ['#870000', '#151515'], ''],
        \ 'ReplaceModeFill':  [[231, 233], ['#ffffff', '#151515'], ''],
        \ 'ReplaceModeFill1': [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'ReplaceModeTab1':  [[215, 233], ['#ffb964', '#151515'], ''],
        \ 'TerminalModeTab1': [[215, 233], ['#ffb964', '#151515'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
