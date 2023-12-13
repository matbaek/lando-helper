#!/bin/zsh

mt-install-ray() {
    current_folder=$(pwd)
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

    # Change to run outside lando/docker???
    lando ssh -s appserver -c "mkdir -p /app/wordpress/wp-content/mu-plugins/ && \
        cd /app/wordpress/wp-content/mu-plugins/ && \
        rm -f ray.php && \
        rm -rf wordpress-ray && \
        rm -f rm -f spatie-ray.zip && \
        mkdir wordpress-ray && \
        echo \"\<?php require WPMU_PLUGIN_DIR . \'/wordpress-ray/wp-ray.php\'\;\" >> ray.php && \
        cd wordpress-ray && \
        wget -q --show-progress -O spatie-ray.zip https://github.com/spatie/wordpress-ray/releases/latest/download/spatie-ray.zip && \
        unzip -qq spatie-ray.zip && \
        composer install --quiet --no-dev && \
        rm -f spatie-ray.zip"

    cd "$current_folder"

    echo "$MT_EMOJI ${MT_BOLD}Spatie Ray (MU Plugin) has been installed${MT_RESET}"
}