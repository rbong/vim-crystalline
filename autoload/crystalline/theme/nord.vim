function! crystalline#theme#nord#set_theme() abort
  if get(g:, 'nord_uniform_status_lines')
    let inactive8 = [189, 239]
    let inactive24 = ['#E5E9F0', '#4C566A']
  else
    let inactive8 = [189, 238]
    let inactive24 = ['#E5E9F0', '#3B4252']
  endif
  call crystalline#generate_theme({
        \ 'A':            [[238, 110], ['#3B4252', '#88C0D0']],
        \ 'B':            [[189, 238], ['#E5E9F0', '#3B4252']],
        \ 'Mid':          [[189, 239], ['#E5E9F0', '#4C566A']],
        \ 'InactiveMid':  [inactive8, inactive24],
        \ 'NormalModeA':  [[238, 110], ['#3B4252', '#88C0D0']],
        \ 'InsertModeA':  [[238, 231], ['#3B4252', '#ECEFF4']],
        \ 'VisualModeA':  [[238, 108], ['#3B4252', '#8FBCBB']],
        \ 'ReplaceModeA': [[238, 222], ['#3B4252', '#EBCB8B']],
        \ 'TabType':      [[238, 109], ['#3B4252', '#81A1C1']],
        \ 'Tab':          [[189, 239], ['#E5E9F0', '#4C566A']],
        \ 'TabSel':       [[238, 110], ['#3B4252', '#88C0D0']],
        \ 'TabMid':       [[189, 239], ['#E5E9F0', '#4C566A']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
