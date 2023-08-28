function! crystalline#theme#base16#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                [[9,      'NONE'], ['Red',   'NONE'],      'bold'],
        \ 'B':                [['NONE', 7],      ['NONE',  'LightGrey'], ''],
        \ 'Fill':             [['NONE', 'NONE'], ['NONE',  'Grey90'],    ''],
        \ 'Fill1':            [[130,    'NONE'], ['Brown', 'Grey90'],    ''],
        \ 'InactiveA':        [['NONE', 'NONE'], ['NONE',  'NONE'],      'reverse'],
        \ 'InactiveB':        [['NONE', 'NONE'], ['NONE',  'NONE'],      'reverse'],
        \ 'InactiveFill':     [['NONE', 'NONE'], ['NONE',  'NONE'],      'reverse'],
        \ 'NormalModeFill1':  [[130,    'NONE'], ['Brown', 'Grey90'],    ''],
        \ 'InsertModeFill1':  [[130,    'NONE'], ['Brown', 'Grey90'],    ''],
        \ 'VisualModeA':      [[9,      1],      ['Red',   'Magenta'],   'bold'],
        \ 'VisualModeFill1':  [[130,    'NONE'], ['Brown', 'Grey90'],    ''],
        \ 'ReplaceModeA':     [[9,       1],     ['Red',   'Red'],       'bold'],
        \ 'ReplaceModeFill1': [[130,    'NONE'], ['Brown', 'Grey90'],    ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
