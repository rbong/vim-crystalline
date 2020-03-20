#!/usr/bin/env bash

set -e

export LC_ALL=C

ITER=${ITER:-100}
VIM_CMD=${VIM_CMD:-vim -N}
OUT=${OUT:-line_performance.log}
DETAILS="${DETAILS:-true}"
BENCHMARK_OTHERS="${BENCHMARK_OTHERS:-true}"

readonly OLD_CWD="$(pwd)"
readonly TEMP_DIR="$(mktemp -dp $OLD_CWD)"

declare -A URLS=( \
  ["crystalline"]="${CRYSTALLINE_URL:-https://github.com/rbong/vim-crystalline}" \
  ["fugitive"]="${FUGITIVE_URL:-https://github.com/tpope/vim-fugitive}" \
)
declare -A BRANCHES=( \
  ['crystalline']="${CRYSTALLINE_BRANCH:-master}" \
)
declare -A VIMRCS=( \
  ['crystalline']="
    function! StatusLine(current, width)
      return (a:current ? crystalline#mode() . crystalline#right_mode_sep('') : '%#CrystallineInactive#')
            \\ . ' %f%h%w%m%r '
            \\ . (a:current ? crystalline#right_sep('', 'Fill') . ' %{fugitive#head()} ' : '')
            \\ . '%=' . (a:current ? crystalline#left_sep('', 'Fill') . ' %{&paste?\"PASTE \":\"\"}%{&spell?\"SPELL \":\"\"}' . crystalline#left_mode_sep('') : '')
            \\ . (a:width > 80 ? ' %{&ft}[%{&fenc!=#\"\"?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : ' ')
    endfunction

    function! TabLine()
      let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
      return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
    endfunction

    let g:crystalline_statusline_fn = 'StatusLine'
    let g:crystalline_tabline_fn = 'TabLine'
    let g:crystalline_theme = 'default'

    set showtabline=2
    set laststatus=2" \
)
declare -A RTPMODS=( \
  ['crystalline']="
    set runtimepath^=$TEMP_DIR/crystalline
    set runtimepath^=$TEMP_DIR/fugitive
    set runtimepath+=$TEMP_DIR/crystalline/after
    set runtimepath+=$TEMP_DIR/fugitive/after" \
)

if [[ ! -z "$OTHER_URL" || ! -z "$OTHER_BRANCH"  ]]; then
  URLS['other']="${OTHER_URL:-https://github.com/runiq/vim-crystalline}"
  BRANCHES['other']="${OTHER_BRANCH:-master}"
  VIMRCS['other']="${OTHER_VIMRC:-${VIMRCS['crystalline']}}"
  RTPMODS['other']="${OTHER_RTPMODS:-${RTPMODS['crystalline']}}"
fi

if [[ "$BENCHMARK_OTHERS" == true ]]; then
  URLS["lightline"]="${LIGHTLINE_URL:-https://github.com/itchyny/lightline.vim}"
  URLS["airline"]="${AIRLINE_URL:-https://github.com/vim-airline/vim-airline}"

  BRANCHES['lightline']="${LIGHTLINE_BRANCH:-master}"
  BRANCHES['airline']="${AIRLINE_BRANCH:-master}"

  VIMRCS['lightline']='
    set showtabline=2
    set laststatus=2'
  VIMRCS['airline']=''
  VIMRCS['airline-opt']='
    let g:airline_extensions = []
    let g:airline_highlighting_cache = 1'
  VIMRCS['vanilla']=''

  RTPMODS['lightline']="
    set runtimepath^=$TEMP_DIR/lightline
    set runtimepath+=$TEMP_DIR/lightline/after"
  RTPMODS['airline']="
    set runtimepath^=$TEMP_DIR/airline
    set runtimepath+=$TEMP_DIR/airline/after"
  RTPMODS['airline-opt']="
    set runtimepath^=$TEMP_DIR/airline
    set runtimepath+=$TEMP_DIR/airline/after"
  RTPMODS['vanilla']=''
fi

MEASURE_TIME="function! MeasureTime(iter)
  for l:i in range(a:iter)
    vsplit
    redraw
    quit
    redraw
  endfor
  qa
endfunction"
TIME="/usr/bin/time -f |%E -o $OUT -a"

function bm() {
  local bmtarget="$1"
  local vimrc="vimrc.$bmtarget"
  cat << EOF > "$vimrc"
$MEASURE_TIME
${RTPMODS["$bmtarget"]}
${VIMRCS["$bmtarget"]}
EOF
  logjust $bmtarget
  $TIME bash -c "for i in \$(seq '"$ITER"'); do
    $VIM_CMD -u "$vimrc" -c q
  done"

  $TIME $VIM_CMD -u "$vimrc" -c "call MeasureTime(${ITER})"
}

function logjust() {
  printf '%-12s' "$*" >> "$OUT"
}

function log() {
  echo $* >> "$OUT"
}

function finish() {
	echo Removing $TEMP_DIR:
	rm -rf "$TEMP_DIR"
}

trap finish EXIT

rm -f "$OUT"
echo logging to "$OUT"

cd "$TEMP_DIR"

echo Cloning statusline repositories
for line in "${!URLS[@]}"; do
  git clone --depth=1 "${URLS[$line]}" "$line"
done
sync

log "Benchmark (x$ITER) | Startup | Redraw"
log "-|-|-"

bm 'crystalline'

if [[ ! -z "$OTHER_URL" || ! -z "$OTHER_BRANCH"  ]]; then
  bm other
fi

if [[ "$BENCHMARK_OTHERS" == true ]]; then
  bm lightline
  bm airline
  bm airline-opt
  bm vanilla
fi

if [[ "$DETAILS" == true ]]; then
  log
  log '<details>'
  log '<summary>Additional information</summary>'
  log
  log "Terminal: $TERM"
  log
  log Vim:
  log '<pre>'
  $VIM_CMD --version >> "$OUT"
  log '</pre></details>'
fi

# Postprocess: Join times that start with '|' to the previous line
sed -Ei ':begin;$!N;s/(.*)\n\|([0-9]+:[0-9]{2}\.[0-9]{2})$/\1 | \2/;tbegin;P;D' "$OUT"

cd "$OLD_CWD"
cp "$TEMP_DIR/$OUT" .

cat "$OUT"
