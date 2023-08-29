" See also lua/crystalline.lua

if !has('nvim')
  finish
endif

" Tabline Utils {{{

function! crystalline#TabsOrBuffers(...) abort
  return v:lua.require('crystalline').TabsOrBuffers(get(a:, 1, {}))
endfunction

" }}}
