#!/bin/zsh

mt-rebuild() {
    echo "$MT_EMOJI ${MT_UNDERLINE}All containers${MT_RESET}"
    local current_folder=$(pwd)

    local file_content=$(<"$MT_BASE_FOLDER/stubs/go-to-lando-folder-vared")
    eval "$file_content"

    local found_lando_files_num_rows=$(((2 + ${#lando_paths[@]}) / 3))
    for ((i = 0; i < ($found_lando_files_num_rows + 2); i++)); do
        tput cuu1
        tput el
    done
    
    cd "$lando_result"

    local lando_name=$(echo "$lando_result" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${lando_name}"

    lando rebuild -y --ulimit nofile=262144:262144

    echo "$MT_EMOJI ${MT_BASE_FOLDER}Lando rebuild has been done for:${MT_RESET} ${lando_name}"

    cd "$current_folder"
}