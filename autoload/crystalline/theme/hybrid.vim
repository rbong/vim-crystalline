function! crystalline#theme#hybrid#set_theme() abort
  if &background ==# 'dark'
    hi CrystallineNormalMode  term=bold cterm=bold gui=bold ctermfg=193 ctermbg=65 guifg=#d7ffaf guibg=#5F875F
    hi CrystallineInsertMode  term=bold cterm=bold gui=bold ctermfg=250 ctermbg=110 guifg=#c5c8c6 guibg=#81a2be
    hi CrystallineVisualMode  term=bold cterm=bold gui=bold ctermfg=250 ctermbg=167 guifg=#c5c8c6 guibg=#cc6666
    hi CrystallineReplaceMode term=bold cterm=bold gui=bold ctermfg=189 ctermbg=60 guifg=#d7d7ff guibg=#5F5F87
    hi Crystalline                                          ctermfg=250 ctermbg=235 guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineInactive                                  ctermfg=243 ctermbg=236 guifg=#707880 guibg=#303030
    hi CrystallineFill                                      ctermfg=250 ctermbg=237 guifg=#c5c8c6 guibg=#373b41
    hi CrystallineTab                                       ctermfg=250 ctermbg=235 guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineTabType                                   ctermfg=250 ctermbg=235 guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineTabSel                                    ctermfg=193 ctermbg=65 guifg=#d7ffaf guibg=#5F875F
    hi CrystallineTabFill                                   ctermfg=250 ctermbg=237 guifg=#c5c8c6 guibg=#373b41
  else
    hi CrystallineNormalMode  term=bold cterm=bold gui=bold ctermfg=22 ctermbg=194 guifg=#005f00 guibg=#d7ffd7
    hi CrystallineInsertMode  term=bold cterm=bold gui=bold ctermfg=16 ctermbg=17 guifg=#000000 guibg=#00005f
    hi CrystallineVisualMode  term=bold cterm=bold gui=bold ctermfg=16 ctermbg=224 guifg=#000000 guibg=#ffd7d7
    hi CrystallineReplaceMode term=bold cterm=bold gui=bold ctermfg=53 ctermbg=189 guifg=#5f005f guibg=#d7d7ff
    hi Crystalline                                          ctermfg=16 ctermbg=252 guifg=#000000 guibg=#d0d0d0
    hi CrystallineInactive                                  ctermfg=59 ctermbg=247 guifg=#5f5f5f guibg=#9e9e9e
    hi CrystallineFill                                      ctermfg=16 ctermbg=250 guifg=#000000 guibg=#bcbcbc
    hi CrystallineTab                                       ctermfg=16 ctermbg=252 guifg=#000000 guibg=#d0d0d0
    hi CrystallineTabType                                   ctermfg=16 ctermbg=252 guifg=#000000 guibg=#d0d0d0
    hi CrystallineTabSel                                    ctermfg=22 ctermbg=194 guifg=#005f00 guibg=#d7ffd7
    hi CrystallineTabFill                                   ctermfg=16 ctermbg=250 guifg=#000000 guibg=#bcbcbc
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
