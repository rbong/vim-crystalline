function! crystalline#theme#jellybeans#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[189, 25],  ['#d8dee9', '#0d61ac']],
        \ 'B':            [[231, 235], ['#ffffff', '#262626']],
        \ 'Mid':          [[59,  233], ['#4f5b66', '#151515']],
        \ 'InactiveMid':  [[243, 235], ['#666666', '#262626']],
        \ 'NormalModeA':  [[189, 25],  ['#d8dee9', '#0d61ac']],
        \ 'InsertModeA':  [[231, 22],  ['#ffffff', '#437019']],
        \ 'VisualModeA':  [[231, 88],  ['#ffffff', '#870000']],
        \ 'ReplaceModeA': [[88,  233], ['#870000', '#262626']],
        \ 'TabType':      [[231, 88],  ['#ffffff', '#870000']],
        \ 'Tab':          [[231, 235], ['#ffffff', '#262626']],
        \ 'TabSel':       [[189, 25],  ['#d8dee9', '#0d61ac']],
        \ 'TabMid':       [[59,  233], ['#4f5b66', '#151515']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
