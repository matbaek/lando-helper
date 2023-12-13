#!/bin/zsh

mt-has-multiple-lines() {
    local input_string="$1"
    local line_count=$(echo -n "$input_string" | wc -l)

    if [ "$line_count" -eq 0 ] || [ "$line_count" -eq 1 ]; then
        echo 0
    else
        echo 1
    fi
}