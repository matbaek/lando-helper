#!/bin/zsh

mt-destroy() {
    echo "$MT_EMOJI ${MT_UNDERLINE}All containers${MT_RESET}"
    local current_folder=$(pwd)

    local file_content=$(<"$MT_BASE_FOLDER/stubs/go-to-lando-folder-vared")
    eval "$file_content"

    local lando_files=($(find "$MT_PROJECT_FOLDER" -maxdepth 3 -type f -name ".lando.yml" 2>/dev/null))
    local lando_files_array=($(echo "$lando_files" | tr ' ' '\n' | sort))
    local lando_files_array_num_rows=$(((2 + ${#lando_files_array[@]}) / 3))
    for ((i = 0; i < ($lando_files_array_num_rows + 2); i++)); do 
        tput cuu1
        tput el
    done

    local lando_name=$(echo "$lando_result" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${lando_name}"
    
    cd "$lando_result"

    lando destroy

    cd "$current_folder"
    rm -rf "$lando_result"

    echo "$MT_EMOJI ${MT_BOLD}Lando app and folder has been removed${MT_RESET}"
}