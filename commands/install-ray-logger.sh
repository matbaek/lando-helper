#!/bin/zsh

mt-install-ray-logger() {
    local current_folder=$(pwd)
    if [ "$#" -eq 0 ]; then
        echo "$MT_EMOJI ${MT_UNDERLINE}All containers${MT_RESET}"
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
    else
        local lando_result="$current_folder"
    fi
    
    cp "${MT_BASE_FOLDER}/stubs/aaa-ray-logger.php" "$lando_result/wordpress/wp-content/mu-plugins/"
    cd "$current_directory"

    echo "$MT_EMOJI ${MT_BOLD}Ray logger has been installed${MT_RESET}"
}
