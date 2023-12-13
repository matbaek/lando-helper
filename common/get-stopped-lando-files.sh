#!/bin/zsh

mt-get-stopped-lando-files() {
    local lando_files=($(find "$MT_PROJECT_FOLDER" -maxdepth 3 -type f -name ".lando.yml" 2>/dev/null))
    local docker_container_names=$(docker ps -a --format "table {{.Names}}" --filter "status=exited" --filter "status=created" --filter "name=appserver")

    local stopped_lando_files=()

    for lando_file in "${lando_files[@]}"; do
        local dirty_container_name=$(grep 'name:' "$lando_file" | cut -d ':' -f 2- | tr -d ' ')
        local stripped_container_name="${dirty_container_name//./}"
        stripped_container_name="${stripped_container_name//-/}"

        if [[ "$docker_container_names" == *"${stripped_container_name}_"* ]]; then
            stopped_lando_files+=("$lando_file")
        fi
    done

    echo "$stopped_lando_files"
    return 1
}
