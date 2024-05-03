#! /bin/bash

plugin_interpolation_string="\#{tmux_git}"

do_interpolation() {
    local string="$1"
    local interpolated="${string/$plugin_interpolation_string/$(get_git_status)}"
	echo "$interpolated"
}

get_git_status() {
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
        echo " $branch$text "
    fi
}

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main

