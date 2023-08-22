function! crystalline#theme#hybrid#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':             [[22,  10],  ['#005f00', '#b5bd68'], ''],
        \ 'B':             [[15,  8],   ['#c5c8c6', '#373b41'], ''],
        \ 'Mid':           [[255, 0],   ['#ffffff', '#282a2e'], ''],
        \ 'InactiveA':     [[239, 234], ['#4e4e4e', '#1c1c1c'], ''],
        \ 'InactiveB':     [[239, 235], ['#4e4e4e', '#262626'], ''],
        \ 'InactiveMid':   [[239, 236], ['#4e4e4e', '#303030'], ''],
        \ 'InsertModeA':   [[23,  14],  ['#005f5f', '#8abeb7'], ''],
        \ 'InsertModeB':   [[15,  31],  ['#c5c8c6', '#0087af'], ''],
        \ 'InsertModeMid': [[255, 24],  ['#ffffff', '#005f87'], ''],
        \ 'VisualModeA':   [[16,  3],   ['#000000', '#de935f'], ''],
        \ 'ReplaceModeA':  [[16,  9],   ['#000000', '#CC6666'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
