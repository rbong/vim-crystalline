function! crystalline#theme#default#set_theme() abort
  hi CrystallineNormalMode  ctermfg=17  ctermbg=190 guifg=#00005f guibg=#dfff00
  hi CrystallineInsertMode  ctermfg=17  ctermbg=45  guifg=#00005f guibg=#00dfff
  hi CrystallineVisualMode  ctermfg=232 ctermbg=214 guifg=#000000 guibg=#ffaf00
  hi CrystallineReplaceMode ctermfg=255 ctermbg=124 guifg=#ffffff guibg=#af0000
  hi Crystalline            ctermfg=255 ctermbg=238 guifg=#ffffff guibg=#444444
  hi CrystallineInactive    ctermfg=239 ctermbg=234 guifg=#4e4e4e guibg=#1c1c1c
  hi CrystallineFill        ctermfg=85  ctermbg=234 guifg=#9cffd3 guibg=#202020
  hi CrystallineTab         ctermfg=255 ctermbg=238 guifg=#ffffff guibg=#444444
  hi CrystallineTabType     ctermfg=255 ctermbg=238 guifg=#ffffff guibg=#444444
  hi CrystallineTabSel      ctermfg=17  ctermbg=190 guifg=#00005f guibg=#dfff00
  hi CrystallineTabFill     ctermfg=85  ctermbg=234 guifg=#9cffd3 guibg=#202020
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
