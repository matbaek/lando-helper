#!/bin/zsh

mt-start() {
    echo "$MT_EMOJI ${MT_UNDERLINE}Not running containers${MT_RESET}"
    local current_folder=$(pwd)
    local found_lando_paths=($(mt-get-stopped-lando-files))
    
    if [ ${#found_lando_paths[@]} -eq 0 ]; then
        echo "$MT_EMOJI No Lando projects found."
        return 1
    fi

    local file_content=$(<"$MT_BASE_FOLDER/stubs/go-to-lando-folder-vared")
    eval "$file_content"

    local lando_files_array=($(echo "$found_lando_paths" | tr ' ' '\n' | sort))
    local lando_files_array_num_rows=$(((2 + ${#lando_files_array[@]}) / 3))
    for ((i = 0; i < ($lando_files_array_num_rows + 2); i++)); do 
        tput cuu1
        tput el
    done
    
    cd "$lando_result"

    local lando_name=$(echo "$lando_result" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Starting lando for: ${lando_name}${MT_RESET}"
    lando start -y --ulimit nofile=262144:262144

    cd "$current_folder"
}
