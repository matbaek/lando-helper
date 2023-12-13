#!/bin/zsh

mt-heidisql() {
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
    local lando_info_for_service=$(echo "$lando_info" | jq ".[] | select(.service == \"database\")")
    local lando_info_for_service_database=$(mt-search-key-recursive "$lando_info_for_service" "external_connection")
    local lando_info_for_service_database_port=$(mt-search-key-recursive "$lando_info_for_service_database" "port")

    echo "$MT_EMOJI ${MT_BOLD}Opening HeidiSQL${MT_RESET}"

    mt open-heidisql --host=127.0.0.1 --user=root --port="$lando_info_for_service_database_port" --databases=morningtrainwordpress
    cd "$current_folder"
}
