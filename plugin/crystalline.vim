scriptencoding utf-8

" Deprecations {{{

if exists('g:crystalline_statusline_fn')
  echoerr 'g:crystalline_statusline_fn is deprecated, use function! g:CrystallineTablineFn'
endif

if exists('g:crystalline_tabline_fn')
  echoerr 'g:crystalline_tabline_fn is deprecated, use function! g:CrystallineTablineFn'
endif

if exists('g:crystalline_tab_separator')
  echoerr 'g:crystalline_tab_separator is deprecated, use g:crystalline_tab_sep_index'
endif

" }}}

" Helper Variables {{{

if !exists('g:crystalline_mode_labels')
  let g:crystalline_mode_labels = {
        \ 'n': ' NORMAL ',
        \ 'c': ' NORMAL ',
        \ 'r': ' NORMAL ',
        \ '!': ' NORMAL ',
        \ 'i': ' INSERT ',
        \ 't': ' INSERT ',
        \ 'v': ' VISUAL ',
        \ 'V': ' VISUAL ',
        \ '': ' VISUAL ',
        \ 's': ' VISUAL ',
        \ 'S': ' VISUAL ',
        \ '': ' VISUAL ',
        \ 'R': ' REPLACE ',
        \ '': '',
        \ }
endif

if !exists('g:crystalline_mode_hi_groups')
  let g:crystalline_mode_hi_groups = {
        \ 'n': 'NormalMode',
        \ 'c': 'NormalMode',
        \ 'r': 'NormalMode',
        \ '!': 'NormalMode',
        \ 'i': 'InsertMode',
        \ 't': 'InsertMode',
        \ 'v': 'VisualMode',
        \ 'V': 'VisualMode',
        \ '': 'VisualMode',
        \ 's': 'VisualMode',
        \ 'S': 'VisualMode',
        \ '': 'VisualMode',
        \ 'R': 'ReplaceMode',
        \ '': '',
        \ }
endif

if !exists('g:crystalline_separators')
  let g:crystalline_separators = [
        \ { 'ch': '', 'alt_ch': '', 'dir': '>' },
        \ { 'ch': '', 'alt_ch': '', 'dir': '<' },
        \ ]
endif

if type(get(g:crystalline_separators, 0, {})) != v:t_dict
  echoerr "crystalline: detected deprecated use of strings in g:crystalline_separators, use { 'ch': '<character>', 'dir': '>' }"
endif

if !exists('g:crystalline_tab_sep_index')
  let g:crystalline_tab_sep_index = 0
endif

if !exists('g:crystalline_tab_empty')
  let g:crystalline_tab_empty = '[No Name]'
endif

if !exists('g:crystalline_tab_mod')
  let g:crystalline_tab_mod = '[+]'
endif

if !exists('g:crystalline_tab_left')
  let g:crystalline_tab_left = ' '
endif

if !exists('g:crystalline_tab_nomod')
  let g:crystalline_tab_nomod = ' '
endif

if !exists('g:CrystallineTablabelFn') && !exists('*g:CrystallineTablabelFn')
  let g:CrystallineTablabelFn = function('crystalline#default_tablabel')
endif

let g:crystalline_sep_hi_groups = {}
let g:crystalline_same_bg_sep_groups = {}
let g:crystalline_sep_cache = {}

let g:crystalline_syn_modes = ['term', 'cterm', 'gui']

let g:crystalline_syn_attrs = [
      \ 'font',
      \ 'bold',
      \ 'italic',
      \ 'reverse',
      \ 'standout',
      \ 'underline',
      \ 'undercurl',
      \ 'strikethrough'
      \ ]

let g:crystalline_syn_colors = ['fg', 'bg', 'sp']

if !exists('g:crystalline_theme')
  let g:crystalline_theme = 'default'
endif

" }}}

" Load User Settings {{{

if exists('g:CrystallineTablineFn') || exists('*g:CrystallineTablineFn')
  call crystalline#init_tabline()
endif

if exists('g:CrystallineStatuslineFn') || exists('*g:CrystallineStatuslineFn')
  call crystalline#init_statusline()
endif

call crystalline#apply_current_theme()

" }}}

" Setup autogroups {{{

augroup CrystallineTheme
  au!
  au ColorScheme * call crystalline#apply_current_theme()
  au OptionSet background call crystalline#apply_current_theme()
augroup END

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
