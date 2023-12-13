#!/bin/zsh

mt-info() {
    echo "$MT_EMOJI ${MT_UNDERLINE}Running containers${MT_RESET}"

    local current_folder=$(pwd)
    local found_lando_paths=($(mt-get-running-lando-files))

    if [ ${#found_lando_paths[@]} -eq 0 ]; then
        tput cuu1
        tput el
        echo "$MT_EMOJI No Lando projects found."
        return 1
    fi

    local file_content=$(<"$MT_BASE_FOLDER/stubs/go-to-lando-folder-vared")
    eval "$file_content"

    local found_lando_files_num_rows=$(((2 + ${#found_lando_paths[@]}) / 3))
    for ((i = 0; i < ($found_lando_files_num_rows + 2); i++)); do
        tput cuu1
        tput el
    done
    
    cd "$lando_result"

    local lando_name=$(echo "$lando_result" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${lando_name}"

    local lando_info=$(lando info --format json)

    if [ "$#" -eq 0 ]; then
        echo "$lando_info" | jq '.[]'
    else
        local lando_info_for_service=$(echo "$lando_info" | jq ".[] | select(.service == \"$1\")")
        local lando_info_return
        if [ -n "$2" ]; then
            local lando_info_return=$(mt-search-key-recursive "$lando_info_for_service" "$2")
        else
            local lando_info_return="$lando_info_for_service"
        fi

        if [ $(mt-has-multiple-lines "$lando_info_return") -eq 1 ]; then
            echo "$MT_EMOJI ${MT_BOLD}Multiple lines found:${MT_RESET}"
            echo "$lando_info_return"
        else
            echo "$MT_EMOJI ${MT_BOLD}Value found:${MT_RESET} ${lando_info_return}"
        fi
    fi

    cd "$current_folder"
}
