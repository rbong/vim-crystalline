function! crystalline#theme#ayu#SetTheme() abort
  let l:ayucolor = get(g:, 'ayucolor', &background)

  if l:ayucolor ==# 'light'
    call crystalline#GenerateTheme({
          \ 'A':            [[66, 106],  ['#6c7680', '#86b300'], ''],
          \ 'B':            [[106, 66],  ['#86b300', '#6c7680'], ''],
          \ 'Fill':         [[66, 231],  ['#6c7680', '#fafafa'], ''],
          \ 'InactiveA':    [[106, 231], ['#86b300', '#fafafa'], ''],
          \ 'InactiveB':    [[106, 231], ['#86b300', '#fafafa'], ''],
          \ 'InactiveFill': [[106, 231], ['#86b300', '#fafafa'], ''],
          \ 'InsertModeA':  [[66, 74],   ['#6c7680', '#55b4d4'], ''],
          \ 'InsertModeB':  [[74, 66],   ['#55b4d4', '#6c7680'], ''],
          \ 'VisualModeA':  [[66, 209],  ['#6c7680', '#fa8d3e'], ''],
          \ 'VisualModeB':  [[209, 66],  ['#fa8d3e', '#6c7680'], ''],
          \ 'ReplaceModeA': [[66, 196],  ['#6c7680', '#f51818'], ''],
          \ })
  elseif l:ayucolor ==# 'mirage'
    call crystalline#GenerateTheme({
          \ 'A':            [[0, 114],   ['#212733', '#bbe67e'], ''],
          \ 'B':            [[114, 0],   ['#bbe67e', '#212733'], ''],
          \ 'Fill':         [[15, 0],    ['#e6e1cf', '#212733'], ''],
          \ 'InactiveA':    [[114, 114], ['#bbe67e', '#212733'], ''],
          \ 'InactiveFill': [[114, 0],   ['#bbe67e', '#212733'], ''],
          \ 'InsertModeA':  [[0, 80],    ['#212733', '#80d4ff'], ''],
          \ 'InsertModeB':  [[80, 0],    ['#80d4ff', '#212733'], ''],
          \ 'VisualModeA':  [[0, 173],   ['#212733', '#ffae57'], ''],
          \ 'VisualModeB':  [[173, 0],   ['#ffae57', '#212733'], ''],
          \ 'ReplaceModeA': [[0, 167],   ['#212733', '#f07178'], ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':            [[59, 149], ['#3d424d', '#c2d94c'], ''],
          \ 'B':            [[149, 59], ['#c2d94c', '#304357'], ''],
          \ 'Fill':         [[145, 16], ['#b3b1ad', '#0a0e14'], ''],
          \ 'InactiveA':    [[149, 16], ['#c2d94c', '#0a0e14'], ''],
          \ 'InactiveB':    [[149, 16], ['#c2d94c', '#0a0e14'], ''],
          \ 'InactiveFill': [[149, 16], ['#c2d94c', '#0a0e14'], ''],
          \ 'InsertModeA':  [[59, 74],  ['#3d424d', '#39bae6'], ''],
          \ 'InsertModeB':  [[74, 59],  ['#39bae6', '#304357'], ''],
          \ 'VisualModeA':  [[59, 209], ['#3d424d', '#ff8f40'], ''],
          \ 'VisualModeB':  [[209, 59], ['#ff8f40', '#304357'], ''],
          \ 'ReplaceModeA': [[59, 203], ['#3d424d', '#ff3333'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
