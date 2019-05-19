function! crystalline#theme#solarized#set_theme() abort
  if &background ==# 'dark'
    hi CrystallineNormalMode  term=bold cterm=bold ctermfg=230 ctermbg=245 gui=bold guifg=#fdf6e3 guibg=#93a1a1
    hi CrystallineInsertMode  term=bold cterm=bold ctermfg=230 ctermbg=136 gui=bold guifg=#fdf6e3 guibg=#b58900
    hi CrystallineVisualMode  term=bold cterm=bold ctermfg=230 ctermbg=125 gui=bold guifg=#fdf6e3 guibg=#d33682
    hi CrystallineReplaceMode term=bold cterm=bold ctermfg=230 ctermbg=160 gui=bold guifg=#fdf6e3 guibg=#dc322f
    hi Crystalline                                 ctermfg=254 ctermbg=241          guifg=#eee8d5 guibg=#657b83
    hi CrystallineInactive                         ctermfg=235 ctermbg=241          guifg=#073642 guibg=#657b83
    hi CrystallineFill                             ctermfg=240 ctermbg=235          guifg=#586e75 guibg=#073642
    hi CrystallineTab                              ctermfg=254 ctermbg=241          guifg=#eee8d5 guibg=#657b83
    hi CrystallineTabType                          ctermfg=254 ctermbg=241          guifg=#eee8d5 guibg=#657b83
    hi CrystallineTabSel      term=bold cterm=bold ctermfg=230 ctermbg=245 gui=bold guifg=#fdf6e3 guibg=#93a1a1
    hi CrystallineTabFill                          ctermfg=240 ctermbg=235          guifg=#586e75 guibg=#073642
  else
    hi CrystallineNormalMode  term=bold cterm=bold ctermfg=254 ctermbg=241 gui=bold guifg=#eee8d5 guibg=#657b83
    hi CrystallineInsertMode  term=bold cterm=bold ctermfg=254 ctermbg=136 gui=bold guifg=#eee8d5 guibg=#b58900
    hi CrystallineVisualMode  term=bold cterm=bold ctermfg=254 ctermbg=125 gui=bold guifg=#eee8d5 guibg=#d33682
    hi CrystallineReplaceMode term=bold cterm=bold ctermfg=254 ctermbg=160 gui=bold guifg=#eee8d5 guibg=#dc322f
    hi Crystalline                                 ctermfg=254 ctermbg=245          guifg=#eee8d5 guibg=#93a1a1
    hi CrystallineInactive                         ctermfg=254 ctermbg=244          guifg=#eee8d5 guibg=#839496
    hi CrystallineFill                             ctermfg=245 ctermbg=254          guifg=#93a1a1 guibg=#eee8d5
    hi CrystallineTab                              ctermfg=254 ctermbg=245          guifg=#eee8d5 guibg=#93a1a1
    hi CrystallineTabType                          ctermfg=254 ctermbg=245          guifg=#eee8d5 guibg=#93a1a1
    hi CrystallineTabSel      term=bold cterm=bold ctermfg=254 ctermbg=241 gui=bold guifg=#eee8d5 guibg=#657b83
    hi CrystallineTabFill                          ctermfg=245 ctermbg=254          guifg=#93a1a1 guibg=#eee8d5
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
