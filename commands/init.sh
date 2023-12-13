#!/bin/zsh

mt-init() {
    if [ "$#" -eq 0 ]; then
        echo "$MT_EMOJI Missing <arg1>."
        return 1
    fi

    local new_folder = "$MT_PROJECT_FOLDER/$1"

    if [ -d "$new_folder" ]; then
        echo "$MT_EMOJI Folder does already exists."
        return 1
    fi

    local current_folder=$(pwd)
    mkdir "$new_folder"
    cd "$new_folder"

    local lando_name=$(echo "$new_folder" | rev | cut -d'/' -f 1 | rev)
    echo "$MT_EMOJI ${MT_BOLD}Created folder:${MT_RESET} ${new_folder}"

    lando init
    lando start -y

    echo -n "$MT_EMOJI Do you want to install ray? (Y/n): "
    read use_ray
    
    if [ "$use_ray" = "Y" ] || [ "$use_ray" = "y" ]; then
        mt-install-ray "$new_folder"

        tput cuu1
        tput el

        cd "$new_folder"

        echo -n "$MT_EMOJI Do you want to install ray logger? (Y/n): "
        read use_ray_logger

        tput cuu1
        tput el

        if [ "$use_ray_logger" = "Y" ] || [ "$use_ray_logger" = "y" ]; then
            mt-install-ray-logger "$new_folder"
        else
            echo "$MT_EMOJI ${MT_BOLD}Ray logger has not been installed ${MT_RESET}"
        fi

        cd "$new_folder"
    else
        echo "$MT_EMOJI ${MT_BOLD}Ray has not been installed ${MT_RESET}"
    fi

    lando wp config set WP_DEBUG true --raw
    lando wp config set WP_DEBUG_LOG true --raw
    lando wp config set WP_DEBUG_DISPLAY false --raw

    echo "$MT_EMOJI ${MT_BOLD}Lando app created and started${MT_RESET}"

    cd "$current_folder"
}