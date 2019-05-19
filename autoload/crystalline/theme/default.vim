function! crystalline#theme#default#set_theme() abort
  hi CrystallineNormalMode  ctermbg=190 ctermfg=17  guibg=#dfff00 guifg=#00005f term=NONE gui=NONE
  hi CrystallineInsertMode  ctermbg=45  ctermfg=17  guibg=#00dfff guifg=#00005f term=NONE gui=NONE
  hi CrystallineVisualMode  ctermbg=214 ctermfg=232 guibg=#ffaf00 guifg=#000000 term=NONE gui=NONE
  hi CrystallineReplaceMode ctermbg=124 ctermfg=255 guibg=#af0000 guifg=#ffffff term=NONE gui=NONE
  hi Crystalline            ctermbg=238 ctermfg=255 guibg=#444444 guifg=#ffffff term=NONE gui=NONE
  hi CrystallineInactive    ctermbg=235 ctermfg=239 guibg=#262626 guifg=#4e4e4e term=NONE gui=NONE
  hi CrystallineFill        ctermbg=234 ctermfg=85  guibg=#202020 guifg=#9cffd3 term=NONE gui=NONE
  hi CrystallineTab         ctermbg=235 ctermfg=239 guibg=#262626 guifg=#4e4e4e term=NONE gui=NONE
  hi CrystallineTabType     ctermbg=214 ctermfg=232 guibg=#ffaf00 guifg=#000000 term=NONE gui=NONE
  hi CrystallineTabSel      ctermbg=238 ctermfg=255 guibg=#444444 guifg=#ffffff term=NONE gui=NONE
  hi CrystallineTabFill     ctermbg=234 ctermfg=85  guibg=#202020 guifg=#9cffd3 term=NONE gui=NONE
  hi CrystallineInv term=reverse gui=reverse
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
