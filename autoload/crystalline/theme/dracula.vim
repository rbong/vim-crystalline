function! crystalline#theme#dracula#set_theme() abort
  hi CrystallineNormalMode                       ctermfg=16  ctermbg=141          guifg=#282a36 guibg=#bd93f9
  hi CrystallineInsertMode                       ctermfg=16  ctermbg=117          guifg=#8be9fd guibg=#282a36
  hi CrystallineVisualMode                       ctermfg=16  ctermbg=84           guifg=#282a36 guibg=#50fa7b
  hi CrystallineReplaceMode                      ctermfg=16  ctermbg=222          guifg=#282a36 guibg=#ffc66d
  hi Crystalline                                 ctermfg=15  ctermbg=61           guifg=#f8f8f2 guibg=#5f6a8e
  hi CrystallineInactive                         ctermfg=15  ctermbg=236          guifg=#f8f8f2 guibg=#44475a
  hi CrystallineFill                             ctermfg=15  ctermbg=236          guifg=#f8f8f2 guibg=#44475a
  hi CrystallineTab                              ctermfg=15  ctermbg=61           guifg=#f8f8f2 guibg=#5f6a8e
  hi CrystallineTabType                          ctermfg=15  ctermbg=61           guifg=#f8f8f2 guibg=#5f6a8e
  hi CrystallineTabSel      term=bold cterm=bold ctermfg=16  ctermbg=141 gui=bold guifg=#282a36 guibg=#bd93f9
  hi CrystallineTabFill                          ctermfg=15  ctermbg=236          guifg=#f8f8f2 guibg=#44475a
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
