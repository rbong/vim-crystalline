" See also lua/crystalline.lua

if !has('nvim')
  finish
endif

let s:crystalline = v:lua.require('crystalline')

" Statusline Utils {{{

function! crystalline#PlainSep(sep_index, left_group, right_group) abort
  return s:crystalline.PlainSep(a:sep_index, a:left_group, a:right_group)
endfunction

function! crystalline#Sep(sep_index, left_group, right_group) abort
  return s:crystalline.Sep(a:sep_index, a:left_group, a:right_group)
endfunction

" }}}

" Tabline Utils {{{

function! crystalline#DefaultTab(tab, buf, max_width, is_sel) abort
  return s:crystalline.DefaultTab(a:tab, a:buf, a:max_width, a:is_sel)
endfunction

function! crystalline#DefaultHideBuffer(buf) abort
  return s:crystalline.DefaultHideBuffer(a:buf)
endfunction

function! crystalline#TabsOrBuffers(...) abort
  return s:crystalline.TabsOrBuffers(get(a:, 1, {}))
endfunction

" }}}
