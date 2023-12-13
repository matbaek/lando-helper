#!/bin/zsh

mt-go() {
    if [ "$#" -eq 0 ]; then
        echo "$MT_EMOJI Missing <arg1>."
        return 1
    fi

    local matching_folder="$MT_PROJECT_FOLDER"
    for arg in "$@"; do
        local previous_folder="$matching_folder"
        local matching_folder=$(find "$matching_folder" -mindepth 1 -maxdepth 2 -type d -name "${arg}*" -print -quit)
        if [ ! -d "$matching_folder" ]; then
            echo "$MT_EMOJI Folder starting with '$arg' not found in '$previous_folder'."
            return 1
        fi
    done

    echo "$MT_EMOJI ${MT_BOLD}Navigating to:${MT_RESET} ${matching_folder}"

    cd "$matching_folder"
}
