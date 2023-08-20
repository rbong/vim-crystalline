function! crystalline#theme#papercolor#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[240, 254], ['#585858', '#e4e4e4']],
        \ 'B':            [[254, 31],  ['#e4e4e4', '#0087af']],
        \ 'Mid':          [[255, 24],  ['#eeeeee', '#005f87']],
        \ 'InactiveMid':  [[240, 254], ['#585858', '#e4e4e4']],
        \ 'NormalModeA':  [[240, 254], ['#585858', '#e4e4e4']],
        \ 'InsertModeA':  [[240, 254], ['#585858', '#e4e4e4']],
        \ 'VisualModeA':  [[24,  254], ['#005f87', '#e4e4e4']],
        \ 'ReplaceModeA': [[161, 254], ['#d7005f', '#e4e4e4']],
        \ 'TabType':      [[24, 254],  ['#005f87', '#e4e4e4']],
        \ 'Tab':          [[254, 31],  ['#e4e4e4', '#0087af']],
        \ 'TabSel':       [[240, 254], ['#585858', '#e4e4e4']],
        \ 'TabMid':       [[255, 24],  ['#eeeeee', '#005f87']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
