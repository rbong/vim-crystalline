function! crystalline#theme#dracula#set_theme() abort
  hi CrystallineNormalMode ctermbg=141 ctermfg=16 guibg=#bd93f9 guifg=#282a36
  hi CrystallineInsertMode ctermbg=117 ctermfg=16 guibg=#8be9fd guifg=#282a36
  hi CrystallineVisualMode ctermbg=84  ctermfg=16 guibg=#50fa7b guifg=#282a36
  hi CrystallineTabType    ctermbg=141 ctermfg=16 guibg=#bd93f9 guifg=#282a36
  hi CrystallineInv term=reverse gui=reverse
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
