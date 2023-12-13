#!/bin/zsh

mt-npm() {
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
    echo "$MT_EMOJI ${MT_UNDERLINE}Available npm pahts${MT_RESET}"

    local searchable_folder_paths=''
    if [ -d './plugins' ]; then
      searchable_folder_paths+=('./plugins')
    fi
    if [ -d './themes' ]; then
      searchable_folder_paths+=('./themes')
    fi

    local folder_paths=$(find $searchable_folder_paths -maxdepth 5 -name "package.json" -type f -not -path "*/vendor/*" -not -path "*/node_modules/*" -not -path "*/modules/*" | sed 's|^\./||;s|/[^/]*$||')
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

    echo "$MT_EMOJI ${MT_BOLD}Selected Git repo:${MT_RESET} ${folder_type_folder_path}"
    cd "$folder_type_folder_path"

    echo "$MT_EMOJI ${MT_BOLD}Running command:${MT_RESET} npm ${@}"

    lando npm "$@" -y

    cd "$current_folder"
}