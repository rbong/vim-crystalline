function! crystalline#theme#default#set_theme() abort
  hi CrystallineNormalMode ctermbg=190 ctermfg=17  guibg=#dfff00 guifg=#00005f
  hi CrystallineInsertMode ctermbg=45  ctermfg=17  guibg=#00dfff guifg=#00005f
  hi CrystallineVisualMode ctermbg=214 ctermfg=232 guibg=#ffaf00 guifg=#000000
  hi CrystallineTabType    ctermbg=190 ctermfg=17  guibg=#dfff00 guifg=#00005f
  hi CrystallineInv term=reverse gui=reverse
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
