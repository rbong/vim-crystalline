function! crystalline#theme#gruvbox#set_theme() abort
  if &background ==# 'dark'
    call crystalline#generate_theme({
          \ 'NormalMode':  [[235, 246], ['#282828', '#a89984']],
          \ 'InsertMode':  [[235, 109], ['#282828', '#83a598']],
          \ 'VisualMode':  [[235, 208], ['#282828', '#fe8019']],
          \ 'ReplaceMode': [[235, 108], ['#282828', '#8ec07c']],
          \ '':            [[246, 239], ['#a89984', '#504945']],
          \ 'Inactive':    [[243, 237], ['#7c6f64', '#3c3836']],
          \ 'Fill':        [[246, 237], ['#a89984', '#3c3836']],
          \ 'Tab':         [[246, 239], ['#a89984', '#504945']],
          \ 'TabType':     [[246, 239], ['#a89984', '#504945']],
          \ 'TabSel':      [[235, 246], ['#282828', '#a89984']],
          \ 'TabFill':     [[235, 235], ['#282828', '#282828']],
          \ })
  else
    call crystalline#generate_theme({
          \ 'NormalMode':  [[229, 243], ['#fbf1c7', '#7c6f64']],
          \ 'InsertMode':  [[229, 24],  ['#fbf1c7', '#076678']],
          \ 'VisualMode':  [[229, 130], ['#fbf1c7', '#af3a03']],
          \ 'ReplaceMode': [[229, 66],  ['#fbf1c7', '#427b58']],
          \ '':            [[243, 250], ['#7c6f64', '#d5c4a1']],
          \ 'Inactive':    [[246, 223], ['#a89984', '#ebdbb2']],
          \ 'Fill':        [[243, 223], ['#7c6f64', '#ebdbb2']],
          \ 'Tab':         [[243, 250], ['#7c6f64', '#d5c4a1']],
          \ 'TabType':     [[243, 250], ['#7c6f64', '#d5c4a1']],
          \ 'TabSel':      [[229, 243], ['#fbf1c7', '#7c6f64']],
          \ 'TabFill':     [[229, 229], ['#fbf1c7', '#fbf1c7']],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
