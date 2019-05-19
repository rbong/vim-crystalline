function! crystalline#theme#papercolor#set_theme() abort
  hi CrystallineNormalMode  ctermfg=240 ctermbg=254 guifg=#585858 guibg=#e4e4e4
  hi CrystallineInsertMode  ctermfg=240 ctermbg=254 guifg=#585858 guibg=#e4e4e4
  hi CrystallineVisualMode  ctermfg=24  ctermbg=254 guifg=#005f87 guibg=#e4e4e4
  hi CrystallineReplaceMode ctermfg=161 ctermbg=254 guifg=#d7005f guibg=#e4e4e4
  hi Crystalline            ctermfg=254 ctermbg=31  guifg=#e4e4e4 guibg=#0087af
  hi CrystallineInactive    ctermfg=240 ctermbg=254 guifg=#585858 guibg=#e4e4e4
  hi CrystallineFill        ctermfg=255 ctermbg=24  guifg=#eeeeee guibg=#005f87
  hi CrystallineTab         ctermfg=254 ctermbg=31  guifg=#e4e4e4 guibg=#0087af
  hi CrystallineTabType     ctermfg=254 ctermbg=31  guifg=#e4e4e4 guibg=#0087af
  hi CrystallineTabSel      ctermfg=240 ctermbg=254 guifg=#585858 guibg=#e4e4e4
  hi CrystallineTabFill     ctermfg=255 ctermbg=24  guifg=#eeeeee guibg=#005f87
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
