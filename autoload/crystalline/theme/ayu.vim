function! crystalline#theme#ayu#SetTheme() abort
  let l:ayucolor = get(g:, 'ayucolor', &background)

  if l:ayucolor ==# 'light'
    call crystalline#GenerateTheme({
          \ 'A':                [[7,  4],  ['#fafafa', '#36a3d9'], ''],
          \ 'B':                [[14, 10], ['#ef7e46', '#fafafa'], ''],
          \ 'Fill':             [[4,  8],  ['#36a3d9', '#fafafa'], ''],
          \ 'Fill1':            [[13, 8],  ['#f07178', '#fafafa'], ''],
          \ 'Tab1':             [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'InactiveA':        [[4,  10], ['#36a3d9', '#fafafa'], ''],
          \ 'InactiveB':        [[4,  8],  ['#36a3d9', '#fafafa'], ''],
          \ 'InactiveFill':     [[4,  0],  ['#36a3d9', '#eaeaea'], ''],
          \ 'InactiveFill1':    [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'NormalModeFill1':  [[13, 8],  ['#f07178', '#fafafa'], ''],
          \ 'NormalModeTab1':   [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'CommandModeTab1':  [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'InsertModeA':      [[10, 3],  ['#fafafa', '#e7c547'], ''],
          \ 'InsertModeB':      [[9,  12], ['#ff7733', '#fafafa'], ''],
          \ 'InsertModeFill1':  [[13, 8],  ['#f07178', '#fafafa'], ''],
          \ 'InsertModeTab1':   [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'VisualModeA':      [[10, 13], ['#fafafa', '#f07178'], ''],
          \ 'VisualModeB':      [[9,  12], ['#ff7733', '#fafafa'], ''],
          \ 'VisualModeFill1':  [[13, 8],  ['#f07178', '#fafafa'], ''],
          \ 'VisualModeTab1':   [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'ReplaceModeA':     [[10, 9],  ['#fafafa', '#ff7733'], ''],
          \ 'ReplaceModeB':     [[9,  12], ['#ff7733', '#fafafa'], ''],
          \ 'ReplaceModeFill1': [[13, 8],  ['#f07178', '#fafafa'], ''],
          \ 'ReplaceModeTab1':  [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ 'TerminalModeTab1': [[13, 0],  ['#f07178', '#eaeaea'], ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':                [[7,  4],  ['#3f4e5a', '#36a3d9'], ''],
          \ 'B':                [[14, 10], ['#384550', '#232b32'], ''],
          \ 'Fill':             [[4,  8],  ['#36a3d9', '#1c2328'], ''],
          \ 'Fill1':            [[13, 8],  ['#f07178', '#1c2328'], ''],
          \ 'Tab1':             [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'InactiveA':        [[4,  10], ['#36a3d9', '#232b32'], ''],
          \ 'InactiveB':        [[4,  8],  ['#36a3d9', '#1c2328'], ''],
          \ 'InactiveFill':     [[4,  0],  ['#36a3d9', '#151a1e'], ''],
          \ 'InactiveFill1':    [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'NormalModeFill1':  [[13, 8],  ['#f07178', '#1c2328'], ''],
          \ 'NormalModeTab1':   [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'CommandModeTab1':  [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'InsertModeA':      [[10, 3],  ['#232b32', '#e7c547'], ''],
          \ 'InsertModeB':      [[7,  12], ['#3f4e5a', '#2a343c'], ''],
          \ 'InsertModeFill1':  [[13, 8],  ['#f07178', '#1c2328'], ''],
          \ 'InsertModeTab1':   [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'VisualModeA':      [[10, 13], ['#232b32', '#f07178'], ''],
          \ 'VisualModeB':      [[7,  12], ['#3f4e5a', '#2a343c'], ''],
          \ 'VisualModeFill1':  [[13, 8],  ['#f07178', '#1c2328'], ''],
          \ 'VisualModeTab1':   [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'ReplaceModeA':     [[10, 9],  ['#232b32', '#ff7733'], ''],
          \ 'ReplaceModeB':     [[7,  12], ['#3f4e5a', '#2a343c'], ''],
          \ 'ReplaceModeFill1': [[13, 8],  ['#f07178', '#1c2328'], ''],
          \ 'ReplaceModeTab1':  [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ 'TerminalModeTab1': [[13, 0],  ['#f07178', '#151a1e'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
