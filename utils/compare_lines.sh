#!/usr/bin/env bash

set -e

export LC_ALL=C

ITER=${ITER:-100}
VIM_CMD=${VIM_CMD:-vim -N}
OUT=${OUT:-line_performance.log}
DETAILS="${DETAILS:-true}"
BENCHMARK_OTHERS="${BENCHMARK_OTHERS:-true}"

declare -A STATUSLINES=( \
  ["crystalline"]="${CRYSTALLINE_CLONE_URL:-https://github.com/rbong/vim-crystalline}" \
  ["fugitive"]="${FUGITIVE_CLONE_URL:-https://github.com/tpope/vim-fugitive}"
)

if [[ "$BENCHMARK_OTHERS" == true ]]; then
  STATUSLINES["lightline"]="${LIGHTLINE_CLONE_URL:-https://github.com/itchyny/lightline.vim}"
  STATUSLINES["airline"]="${AIRLINE_CLONE_URL:-https://github.com/vim-airline/vim-airline}"
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

function logjust() {
  printf '%-12s' "$*" >> "$OUT"
}

function log() {
  echo $* >> "$OUT"
}

rm -f "$OUT"
echo logging to "$OUT"

echo Creating temporary directory
readonly OLD_CWD="$(pwd)"
readonly TEMP_DIR="$(mktemp -dp $OLD_CWD)"
cd "$TEMP_DIR"

echo Cloning statusline repositories
for line in "${!STATUSLINES[@]}"; do
  git clone --depth=1 "${STATUSLINES[$line]}" "$line"
done
sync

log "Benchmark (x$ITER) | Startup | Redraw"
log "-|-|-"

cat <<EOF > vimrc.crystalline
$MEASURE_TIME
set runtimepath^=$TEMP_DIR/crystalline
set runtimepath^=$TEMP_DIR/fugitive
set runtimepath+=$TEMP_DIR/crystalline/after
set runtimepath+=$TEMP_DIR/fugitive/after

function! StatusLine(current, width)
  return (a:current ? crystalline#mode() . crystalline#right_mode_sep('') : '%#CrystallineInactive#')
        \\ . ' %f%h%w%m%r '
        \\ . (a:current ? crystalline#right_sep('', 'Fill') . ' %{fugitive#head()} ' : '')
        \\ . '%=' . (a:current ? crystalline#left_sep('', 'Fill') . ' %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#left_mode_sep('') : '')
        \\ . (a:width > 80 ? ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P ' : ' ')
endfunction

function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'default'

set showtabline=2
set laststatus=2
EOF

logjust crystalline
$TIME bash -c "for i in \$(seq '"$ITER"'); do
  $VIM_CMD -u vimrc.crystalline -c q
done"

$TIME $VIM_CMD -u vimrc.crystalline -c "call MeasureTime(${ITER})"

if [[ "$BENCHMARK_OTHERS" == true ]]; then
  cat <<EOF > vimrc.lightline
  $MEASURE_TIME
  set runtimepath^=$TEMP_DIR/lightline
  set runtimepath+=$TEMP_DIR/lightline/after

  set showtabline=2
  set laststatus=2
EOF

  logjust lightline
  $TIME bash -c "for i in \$(seq '"$ITER"'); do
    $VIM_CMD -u vimrc.lightline -c q
  done"

  $TIME $VIM_CMD -u vimrc.lightline -c "call MeasureTime(${ITER})"

  cat <<EOF > vimrc.airline
  $MEASURE_TIME
  set runtimepath^=$TEMP_DIR/airline
  set runtimepath+=$TEMP_DIR/airline/after
EOF

  logjust airline
  $TIME bash -c "for i in \$(seq '"$ITER"'); do
    $VIM_CMD -u vimrc.airline -c q
  done"

  $TIME $VIM_CMD -u vimrc.airline -c "call MeasureTime(${ITER})"

  cat <<EOF > vimrc.airline-optimized
  $MEASURE_TIME
  set runtimepath^=$TEMP_DIR/airline
  set runtimepath+=$TEMP_DIR/airline/after

  let g:airline_extensions = []
  let g:airline_highlighting_cache = 1
EOF

  logjust airline-opt
  $TIME bash -c "for i in \$(seq '"$ITER"'); do
    $VIM_CMD -u vimrc.airline-optimized -c q
  done"

  $TIME $VIM_CMD -u vimrc.airline-optimized -c "call MeasureTime(${ITER})"

  cat <<EOF > vimrc.vanilla
  $MEASURE_TIME
EOF

  logjust vanilla
  $TIME bash -c "for i in \$(seq '"$ITER"'); do
    $VIM_CMD -u vimrc.vanilla -c q
  done"

  $TIME $VIM_CMD -u vimrc.vanilla -c "call MeasureTime(${ITER})"
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

echo Removing $TEMP_DIR:
rm -rf "$TEMP_DIR"

cat "$OUT"
