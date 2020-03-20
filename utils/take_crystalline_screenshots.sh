# !!! This script temporarily overwrites your .vimrc, back it up before running any functions !!!

WIN_W=${WIN_W:-640}
WIN_H=${WIN_H:-480}
WIN_X=${WIN_X:-10}
WIN_Y=${WIN_Y:-10}
WAIT_TIME=${WAIT_TIME:-0.1}

SCREENSHOT_DIR=~/crystalline_screenshots

rm -rf "$SCREENSHOT_DIR"
mkdir -p "$SCREENSHOT_DIR"

function take_screenshot() {
    THEME=${1:-default}
    BACKGROUND=${2:-dark}
    MODE=${3:-n}

    if [[ "$BACKGROUND" == "dark" ]]; then
        COLORSCHEME="elflord"
    else
        COLORSCHEME="default"
    fi

    cp ~/.vimrc ~/.vimrc.bkp
    cat <<EOF > ~/.vimrc
set guifont=Inconsolata\\ 13
set background=$BACKGROUND

set showtabline=2
set laststatus=2

call plug#begin('~/.vim/plugged')
    Plug 'rbong/vim-crystalline'
    function! StatusLine(current) abort
        let l:mode = '$MODE'
        let l:mode_label = g:crystalline_mode_labels[l:mode]
        let l:mode_group = g:crystalline_mode_hi_groups[l:mode]
        let l:mode_color = '%#Crystalline' . l:mode_group . '#'
        return l:mode_color . l:mode_label . crystalline#right_sep(l:mode_group, '') . ' [No Name] '
                    \\ . crystalline#right_sep('', 'Fill') . ' master %=' 
                    \\ . crystalline#left_sep('', 'Fill') . ' SPELL ' . crystalline#left_sep(l:mode_group, '')
                    \\ . ' [utf-8][unix] 0/1 0-1 All '
    endfunction
    function! TabLine() abort
        return crystalline#bufferline(0, 0, 0)
    endfunction
    let g:crystalline_enable_sep = 1
    let g:crystalline_statusline_fn = 'StatusLine'
    let g:crystalline_tabline_fn = 'TabLine'
    let g:crystalline_theme = '$THEME'
call plug#end()

colorscheme $COLORSCHEME
EOF

    gvim &
    disown

    sleep $WAIT_TIME
    cp ~/.vimrc.bkp ~/.vimrc

    sleep $WAIT_TIME
    xdotool search --name gvim windowsize 640 480
    xdotool search --name gvim windowmove 10 10

    sleep $WAIT_TIME
    shotgun -g "614x21+12+433" "$SCREENSHOT_DIR/${THEME}_${BACKGROUND}_${MODE}.png"

    pkill -9 gvim
}

function take_screenshots() {
    THEME=${1:-default}
    BACKGROUND=${2:-dark}

    take_screenshot "${THEME}" "${BACKGROUND}" n
    take_screenshot "${THEME}" "${BACKGROUND}" i
    take_screenshot "${THEME}" "${BACKGROUND}" v
    take_screenshot "${THEME}" "${BACKGROUND}" R

    NAME="$HOME/crystalline_screenshots/${THEME}_${BACKGROUND}"
    convert "${NAME}_n.png" "${NAME}_i.png" "${NAME}_v.png" "${NAME}_R.png" -append "${NAME}.png"

    rm -f "${NAME}_n.png" "${NAME}_i.png" "${NAME}_v.png" "${NAME}_R.png"
}

function take_all_screenshots() {
    take_screenshots "badwolf"
    take_screenshots "default"
    take_screenshots "dracula"
    take_screenshots "gruvbox"
    take_screenshots "gruvbox" "light"
    take_screenshots "hybrid"
    take_screenshots "hybrid" "light"
    take_screenshots "jellybeans"
    take_screenshots "molokai"
    take_screenshots "onedark"
    take_screenshots "papercolor" "light"
    take_screenshots "solarized"
    take_screenshots "solarized" "light"
}
