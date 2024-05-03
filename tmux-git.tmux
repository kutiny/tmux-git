#! /bin/bash

# showGitStatus() {
    local colour="colour191"
    local path=$(tmux display -p -F '#{pane_current_path}')

    if [[ -d "${path}/.git" ]]; then
        cd "${path}"
        local branch=$(git branch --show-current)
        local changed=$(git status --porcelain | grep -e '[M|??]' | wc -l | tr -d ' ')

        text=
        if [[ "${changed}" != "0" ]]; then
            text="*"
        else
            text=""
        fi

        local prefix="#[fg=$colour]#[bg=$colour,fg=$fg]󱘖 "
        local suffix="#[bg=default,fg=$colour]#[bg=default,fg=white]"
        set -ag status-right " $branch$text "
    fi
# }

