function! crystalline#theme#hybrid#set_theme() abort
  if &background ==# 'dark'
    hi CrystallineNormalMode  term=bold cterm=bold gui=bold guifg=#d7ffaf guibg=#5F875F
    hi CrystallineInsertMode  term=bold cterm=bold gui=bold guifg=#c5c8c6 guibg=#81a2be
    hi CrystallineVisualMode  term=bold cterm=bold gui=bold guifg=#c5c8c6 guibg=#cc6666
    hi CrystallineReplaceMode term=bold cterm=bold gui=bold guifg=#d7d7ff guibg=#5F5F87
    hi Crystalline                                          guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineInactive                                  guifg=#707880 guibg=#303030
    hi CrystallineFill                                      guifg=#c5c8c6 guibg=#373b41
    hi CrystallineTab                                       guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineTabType                                   guifg=#c5c8c6 guibg=#282a2e
    hi CrystallineTabSel                                    guifg=#d7ffaf guibg=#5F875F
    hi CrystallineTabFill                                   guifg=#c5c8c6 guibg=#373b41
  else
    hi CrystallineNormalMode  term=bold cterm=bold gui=bold guifg=#005f00 guibg=#d7ffd7
    hi CrystallineInsertMode  term=bold cterm=bold gui=bold guifg=#000000 guibg=#00005f
    hi CrystallineVisualMode  term=bold cterm=bold gui=bold guifg=#000000 guibg=#ffd7d7
    hi CrystallineReplaceMode term=bold cterm=bold gui=bold guifg=#5f005f guibg=#d7d7ff
    hi Crystalline                                          guifg=#000000 guibg=#d0d0d0
    hi CrystallineInactive                                  guifg=#5f5f5f guibg=#9e9e9e
    hi CrystallineFill                                      guifg=#000000 guibg=#bcbcbc
    hi CrystallineTab                                       guifg=#000000 guibg=#d0d0d0
    hi CrystallineTabType                                   guifg=#000000 guibg=#d0d0d0
    hi CrystallineTabSel                                    guifg=#005f00 guibg=#d7ffd7
    hi CrystallineTabFill                                   guifg=#000000 guibg=#bcbcbc
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
