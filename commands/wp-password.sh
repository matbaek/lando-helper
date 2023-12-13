#!/bin/zsh

mt-wp-password() {
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
    echo "$MT_EMOJI ${MT_UNDERLINE}Available users${MT_RESET}"

    local user_list=$(lando wp user list --fields=ID,display_name,roles)
    local line_count=$(echo -n "$user_list" | wc -l)

    echo $user_list

    vared -p "${MT_EMOJI} Enter a ID: " -c user_id

    for ((i = 0; i < ($line_count + 3); i++)); do
        tput cuu1
        tput el
    done

    echo "$MT_EMOJI ${MT_BOLD}Selected ID:${MT_RESET} ${user_id}"

    lando wp config set WP_DEBUG false --raw --quiet
    lando wp config set WP_DEBUG_LOG false --raw --quiet
    lando wp user update "$user_id" --user_pass="${1:-password}"
    lando wp config set WP_DEBUG true --raw --quiet
    lando wp config set WP_DEBUG_LOG true --raw --quiet

    echo "$MT_EMOJI ${MT_BOLD}User password has been updated to:${MT_RESET} ${1:-password}"

    cd "$current_folder"
}
