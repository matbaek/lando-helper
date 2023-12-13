#!/bin/zsh

mt-update() {
    if [ "$MT_SETUP_UPDATE" != true ]; then
        echo "$MT_EMOJI Setup of 'mt update' hasn't been done. Look at 'mt --help'."
        return 1
    fi

    echo "$MT_EMOJI Getting latest version of Lando."
    local installed_version=$(lando version)

    if [ -n "$1" ]; then
        local latest_lando_version="$1"
    else
        local latest_lando_version=$(curl -s https://api.github.com/repos/lando/lando/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    fi

    if [ -z "$latest_lando_version" ]; then
        echo "$MT_EMOJI Couldn't get the lastest version of Lando. Try again later or check if there is a problem with github."
        return 1
    fi

    echo "$MT_EMOJI Install version: $installed_version"
    
    if [ -n "$1" ]; then
        echo "$MT_EMOJI Chosen version: $latest_lando_version"
    else
        echo "$MT_EMOJI Latest version: $latest_lando_version"
    fi

    if [[ "$installed_version" == "$latest_lando_version" ]]; then
        return 1
    fi

    local install_latest_lando_version
    vared -p "${MT_EMOJI} Do you want to install $latest_lando_version? (Y/n): " -c install_latest_lando_version
    if [ "$install_latest_lando_version" != "Y" ] && [ "$install_latest_lando_version" != "y" ]; then
        return 1
    fi    

    lando poweroff

    mt docker-down

    local is_docker_closed
    vared -p "${MT_EMOJI} Is Docker closed? (Y/n): " -c is_docker_closed
    if [ "$is_docker_closed" != "Y" ] && [ "$is_docker_closed" != "y" ]; then
        return 1
    fi
    
    local current_folder=$(pwd)

    if [ ! -d "$MT_BASE_FOLDER/update" ]; then
        mkdir "$MT_BASE_FOLDER/update"
    fi

    cd "$MT_BASE_FOLDER/update"

    # https://docs.lando.dev/getting-started/installation.html
    # Insert logic to download and install Lando

    #wget https://files.lando.dev/installer/lando-x64-stable.deb
    #sudo dpkg -i --ignore-depends=docker-ce lando-x64-stable.deb
    wget "https://github.com/lando/lando/releases/download/$latest_lando_version/lando-x64-$latest_lando_version.deb"
    sudo dpkg -i --ignore-depends=docker-ce "lando-x64-$latest_lando_version.deb"

    cd "$current_folder"
    rm -rf "$MT_BASE_FOLDER/update"

    echo "$MT_EMOJI Starter Docker Desktop"
    mt docker-up
    
    echo "$MT_EMOJI Lando version $latest_lando_version has been installed."
}