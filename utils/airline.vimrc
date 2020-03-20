function! Attr(hi, attr)
  return matchstr(a:hi, '\<' . a:attr . '=\zs[0-9#a-zA-Z,]*')
endfunction

function! Group(mode, group, new_group)
  call airline#highlighter#highlight([a:mode], bufnr('%'))
  redir @a | exec 'hi airline_' . a:group | redir END
  let l:hi = @a

  let l:extra = join([Attr(l:hi, 'term'), Attr(l:hi, 'cterm'), Attr(l:hi, 'gui')], ' ')
  if l:extra !~# ' \+'
    let l:extra = ", '" . l:extra . "'"
  else
    let l:extra = ''
  endif

  let l:ret = "        \\ '" . a:new_group . "':"
  let l:ret .= ' [[' . Attr(l:hi, 'ctermfg') . ', ' . Attr(l:hi, 'ctermbg') . ']'
  let l:ret .= ", ['" . Attr(l:hi, 'guifg') . "', '" . Attr(l:hi, 'guibg') . "']"
  let l:ret .= l:extra . "],\n"

  return l:ret
endfunction

function! StealAirlineTheme()
  let l:c = ''

  let l:c .= "  call crystalline#generate_theme({\n"
  let l:c .= Group('normal', 'a', 'NormalMode')
  let l:c .= Group('insert', 'a', 'InsertMode')
  let l:c .= Group('visual', 'a', 'VisualMode')
  let l:c .= Group('replace', 'a', 'ReplaceMode')
  let l:c .= Group('normal', 'b', '')
  let l:c .= Group('normal', 'a_inactive', 'Inactive')
  let l:c .= Group('normal', 'c', 'Fill')
  let l:c .= Group('normal', 'tab', 'Tab')
  let l:c .= Group('normal', 'tabtype', 'TabType')
  let l:c .= Group('normal', 'tabsel', 'TabSel')
  let l:c .= Group('normal', 'tabfill', 'TabFill')
  let l:c .= '        \ })'

  let @+ = l:c
endfunction

call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1
call plug#end()
