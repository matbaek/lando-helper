#!/bin/zsh

mt-stop() {
    echo "$MT_EMOJI ${MT_UNDERLINE}Running containers${MT_RESET}"
    local current_folder=$(pwd)
    local found_lando_paths=($(mt-get-running-lando-files))
    
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
    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${lando_name}"

    echo "$MT_EMOJI ${MT_BOLD}Stopping lando${MT_RESET}"
    lando stop -y

    cd "$current_folder"
}