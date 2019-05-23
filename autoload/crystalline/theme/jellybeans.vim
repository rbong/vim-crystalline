function! crystalline#theme#jellybeans#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[189, 25],  ['#d8dee9', '#0d61ac']],
        \ 'InsertMode':  [[231, 22],  ['#ffffff', '#437019']],
        \ 'VisualMode':  [[231, 88],  ['#ffffff', '#870000']],
        \ 'ReplaceMode': [[88,  233], ['#870000', '#262626']],
        \ '':            [[231, 235], ['#ffffff', '#262626']],
        \ 'Inactive':    [[243, 235], ['#666666', '#262626']],
        \ 'Fill':        [[59,  233], ['#4f5b66', '#151515']],
        \ 'Tab':         [[231, 235], ['#ffffff', '#262626']],
        \ 'TabType':     [[231, 88],  ['#ffffff', '#870000']],
        \ 'TabSel':      [[189, 25],  ['#d8dee9', '#0d61ac']],
        \ 'TabFill':     [[59,  233], ['#4f5b66', '#151515']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
