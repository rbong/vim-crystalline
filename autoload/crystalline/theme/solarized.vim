function! crystalline#theme#solarized#SetTheme() abort
  if &background ==# 'dark'
    call crystalline#GenerateTheme({
          \ 'A':                [[230, 245], ['#fdf6e3', '#93a1a1'], 'cterm=bold gui=bold'],
          \ 'B':                [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'Fill':             [[239, 235], ['#586e75', '#073642'], ''],
          \ 'Fill1':            [[245, 235], ['#93a1a1', '#073642'], ''],
          \ 'Tab1':             [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'InactiveA':        [[235, 240], ['#073642', '#657b83'], ''],
          \ 'InactiveB':        [[235, 240], ['#073642', '#657b83'], ''],
          \ 'InactiveFill':     [[235, 240], ['#073642', '#657b83'], ''],
          \ 'InactiveFill1':    [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'NormalModeFill1':  [[245, 235], ['#93a1a1', '#073642'], ''],
          \ 'NormalModeTab1':   [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'CommandModeTab1':  [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'InsertModeA':      [[230, 136], ['#fdf6e3', '#b58900'], 'cterm=bold gui=bold'],
          \ 'InsertModeFill1':  [[245, 235], ['#93a1a1', '#073642'], ''],
          \ 'InsertModeTab1':   [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'VisualModeA':      [[230, 125], ['#fdf6e3', '#d33682'], 'cterm=bold gui=bold'],
          \ 'VisualModeFill1':  [[245, 235], ['#93a1a1', '#073642'], ''],
          \ 'VisualModeTab1':   [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'ReplaceModeA':     [[230, 124], ['#fdf6e3', '#dc322f'], ''],
          \ 'ReplaceModeFill1': [[245, 235], ['#93a1a1', '#073642'], ''],
          \ 'ReplaceModeTab1':  [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ 'TerminalModeTab1': [[187, 240], ['#eee8d5', '#657b83'], ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':                [[187, 240], ['#eee8d5', '#657b83'], 'cterm=bold gui=bold'],
          \ 'B':                [[187, 245], ['#eee8d5', '#93a1a1'], ''],
          \ 'Fill':             [[245, 187], ['#93a1a1', '#eee8d5'], ''],
          \ 'Fill1':            [[239, 187], ['#586e75', '#eee8d5'], ''],
          \ 'Tab1':             [[235, 244], ['#073642', '#839496'], ''],
          \ 'InactiveA':        [[187, 244], ['#eee8d5', '#839496'], ''],
          \ 'InactiveB':        [[187, 244], ['#eee8d5', '#839496'], ''],
          \ 'InactiveFill':     [[187, 244], ['#eee8d5', '#839496'], ''],
          \ 'InactiveFill1':    [[235, 244], ['#073642', '#839496'], ''],
          \ 'NormalModeFill1':  [[239, 187], ['#586e75', '#eee8d5'], ''],
          \ 'NormalModeTab1':   [[235, 244], ['#073642', '#839496'], ''],
          \ 'CommandModeTab1':  [[235, 244], ['#073642', '#839496'], ''],
          \ 'InsertModeA':      [[187, 136], ['#eee8d5', '#b58900'], 'cterm=bold gui=bold'],
          \ 'InsertModeFill1':  [[239, 187], ['#586e75', '#eee8d5'], ''],
          \ 'InsertModeTab1':   [[235, 244], ['#073642', '#839496'], ''],
          \ 'VisualModeA':      [[187, 125], ['#eee8d5', '#d33682'], 'cterm=bold gui=bold'],
          \ 'VisualModeFill1':  [[239, 187], ['#586e75', '#eee8d5'], ''],
          \ 'VisualModeTab1':   [[235, 244], ['#073642', '#839496'], ''],
          \ 'ReplaceModeA':     [[187, 124], ['#eee8d5', '#dc322f'], ''],
          \ 'ReplaceModeFill1': [[239, 187], ['#586e75', '#eee8d5'], ''],
          \ 'ReplaceModeTab1':  [[235, 244], ['#073642', '#839496'], ''],
          \ 'TerminalModeTab1': [[235, 244], ['#073642', '#839496'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
