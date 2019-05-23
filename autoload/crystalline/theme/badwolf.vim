function! crystalline#theme#badwolf#set_theme() abort
  call crystalline#generate_theme({
        \ 'NormalMode':  [[232, 154], ['#141413', '#aeee00']],
        \ 'InsertMode':  [[232, 39],  ['#141413', '#0a9dff']],
        \ 'VisualMode':  [[232, 214], ['#141413', '#ffa724']],
        \ 'ReplaceMode': [[232, 211], ['#141413', '#ff9eb8']],
        \ '':            [[222, 238], ['#f4cf86', '#45413b']],
        \ 'Inactive':    [[235, 238], ['#242321', '#45413b']],
        \ 'Fill':        [[121, 235], ['#8cffba', '#242321']],
        \ 'Tab':         [[222, 238], ['#f4cf86', '#45413b']],
        \ 'TabType':     [[232, 214], ['#141413', '#ffa724']],
        \ 'TabSel':      [[232, 154], ['#141413', '#aeee00']],
        \ 'TabFill':     [[121, 235], ['#8cffba', '#242321']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
