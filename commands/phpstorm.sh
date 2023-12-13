#!/bin/zsh

mt-phpstorm() {
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
    
    cd "$lando_result"

    local lando_name=$(echo "$lando_result" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${lando_name}"

    echo "$MT_EMOJI ${MT_BOLD}Opening PHPStorm${MT_RESET}"

    mt open-phpstorm $(wslpath -w .) >/dev/null

    cd "$current_folder"
}