function! crystalline#theme#onedark#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                [[235,    114], ['#282c34', '#98C379'], ''],
        \ 'B':                [[145,    236], ['#abb2bf', '#3E4452'], ''],
        \ 'Fill':             [[114,    236], ['#98c379', '#282C34'], ''],
        \ 'Fill1':            [['NONE', 236], ['#d8dee9', '#282C34'], ''],
        \ 'Tab1':             [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'InactiveA':        [[235,    145], ['#282c34', '#ABB2BF'], ''],
        \ 'InactiveFill':     [[145,    236], ['#abb2bf', '#3E4452'], ''],
        \ 'InactiveFill1':    [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'NormalModeFill1':  [['NONE', 236], ['#d8dee9', '#282C34'], ''],
        \ 'NormalModeTab1':   [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'CommandModeTab1':  [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'InsertModeA':      [[235,    39],  ['#282c34', '#61AFEF'], ''],
        \ 'InsertModeFill':   [[39,     236], ['#61afef', '#282C34'], ''],
        \ 'InsertModeFill1':  [['NONE', 236], ['#d8dee9', '#282C34'], ''],
        \ 'InsertModeTab1':   [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'VisualModeA':      [[235,    170], ['#282c34', '#C678DD'], ''],
        \ 'VisualModeFill':   [[170,    236], ['#c678dd', '#282C34'], ''],
        \ 'VisualModeFill1':  [['NONE', 236], ['#d8dee9', '#282C34'], ''],
        \ 'VisualModeTab1':   [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'ReplaceModeA':     [[235,    204], ['#282c34', '#E06C75'], ''],
        \ 'ReplaceModeFill':  [[204,    236], ['#e06c75', '#282C34'], ''],
        \ 'ReplaceModeFill1': [['NONE', 236], ['#d8dee9', '#282C34'], ''],
        \ 'ReplaceModeTab1':  [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ 'TerminalModeA':    [[235,    39],  ['#282c34', '#61AFEF'], ''],
        \ 'TerminalModeFill': [[39,     236], ['#61afef', '#282C34'], ''],
        \ 'TerminalModeTab1': [['NONE', 236], ['#d8dee9', '#3E4452'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
