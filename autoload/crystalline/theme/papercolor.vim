function! crystalline#theme#papercolor#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[240, 254], ['#585858', '#e4e4e4']],
        \ 'InsertMode':  [[240, 254], ['#585858', '#e4e4e4']],
        \ 'VisualMode':  [[24,  254], ['#005f87', '#e4e4e4']],
        \ 'ReplaceMode': [[161, 254], ['#d7005f', '#e4e4e4']],
        \ 'Line':        [[254, 31],  ['#e4e4e4', '#0087af']],
        \ 'Inactive':    [[240, 254], ['#585858', '#e4e4e4']],
        \ 'Fill':        [[255, 24],  ['#eeeeee', '#005f87']],
        \ 'Tab':         [[254, 31],  ['#e4e4e4', '#0087af']],
        \ 'TabType':     [[24, 254],  ['#005f87', '#e4e4e4']],
        \ 'TabSel':      [[240, 254], ['#585858', '#e4e4e4']],
        \ 'TabFill':     [[255, 24],  ['#eeeeee', '#005f87']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
