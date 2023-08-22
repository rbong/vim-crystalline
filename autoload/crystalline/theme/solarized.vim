function! crystalline#theme#solarized#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'A':                [[15,  14], ['#fdf6e3', '#93a1a1'], 'bold'],
          \ 'B':                [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'Mid':              [[10,  0],  ['#586e75', '#073642'], ''],
          \ 'Mid1':             [[14,  0],  ['#93a1a1', '#073642'], ''],
          \ 'Tab1':             [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'InactiveA':        [[0,  11],  ['#073642', '#657b83'], ''],
          \ 'InactiveB':        [[0,  11],  ['#073642', '#657b83'], ''],
          \ 'InactiveMid':      [[0,  11],  ['#073642', '#657b83'], ''],
          \ 'InactiveMid1':     [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'NormalModeMid1':   [[14,  0],  ['#93a1a1', '#073642'], ''],
          \ 'NormalModeTab1':   [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'CommandModeTab1':  [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'InsertModeA':      [[15,  3],  ['#fdf6e3', '#b58900'], 'bold'],
          \ 'InsertModeMid1':   [[14,  0],  ['#93a1a1', '#073642'], ''],
          \ 'InsertModeTab1':   [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'VisualModeA':      [[15,  5],  ['#fdf6e3', '#d33682'], 'bold'],
          \ 'VisualModeMid1':   [[14,  0],  ['#93a1a1', '#073642'], ''],
          \ 'VisualModeTab1':   [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'ReplaceModeA':     [[15,  1],  ['#fdf6e3', '#dc322f'], ''],
          \ 'ReplaceModeMid1':  [[14,  0],  ['#93a1a1', '#073642'], ''],
          \ 'ReplaceModeTab1':  [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ 'TerminalModeTab1': [[7,  11],  ['#eee8d5', '#657b83'], ''],
          \ })
  else
    call crystalline#generate_theme({
          \ 'A':                [[7,  11], ['#eee8d5', '#657b83'], 'bold'],
          \ 'B':                [[7,  14], ['#eee8d5', '#93a1a1'], ''],
          \ 'Mid':              [[14,  7], ['#93a1a1', '#eee8d5'], ''],
          \ 'Mid1':             [[10,  7], ['#586e75', '#eee8d5'], ''],
          \ 'Tab1':             [[0,  12], ['#073642', '#839496'], ''],
          \ 'InactiveA':        [[7,  12], ['#eee8d5', '#839496'], ''],
          \ 'InactiveB':        [[7,  12], ['#eee8d5', '#839496'], ''],
          \ 'InactiveMid':      [[7,  12], ['#eee8d5', '#839496'], ''],
          \ 'InactiveMid1':     [[0,  12], ['#073642', '#839496'], ''],
          \ 'NormalModeMid1':   [[10,  7], ['#586e75', '#eee8d5'], ''],
          \ 'NormalModeTab1':   [[0,  12], ['#073642', '#839496'], ''],
          \ 'CommandModeTab1':  [[0,  12], ['#073642', '#839496'], ''],
          \ 'InsertModeA':      [[7,  3],  ['#eee8d5', '#b58900'], 'bold'],
          \ 'InsertModeMid1':   [[10,  7], ['#586e75', '#eee8d5'], ''],
          \ 'InsertModeTab1':   [[0,  12], ['#073642', '#839496'], ''],
          \ 'VisualModeA':      [[7,  5],  ['#eee8d5', '#d33682'], 'bold'],
          \ 'VisualModeMid1':   [[10,  7], ['#586e75', '#eee8d5'], ''],
          \ 'VisualModeTab1':   [[0,  12], ['#073642', '#839496'], ''],
          \ 'ReplaceModeA':     [[7,  1],  ['#eee8d5', '#dc322f'], ''],
          \ 'ReplaceModeMid1':  [[10,  7], ['#586e75', '#eee8d5'], ''],
          \ 'ReplaceModeTab1':  [[0,  12], ['#073642', '#839496'], ''],
          \ 'TerminalModeTab1': [[0,  12], ['#073642', '#839496'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
