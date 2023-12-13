#!/bin/zsh

mt-size() {
    echo "$MT_EMOJI ${MT_UNDERLINE}Size of Lando apps${MT_RESET}"
    
    local lando_files=($(find "$MT_PROJECT_FOLDER" -maxdepth 3 -type f -name ".lando.yml" 2>/dev/null))
    for lando_file in "${lando_files[@]}"; do
        parent_folder=$(dirname "$lando_file")
        if [ -e "$parent_folder" ]; then
            echo "$MT_EMOJI ${MT_ITALIC}Getting size for: $parent_folder"
            size=$(du -sh "$parent_folder" | cut -f1)
            tput cuu1
            tput el
            echo "$MT_EMOJI $parent_folder: $size"
        fi
    done
}
