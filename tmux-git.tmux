#! /bin/bash

main() {
    colour="colour191"
    path=$(tmux display -p -F '#{pane_current_path}')

    if [[ -d "${path}/.git" ]]; then
        cd "${path}"
        branch=$(git branch --show-current)
        changed=$(git status --porcelain | grep -e '[M|??]' | wc -l | tr -d ' ')

        text=
        if [[ "${changed}" != "0" ]]; then
            text="*"
        else
            text=""
        fi

        prefix="#[fg=$colour]#[bg=$colour,fg=$fg]󱘖 "
        suffix="#[bg=default,fg=$colour]#[bg=default,fg=white]"
        tmux set -ag status-right " $branch$text "
    fi
}

main

