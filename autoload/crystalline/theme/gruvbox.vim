function! crystalline#theme#gruvbox#set_theme() abort
  if &background ==# 'dark'
    hi CrystallineNormalMode  ctermfg=235 ctermbg=246 guifg=#282828 guibg=#a89984
    hi CrystallineInsertMode  ctermfg=235 ctermbg=109 guifg=#282828 guibg=#83a598
    hi CrystallineVisualMode  ctermfg=235 ctermbg=208 guifg=#282828 guibg=#fe8019
    hi CrystallineReplaceMode ctermfg=235 ctermbg=108 guifg=#282828 guibg=#8ec07c
    hi Crystalline            ctermfg=246 ctermbg=239 guifg=#a89984 guibg=#504945
    hi CrystallineInactive    ctermfg=243 ctermbg=237 guifg=#7c6f64 guibg=#3c3836
    hi CrystallineFill        ctermfg=246 ctermbg=237 guifg=#a89984 guibg=#3c3836
    hi CrystallineTab         ctermfg=246 ctermbg=239 guifg=#a89984 guibg=#504945
    hi CrystallineTabType     ctermfg=246 ctermbg=239 guifg=#a89984 guibg=#504945
    hi CrystallineTabSel      ctermfg=235 ctermbg=246 guifg=#282828 guibg=#a89984
    hi CrystallineTabFill     ctermfg=235 ctermbg=235 guifg=#282828 guibg=#282828
  else
    hi CrystallineNormalMode  ctermfg=229 ctermbg=243 guifg=#282828 guibg=#a89984
    hi CrystallineInsertMode  ctermfg=229 ctermbg=24  guifg=#282828 guibg=#83a598
    hi CrystallineVisualMode  ctermfg=229 ctermbg=130 guifg=#282828 guibg=#fe8019
    hi CrystallineReplaceMode ctermfg=229 ctermbg=66  guifg=#282828 guibg=#8ec07c
    hi Crystalline            ctermfg=243 ctermbg=250 guifg=#a89984 guibg=#504945
    hi CrystallineInactive    ctermfg=246 ctermbg=223 guifg=#7c6f64 guibg=#3c3836
    hi CrystallineFill        ctermfg=243 ctermbg=223 guifg=#a89984 guibg=#3c3836
    hi CrystallineTab         ctermfg=243 ctermbg=250 guifg=#a89984 guibg=#504945
    hi CrystallineTabType     ctermfg=243 ctermbg=250 guifg=#a89984 guibg=#504945
    hi CrystallineTabSel      ctermfg=229 ctermbg=243 guifg=#282828 guibg=#a89984
    hi CrystallineTabFill     ctermfg=229 ctermbg=229 guifg=#282828 guibg=#282828
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
