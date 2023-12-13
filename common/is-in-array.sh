#!/bin/zsh

mt-is-in-array() {
    local search="$1"
    shift
    local array=("$@")

    for element in "${array[@]}"; do
        if [[ "$element" == "$search" ]]; then
            echo 1
            return 1
        fi
    done

    echo 0
    return 0
}