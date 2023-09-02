function! crystalline#theme#hybrid#SetTheme() abort
  if &background ==# 'dark'
    call crystalline#GenerateTheme({
          \ 'A':            [[193, 65],  ['#d7ffaf', '#5f875f'], ''],
          \ 'B':            [[250, 235], ['#c5c8c6', '#282a2e'], ''],
          \ 'Fill':         [[250, 237], ['#c5c8c6', '#373b41'], ''],
          \ 'InactiveA':    [[243, 236], ['#707880', '#303030'], ''],
          \ 'InactiveB':    [[243, 236], ['#707880', '#303030'], ''],
          \ 'InactiveFill': [[243, 236], ['#707880', '#303030'], ''],
          \ 'InsertModeA':  [[250, 110], ['#c5c8c6', '#81a2be'], ''],
          \ 'VisualModeA':  [[250, 167], ['#c5c8c6', '#cc6666'], ''],
          \ 'ReplaceModeA': [[189, 60],  ['#d7d7ff', '#5f5f87'], ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':            [[22, 194], ['#005f00', '#d7ffd7'], ''],
          \ 'B':            [[16, 252], ['#000000', '#d0d0d0'], ''],
          \ 'Fill':         [[16, 250], ['#000000', '#bcbcbc'], ''],
          \ 'InactiveA':    [[59, 247], ['#5f5f5f', '#9e9e9e'], ''],
          \ 'InactiveB':    [[59, 247], ['#5f5f5f', '#9e9e9e'], ''],
          \ 'InactiveFill': [[59, 247], ['#5f5f5f', '#9e9e9e'], ''],
          \ 'InsertModeA':  [[16, 110], ['#000000', '#81a2be'], ''],
          \ 'VisualModeA':  [[16, 224], ['#000000', '#ffd7d7'], ''],
          \ 'ReplaceModeA': [[53, 189], ['#5f005f', '#d7d7ff'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
