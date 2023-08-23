function! crystalline#theme#iceberg#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'A':             [[234, 245], ['#17171b', '#818596'], ''],
          \ 'B':             [[242, 236], ['#6b7089', '#2e313f'], ''],
          \ 'Mid':           [[238, 233], ['#3e445e', '#0f1117'], ''],
          \ 'InactiveA':     [[238, 233], ['#3e445e', '#0f1117'], ''],
          \ 'InactiveB':     [[238, 233], ['#3e445e', '#0f1117'], ''],
          \ 'InsertModeA':   [[234, 110], ['#161821', '#84a0c6'], ''],
          \ 'VisualModeA':   [[234, 150], ['#161821', '#b4be82'], ''],
          \ 'ReplaceModeA':  [[234, 216], ['#161821', '#e2a478'], ''],
          \ 'TerminalModeA': [[234, 110], ['#161821', '#84a0c6'], ''],
          \ })
  else
    call crystalline#generate_theme({
          \ 'A':             [[252, 243], ['#e8e9ec', '#757ca3'], ''],
          \ 'B':             [[252, 247], ['#e8e9ec', '#9fa6c0'], ''],
          \ 'Mid':           [[244, 251], ['#8b98b6', '#cad0de'], ''],
          \ 'InactiveA':     [[244, 251], ['#8b98b6', '#cad0de'], ''],
          \ 'InactiveB':     [[244, 251], ['#8b98b6', '#cad0de'], ''],
          \ 'InsertModeA':   [[254, 25],  ['#e8e9ec', '#2d539e'], ''],
          \ 'VisualModeA':   [[254, 64],  ['#e8e9ec', '#668e3d'], ''],
          \ 'ReplaceModeA':  [[254, 130], ['#e8e9ec', '#c57339'], ''],
          \ 'TerminalModeA': [[254, 25],  ['#e8e9ec', '#2d539e'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
