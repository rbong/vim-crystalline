function! crystalline#theme#nord#set_theme() abort
  if get(g:, 'nord_uniform_status_lines')
    let inactive8 = [189, 239]
    let inactive24 = ['#E5E9F0', '#4C566A']
  else
    let inactive8 = [189, 238]
    let inactive24 = ['#E5E9F0', '#3B4252']
  endif
  call crystalline#generate_theme({
        \ 'NormalMode':  [[238, 110], ['#3B4252', '#88C0D0']],
        \ 'InsertMode':  [[238, 231], ['#3B4252', '#ECEFF4']],
        \ 'VisualMode':  [[238, 108], ['#3B4252', '#8FBCBB']],
        \ 'ReplaceMode': [[238, 222], ['#3B4252', '#EBCB8B']],
        \ '':            [[189, 238], ['#E5E9F0', '#3B4252']],
        \ 'Inactive':    [inactive8, inactive24],
        \ 'Fill':        [[189, 239], ['#E5E9F0', '#4C566A']],
        \ 'Tab':         [[189, 239], ['#E5E9F0', '#4C566A']],
        \ 'TabType':     [[238, 109], ['#3B4252', '#81A1C1']],
        \ 'TabSel':      [[238, 110], ['#3B4252', '#88C0D0']],
        \ 'TabFill':     [[189, 239], ['#E5E9F0', '#4C566A']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
