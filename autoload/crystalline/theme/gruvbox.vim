function! crystalline#theme#gruvbox#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'A':            [[235, 246], ['#282828', '#a89984']],
          \ 'B':            [[246, 239], ['#a89984', '#504945']],
          \ 'Mid':          [[246, 237], ['#a89984', '#3c3836']],
          \ 'InactiveMid':  [[243, 237], ['#7c6f64', '#3c3836']],
          \ 'NormalModeA':  [[235, 246], ['#282828', '#a89984']],
          \ 'InsertModeA':  [[235, 109], ['#282828', '#83a598']],
          \ 'VisualModeA':  [[235, 208], ['#282828', '#fe8019']],
          \ 'ReplaceModeA': [[235, 108], ['#282828', '#8ec07c']],
          \ 'TabType':      [[235, 208], ['#282828', '#fe8019']],
          \ 'Tab':          [[246, 239], ['#a89984', '#504945']],
          \ 'TabSel':       [[235, 246], ['#282828', '#a89984']],
          \ 'TabMid':       [[235, 235], ['#282828', '#282828']],
          \ })
  else
    call crystalline#generate_theme({
          \ 'A':            [[229, 243], ['#fbf1c7', '#7c6f64']],
          \ 'B':            [[243, 250], ['#7c6f64', '#d5c4a1']],
          \ 'Mid':          [[243, 223], ['#7c6f64', '#ebdbb2']],
          \ 'InactiveMid':  [[246, 223], ['#a89984', '#ebdbb2']],
          \ 'NormalModeA':  [[229, 243], ['#fbf1c7', '#7c6f64']],
          \ 'InsertModeA':  [[229, 24],  ['#fbf1c7', '#076678']],
          \ 'VisualModeA':  [[229, 130], ['#fbf1c7', '#af3a03']],
          \ 'ReplaceModeA': [[229, 66],  ['#fbf1c7', '#427b58']],
          \ 'TabType':      [[229, 130], ['#fbf1c7', '#af3a03']],
          \ 'Tab':          [[243, 250], ['#7c6f64', '#d5c4a1']],
          \ 'TabSel':       [[229, 243], ['#fbf1c7', '#7c6f64']],
          \ 'TabMid':       [[229, 229], ['#fbf1c7', '#fbf1c7']],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
