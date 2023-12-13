#!/bin/zsh

mt-gitkraken() {
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
    echo "$MT_EMOJI ${MT_UNDERLINE}Available git repos${MT_RESET}"

    local folder_paths=$(find '.' -maxdepth 4 -name ".git" -type d | sed 's/^\.\///;s/\/\.git$//')
    local folder_names_sorted=($(echo "$folder_paths" | tr ' ' '\n' | sort))

    for ((i = 1; i < (${#folder_names_sorted[@]} + 1); i++)) {
        echo "$MT_EMOJI ${folder_names_sorted[$i]}"
    }

    local -a compcontext
    local folder_type_folder_path
    local compcontext=($folder_names_sorted)
    vared -p "${MT_EMOJI} Enter a folder: " -c folder_type_folder_path

    local failed=1
    while true; do
        if [ $(mt-is-in-array "$folder_type_folder_path" $folder_names_sorted) = 1 ]; then
            break
        fi

        tput cuu1
        tput el
        vared -p "${MT_EMOJI} Invalid folder. Please enter a valid folder ($failed): " -c folder_type_folder_path
        ((failed++))
    done

    for ((i = 0; i < (${#folder_names_sorted[@]} + 2); i++)); do 
        tput cuu1
        tput el
    done

    echo "$MT_EMOJI ${MT_BOLD}Selected folder:${MT_RESET} ${folder_type_folder_path}"
    cd "$folder_type_folder_path"

    echo "$MT_EMOJI ${MT_BOLD}Opening Gitkraken${MT_RESET}"

    gitkraken -p $(pwd)

    cd "$current_folder"
}