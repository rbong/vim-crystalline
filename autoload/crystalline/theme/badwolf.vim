function! crystalline#theme#badwolf#set_theme() abort
  call crystalline#generate_theme({
        \ 'A':            [[232, 154], ['#141413', '#aeee00']],
        \ 'B':            [[222, 238], ['#f4cf86', '#45413b']],
        \ 'Mid':          [[121, 235], ['#8cffba', '#242321']],
        \ 'InactiveMid':  [[235, 238], ['#242321', '#45413b']],
        \ 'NormalModeA':  [[232, 154], ['#141413', '#aeee00']],
        \ 'InsertModeA':  [[232, 39],  ['#141413', '#0a9dff']],
        \ 'VisualModeA':  [[232, 214], ['#141413', '#ffa724']],
        \ 'ReplaceModeA': [[232, 211], ['#141413', '#ff9eb8']],
        \ 'TabType':      [[232, 214], ['#141413', '#ffa724']],
        \ 'Tab':          [[222, 238], ['#f4cf86', '#45413b']],
        \ 'TabSel':       [[232, 154], ['#141413', '#aeee00']],
        \ 'TabMid':       [[121, 235], ['#8cffba', '#242321']],
        \ })
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
