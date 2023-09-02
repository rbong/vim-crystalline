function! crystalline#theme#onedark#SetTheme() abort
  call crystalline#GenerateTheme({
        \ 'A':                [[235, 114], ['#282c34', '#98c379'], ''],
        \ 'B':                [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'Fill':             [[114, 236], ['#98c379', '#282c34'], ''],
        \ 'Fill1':            [[145, 236], ['#abb2bf', '#282c34'], ''],
        \ 'Tab1':             [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'InactiveA':        [[235, 145], ['#282c34', '#abb2bf'], ''],
        \ 'InactiveFill':     [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'InactiveFill1':    [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'NormalModeFill1':  [[145, 236], ['#abb2bf', '#282c34'], ''],
        \ 'NormalModeTab1':   [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'CommandModeTab1':  [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'InsertModeA':      [[235, 39],  ['#282c34', '#61afef'], ''],
        \ 'InsertModeFill':   [[39,  236], ['#61afef', '#282c34'], ''],
        \ 'InsertModeFill1':  [[145, 236], ['#abb2bf', '#282c34'], ''],
        \ 'InsertModeTab1':   [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'VisualModeA':      [[235, 170], ['#282c34', '#c678dd'], ''],
        \ 'VisualModeFill':   [[170, 236], ['#c678dd', '#282c34'], ''],
        \ 'VisualModeFill1':  [[145, 236], ['#abb2bf', '#282c34'], ''],
        \ 'VisualModeTab1':   [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'ReplaceModeA':     [[235, 204], ['#282c34', '#e06c75'], ''],
        \ 'ReplaceModeFill':  [[204, 236], ['#e06c75', '#282c34'], ''],
        \ 'ReplaceModeFill1': [[145, 236], ['#abb2bf', '#282c34'], ''],
        \ 'ReplaceModeTab1':  [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ 'TerminalModeA':    [[235, 39],  ['#282c34', '#61afef'], ''],
        \ 'TerminalModeFill': [[39,  236], ['#61afef', '#282c34'], ''],
        \ 'TerminalModeTab1': [[145, 236], ['#abb2bf', '#3e4452'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
