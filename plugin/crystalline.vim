scriptencoding utf-8

" Deprecations {{{

if exists('g:crystalline_statusline_fn')
  echoerr 'g:crystalline_statusline_fn is deprecated, use function! g:CrystallineStatuslineFn'
endif

if exists('g:crystalline_tabline_fn')
  echoerr 'g:crystalline_tabline_fn is deprecated, use function! g:CrystallineTablineFn'
endif

if exists('g:crystalline_hide_buf_tab')
  echoerr "g:crystalline_hide_buf_tab is deprecated, use function! g:CrystallineHideBufferFn"
endif

if exists('g:crystalline_tab_separator')
  echoerr "g:crystalline_tab_separator is deprecated, see :help crystalline#buffers_or_tabs()"
endif

" }}}

" Helper Variables {{{

if !exists('g:crystalline_mode_labels')
  let g:crystalline_mode_labels = {
        \ 'n': ' NORMAL ',
        \ 'c': ' COMMAND ',
        \ 'r': ' NORMAL ',
        \ '!': ' NORMAL ',
        \ 'i': ' INSERT ',
        \ 't': ' TERMINAL ',
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
        \ 'c': 'CommandMode',
        \ 'r': 'NormalMode',
        \ '!': 'NormalMode',
        \ 'i': 'InsertMode',
        \ 't': 'TerminalMode',
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

if !exists('g:crystalline_tabs_tab_type_label')
  let g:crystalline_tabs_tab_type_label = ' TABS '
endif

if !exists('g:crystalline_buffers_tab_type_label')
  let g:crystalline_buffers_tab_type_label = ' BUFFERS '
endif

if !exists('g:crystalline_tab_min_path_parts')
  let g:crystalline_tab_min_path_parts = 3
endif

if !exists('g:CrystallineTabFn') && !exists('*g:CrystallineTabFn')
  function! g:CrystallineTabFn(buf, max_width, is_sel) abort
    return crystalline#default_tab(a:buf, a:max_width, a:is_sel)
  endfunction
endif

if !exists('g:CrystallineHideBufferFn') && !exists('*g:CrystallineHideBufferFn')
  function! g:CrystallineHideBufferFn(buf) abort
    return crystalline#default_hide_buffer(a:buf)
  endfunction
endif

let g:crystalline_sep_hi_groups = {}
let g:crystalline_skip_sep_groups = {}
let g:crystalline_alt_sep_groups = {}
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

if !exists('g:crystalline_theme_styles')
  let g:crystalline_theme_styles = [
        \ { 'name': '', 'airline_style': 'normal' },
        \ { 'name': 'Inactive', 'airline_style': 'inactive' },
        \ { 'name': 'NormalMode', 'airline_style': 'normal' },
        \ { 'name': 'CommandMode', 'airline_style': 'commandline' },
        \ { 'name': 'InsertMode', 'airline_style': 'insert' },
        \ { 'name': 'VisualMode', 'airline_style': 'visual' },
        \ { 'name': 'ReplaceMode', 'airline_style': 'replace' },
        \ { 'name': 'TerminalMode', 'airline_style': 'terminal' },
        \ ]
endif

let g:crystalline_theme_groups = [
      \ { 'name': 'A', 'airline_group': ['', 'airline_a'] },
      \ { 'name': 'B', 'airline_group': ['', 'airline_b'] },
      \ { 'name': 'Fill', 'airline_group': ['', 'airline_c'] },
      \ { 'name': 'Tab', 'airline_group': ['inactive', 'airline_c'] },
      \ { 'name': 'TabSel', 'airline_group': ['', 'airline_a'] },
      \ { 'name': 'TabFill', 'airline_group': ['', 'airline_x'] },
      \ { 'name': 'TabType', 'airline_group': ['', 'airline_b'] },
      \ ]

let g:crystalline_theme_attrs = [
      \ [0, 0, 'ctermfg'],
      \ [0, 1, 'ctermbg'],
      \ [1, 0, 'guifg'],
      \ [1, 1, 'guibg'],
      \ ]

let g:crystalline_max_theme_variants = 5

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
