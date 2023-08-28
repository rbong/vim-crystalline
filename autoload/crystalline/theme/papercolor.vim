function! crystalline#theme#papercolor#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':                [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'B':                [[254, 31],  ['#e4e4e4', '#0087af'], ''],
        \ 'Fill':             [[255, 24],  ['#eeeeee', '#005f87'], ''],
        \ 'Tab1':             [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'InactiveB':        [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'InactiveFill':     [[254, 31],  ['#e4e4e4', '#0087af'], ''],
        \ 'InactiveFill1':    [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'NormalModeTab1':   [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'CommandModeTab1':  [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'InsertModeTab1':   [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'VisualModeA':      [[24,  254], ['#005f87', '#e4e4e4'], ''],
        \ 'VisualModeFill':   [[254, 24],  ['#e4e4e4', '#005f87'], ''],
        \ 'VisualModeTab1':   [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'ReplaceModeA':     [[161, 254], ['#d7005f', '#e4e4e4'], ''],
        \ 'ReplaceModeTab1':  [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ 'TerminalModeTab1': [[240, 254], ['#585858', '#e4e4e4'], ''],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
