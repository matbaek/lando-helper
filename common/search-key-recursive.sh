#!/bin/zsh

mt-search-key-recursive() {
    local json="$1"
    local key="$2"

    # Check if the current JSON object is an array
    if [[ "$json" == "["* ]]; then
        # If it's an array, loop through its elements
        local length=$(jq length <<< "$json")
        for ((i = 0; i < length; i++)); do
            local element=$(jq ".[$i]" <<< "$json")
            mt-search-key-recursive "$element" "$key"
        done
    elif [[ "$json" == "{"* ]]; then
        # If it's an object, check if the key exists in this object
        local value=$(jq -r ".$key" <<< "$json")
        if [ "$value" != "null" ]; then
            echo "$value"
            return 1
        fi

        # Recursively search in nested objects
        local keys=$(jq -r 'keys | .[]' <<< "$json")
        for k in $keys; do
            local nested_json=$(jq -r ".$k" <<< "$json")
            mt-search-key-recursive "$nested_json" "$key"
        done
    fi

    echo "Key '$key' not found"
}