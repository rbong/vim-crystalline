function! crystalline#theme#default#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':                 [[17, 190],  ['#00005f', '#dfff00'], ''],
        \ 'B':                 [[255, 238], ['#ffffff', '#444444'], ''],
        \ 'Fill':              [[85, 234],  ['#9cffd3', '#202020'], ''],
        \ 'Fill1':             [[255, 53],  ['#ffffff', '#5f005f'], ''],
        \ 'Tab1':              [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'InactiveA':         [[239, 234], ['#4e4e4e', '#1c1c1c'], ''],
        \ 'InactiveB':         [[239, 235], ['#4e4e4e', '#262626'], ''],
        \ 'InactiveFill':      [[239, 236], ['#4e4e4e', '#303030'], ''],
        \ 'InactiveFill1':     [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'NormalModeFill1':   [[255, 53],  ['#ffffff', '#5f005f'], ''],
        \ 'NormalModeTab1':    [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'CommandModeA':      [[17, 40],   ['#00005f', '#00d700'], ''],
        \ 'CommandModeTab1':   [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'InsertModeA':       [[17, 45],   ['#00005f', '#00dfff'], ''],
        \ 'InsertModeA2':      [[17, 172],  ['#00005f', '#d78700'], ''],
        \ 'InsertModeB':       [[255, 27],  ['#ffffff', '#005fff'], ''],
        \ 'InsertModeFill':    [[15, 17],   ['#ffffff', '#000080'], ''],
        \ 'InsertModeFill1':   [[255, 53],  ['#ffffff', '#5f005f'], ''],
        \ 'InsertModeTab1':    [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'InsertModeTabSel2': [[17, 172],  ['#00005f', '#d78700'], ''],
        \ 'VisualModeA':       [[232, 214], ['#000000', '#ffaf00'], ''],
        \ 'VisualModeB':       [[232, 202], ['#000000', '#ff5f00'], ''],
        \ 'VisualModeFill':    [[15, 52],   ['#ffffff', '#5f0000'], ''],
        \ 'VisualModeFill1':   [[255, 53],  ['#ffffff', '#5f005f'], ''],
        \ 'VisualModeTab1':    [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'ReplaceModeA':      [[255, 124], ['#ffffff', '#af0000'], ''],
        \ 'ReplaceModeB':      [[255, 27],  ['#ffffff', '#005fff'], ''],
        \ 'ReplaceModeFill':   [[15, 17],   ['#ffffff', '#000080'], ''],
        \ 'ReplaceModeFill1':  [[255, 53],  ['#ffffff', '#5f005f'], ''],
        \ 'ReplaceModeTab1':   [[97, 236],  ['#875faf', '#303030'], ''],
        \ 'TerminalModeA':     [[17, 45],   ['#00005f', '#00dfff'], ''],
        \ 'TerminalModeB':     [[255, 27],  ['#ffffff', '#005fff'], ''],
        \ 'TerminalModeFill':  [[15, 17],   ['#ffffff', '#000080'], ''],
        \ 'TerminalModeTab1':  [[97, 236],  ['#875faf', '#303030'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
