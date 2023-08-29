function! crystalline#theme#shadesofpurple#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':               [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'B':               [[234, 140], ['#1e1e3f', '#a599e9'], ''],
        \ 'Fill':            [[140, 236], ['#a599e9', '#2d2b55'], ''],
        \ 'InactiveB':       [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'InactiveFill':    [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'InsertModeA':     [[159, 234], ['#9effff', '#1e1e3f'], ''],
        \ 'InsertModeFill':  [[159, 234], ['#9effff', '#1e1e3f'], ''],
        \ 'VisualModeA':     [[234, 177], ['#1e1e3f', '#c991ff'], ''],
        \ 'VisualModeB':     [[234, 213], ['#1e1e3f', '#fb94ff'], ''],
        \ 'VisualModeFill':  [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ 'ReplaceModeA':    [[234, 204], ['#1e1e3f', '#ff628c'], ''],
        \ 'ReplaceModeB':    [[234, 211], ['#1e1e3f', '#ff91ae'], ''],
        \ 'ReplaceModeFill': [[140, 234], ['#a599e9', '#1e1e3f'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:

