scriptencoding utf-8

" Deprecations {{{

if exists('g:crystalline_statusline_fn')
  echoerr 'g:crystalline_statusline_fn is deprecated, use function! g:CrystallineStatuslineFn'
endif

if exists('g:crystalline_tabline_fn')
  echoerr 'g:crystalline_tabline_fn is deprecated, use function! g:CrystallineTablineFn'
endif

if exists('g:crystalline_hide_buf_tab')
  echoerr 'g:crystalline_hide_buf_tab is deprecated, use function! g:CrystallineHideBufferFn'
endif

if exists('g:crystalline_tab_separator')
  echoerr 'g:crystalline_tab_separator is deprecated, see :help crystalline#BuffersOrTabs()'
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
elseif !has_key(g:crystalline_mode_labels, 'c')
  echoerr 'crystalline: outdated g:crystalline_mode_labels detected, define all of the groups in :help g:crystalline_mode_labels'
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
elseif !has_key(g:crystalline_mode_hi_groups, 'c')
  echoerr 'crystalline: outdated g:crystalline_mode_labels detected, define all of the groups in :help g:crystalline_mode_labels'
endif

if !exists('g:crystalline_auto_prefix_groups')
  let g:crystalline_auto_prefix_groups = v:false
endif

if !exists('g:crystalline_group_suffix')
  let g:crystalline_group_suffix = ''
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
  if has('nvim')
    lua vim.g.CrystallineTabFn = require('crystalline').DefaultTab
  else
    function! g:CrystallineTabFn(tab, buf, max_width, is_sel) abort
      return crystalline#DefaultTab(a:tab, a:buf, a:max_width, a:is_sel)
    endfunction
  endif
endif

if !exists('g:CrystallineHideBufferFn') && !exists('*g:CrystallineHideBufferFn')
  if has('nvim')
    lua vim.g.CrystallineHideBufferFn = require('crystalline').DefaultHideBuffer
  else
    function! g:CrystallineHideBufferFn(buf) abort
      return crystalline#DefaultHideBuffer(a:buf)
    endfunction
  endif
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

if !exists('g:crystalline_theme_airline_styles')
  let g:crystalline_theme_airline_styles = [
        \ ['', 'normal'],
        \ ['Inactive', 'inactive'],
        \ ['NormalMode', 'normal'],
        \ ['CommandMode', 'commandline'],
        \ ['InsertMode', 'insert'],
        \ ['VisualMode', 'visual'],
        \ ['ReplaceMode', 'replace'],
        \ ['TerminalMode', 'terminal'],
        \ ]
endif

if !exists('g:crystalline_theme_styles')
  let g:crystalline_theme_styles = [
        \ '',
        \ 'Inactive',
        \ 'NormalMode',
        \ 'CommandMode',
        \ 'InsertMode',
        \ 'VisualMode',
        \ 'ReplaceMode',
        \ 'TerminalMode',
        \ ]
endif

if !exists('g:crystalline_theme_airline_sections')
  let g:crystalline_theme_airline_sections = [
        \ ['A', ['', 'airline_a']],
        \ ['B', ['', 'airline_b']],
        \ ['Fill', ['', 'airline_c']],
        \ ['Tab', ['inactive', 'airline_c']],
        \ ['TabSel', ['', 'airline_a']],
        \ ['TabFill', ['', 'airline_x']],
        \ ['TabType', ['', 'airline_b']],
        \ ]
endif

if !exists('g:crystalline_theme_sections')
  let g:crystalline_theme_sections = [
        \ 'A',
        \ 'B',
        \ 'Fill',
        \ 'Tab',
        \ 'TabSel',
        \ 'TabFill',
        \ 'TabType',
        \ ]
endif

if !exists('g:crystalline_theme_airline_variants')
  let g:crystalline_theme_airline_variants = [
        \ ['', ''],
        \ ['1', '_modified'],
        \ ['2', '_paste']
        \ ]
endif

if !exists('g:crystalline_theme_variants')
  let g:crystalline_theme_variants = ['', '1', '2']
endif

let g:crystalline_theme_attrs = [
      \ [0, 0, 'ctermfg'],
      \ [0, 1, 'ctermbg'],
      \ [1, 0, 'guifg'],
      \ [1, 1, 'guibg'],
      \ ]

let g:crystalline_inactive = 0

" }}}

" Load User Settings {{{

if exists('g:CrystallineTablineFn') || exists('*g:CrystallineTablineFn')
  call crystalline#InitTabline()
endif

if exists('g:CrystallineStatuslineFn') || exists('*g:CrystallineStatuslineFn')
  call crystalline#InitStatusline()
endif

call crystalline#ApplyCurrentTheme()

" }}}

" Setup Autogroups {{{

augroup CrystallineTheme
  au!
  au ColorScheme * call crystalline#ApplyCurrentTheme()
  au OptionSet background call crystalline#ApplyCurrentTheme()
augroup END

" }}}

" vim:set et sw=2 ts=2 fdm=marker:
