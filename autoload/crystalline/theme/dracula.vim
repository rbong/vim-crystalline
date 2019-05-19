function! crystalline#theme#dracula#set_theme() abort
  hi CrystallineNormalMode  ctermbg=141 ctermfg=16  guibg=#bd93f9 guifg=#282a36 term=NONE gui=NONE
  hi CrystallineInsertMode  ctermbg=117 ctermfg=16  guibg=#8be9fd guifg=#282a36 term=NONE gui=NONE
  hi CrystallineVisualMode  ctermbg=84  ctermfg=16  guibg=#50fa7b guifg=#282a36 term=NONE gui=NONE
  hi CrystallineReplaceMode ctermbg=222 ctermfg=16  guibg=#ffc66d guifg=#282a36 term=NONE gui=NONE
  hi Crystalline            ctermbg=236 ctermfg=15  guibg=#44475a guifg=#f8f8f2 term=NONE gui=NONE
  hi CrystallineInactive    ctermbg=235 ctermfg=61  guibg=#21222c guifg=#6272a4 term=NONE gui=NONE
  hi CrystallineFill        ctermbg=234 ctermfg=15  guibg=#191a21 guifg=#f8f8f2 term=NONE gui=NONE
  hi CrystallineTab         ctermbg=235 ctermfg=61  guibg=#21222c guifg=#6272a4 term=NONE gui=NONE
  hi CrystallineTabType     ctermbg=61  ctermfg=15  guibg=#5f6a8e guifg=#f8f8f2 term=NONE gui=NONE
  hi CrystallineTabSel      ctermbg=236 ctermfg=15  guibg=#44475a guifg=#f8f8f2 term=NONE gui=NONE
  hi CrystallineTabFill     ctermbg=234 ctermfg=15  guibg=#191a21 guifg=#f8f8f2 term=NONE gui=NONE
  hi CrystallineInv term=reverse gui=reverse
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
