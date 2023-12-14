#!/bin/zsh

export MT_BASE_FOLDER=~/lando-helper
export MT_PROJECT_FOLDER=~/projects
export MT_BOLD=$(tput bold)
export MT_UNDERLINE=$(tput sgr 0 1)
export MT_ITALIC=$(tput sitm)
export MT_ORANGE=$(tput setaf 214)
export MT_RESET=$(tput sgr0)
export MT_EMOJI="${MT_ORANGE}${MT_BOLD}MT>${MT_RESET}"
export MT_SETUP_UPDATE=false

for folder in "$MT_BASE_FOLDER"/*; do
    if [ -d "$folder" ] && [[ "$folder" != */stubs ]] && [[ "$folder" != */files ]]; then
        for file in "$folder"/*; do
            if [ -f "$file" ]; then
                source "$file"
            fi
        done
    fi
done

complete -W "composer destroy gitkraken go heidisql info init install-ray-logger install-ray npm phpstorm rebuild size start stop update wp-password docker-down docker-up watch wp yeet" mt

alias ".."="cd .."
alias "..."="cd ~"

mt () {
    if [ "$MT_SETUP_UPDATE" != true ]; then
        echo "$MT_EMOJI Setup not complete. Check README to complete setup."
        return 1
    fi

    if ! command -v awk &>/dev/null; then
        sudo apt-get update -yq
        sudo apt-get install gawk -yq
    fi
    if ! command -v jq &>/dev/null; then
        sudo apt-get update -yq
        sudo apt-get install jq -yq
    fi

    if [ "$1" = "--help" ] || [ "$#" -eq 0 ]; then
        mt-helpers "mt"
        return 1
    fi

    for mt_command in "composer" "destroy" "gitkraken" "go" "heidisql" "info" "init" "install-ray" "install-ray-logger" "npm" "phpstorm" "rebuild" "size" "start" "stop" "update" "wp-password"; do
        if [ "$mt_command" = "$1" ]; then
            shift

            if [ "$1" = "--help" ]; then
                mt-helpers "$mt_command"
                return 1
            fi

            "mt-$mt_command" "$@"
            return 1
        fi
    done

    case "$1" in
        "docker-down")
            # Insert logic to stop Docker
            powershell.exe -Command "taskkill /IM \"Docker Desktop.exe\" /F"
            return 1
            ;;
        "docker-up")
            # Insert logic to open Docker here
            powershell.exe -Command "Start-Process -FilePath \"C:/Program Files/Docker/Docker/Docker Desktop.exe\""
            return 1
            ;;
        "open-heidisql")
            # Insert logic to open HeidiSQL here
            "/mnt/c/Program Files/HeidiSQL/heidisql.exe" "$@" &
            return 1
            ;;
        "open-phpstorm")
            # Insert logic to open PHPStorm here
            "/mnt/c/Users/MathiasBærentsen/AppData/Local/Programs/PhpStorm/bin/phpstorm64.exe" "$@"
            return 1
            ;;
        "watch")
            shift
            mt npm run watch
            return 1
            ;;
        "wp")
            shift
            lando wp "$@"
            return 1
            ;;
        "yeet")
            # Insert logic to stop WSL
            powershell.exe -Command "wsl --shutdown"
            return 1
            ;;
    esac

    echo "$MT_EMOJI <arg1> not valid. Use 'mt' or 'mt --help'."
}

mt-helpers() {
    case "$1" in
        "composer")
            ;;
        "destroy")
            echo "$MT_EMOJI Usage: destroy"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   Destroy the selected Lando app and remove the folder."
            echo ""
            ;;
        "docker")
            ;;
        "docker")
            ;;
        "gitkraken")
            ;;
        "go")
            echo "$MT_EMOJI Usage: go <arg1> [arg2 ... argN]"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mArguments:\e[0m"
            echo "$MT_EMOJI   <arg1>                A directory name (look in \e[96m$MT_PROJECT_FOLDER\e[0m with max-depth of 2)"
            echo "$MT_EMOJI   [arg2 ... argN]       Optional - Directory names (look in the previous argument directory with max-depth of 2)"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   The first argument is required and will be found from \e[96m$MT_PROJECT_FOLDER\e[0m."
            echo "$MT_EMOJI   The function then searches for each subsequent argument as a directory inside the previous one with a max-depth of 2."
            echo ""
            ;;
        "heidisql")
            ;;
        "info")
            ;;
        "init")
            ;;
        "install")
            ;;
        "install")
            ;;
        "npm")
            ;;
        "phpstorm")
            ;;
        "rebuild")
            echo "$MT_EMOJI Usage: rebuild"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   Rebuild the selected Lando app."
            echo ""
            ;;
        "size")
            ;;
        "start")
            echo "$MT_EMOJI Usage: start"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   Start the selected Lando app."
            echo ""
            ;;
        "stop")
            echo "$MT_EMOJI Usage: stop"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   Stop the selected Lando app."
            echo ""
            ;;
        "update")
            echo "$MT_EMOJI Usage: update"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mArguments:\e[0m"
            echo "$MT_EMOJI   [arg1]                Optional - Version tag for a specific version"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   To setup this function, you will need to:"
            echo "$MT_EMOJI   Go to \e[96m$MT_PROJECT_FOLDER/commands/update.sh\e[0m"
            echo "$MT_EMOJI   and insert the downloading of Lando logic here:"
            echo "$MT_EMOJI   - '# Insert logic to download and install Lando'"
            echo "$MT_EMOJI   Go to \e[96m$MT_PROJECT_FOLDER/mt.sh\e[0m"
            echo "$MT_EMOJI   and insert docker start & stop logic here:"
            echo "$MT_EMOJI   - '# Insert logic to open Docker here'"
            echo "$MT_EMOJI   - '# Insert logic to stop Docker'"
            echo ""
            ;;
        "watch")
            ;;
        "wp")
            ;;
#        "wp-queue")
#            echo "$MT_EMOJI Usage: wp-queue <arg1> <arg2> <arg3>"
#            echo "$MT_EMOJI "
#            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
#            echo "$MT_EMOJI   --help                Show this help message"
#            echo "$MT_EMOJI   --force               Whether to force the job to run. (Only used when <arg1>='run')"
#            echo "$MT_EMOJI   --go                  Whether to go to the lando folder"
#            echo "$MT_EMOJI "
#            echo "$MT_EMOJI \e[1;32mArguments:\e[0m"
#            echo "$MT_EMOJI   <arg1>                Queue type: 'start', 'run', 'list'"
#            echo "$MT_EMOJI   <arg2>                Queue name. (Optional if <arg1>='list')"
#            echo "$MT_EMOJI   <arg3>                Queue row id. (Only required for <arg1>='run')"
#            echo ""
#            ;;
        "wp-password")
            echo "$MT_EMOJI Usage: wp-password [arg1]"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mArguments:\e[0m"
            echo "$MT_EMOJI   [arg1]                Optional - String that is set as password"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mBehavior:\e[0m"
            echo "$MT_EMOJI   Changes a password, for a selected Wordpress user, for the selected Lando app."
            echo ""
            ;;
        "yeet")
            ;;
        *)
            echo "$MT_EMOJI #### WIP ####"
            echo "$MT_EMOJI Usage: mt <arg1>"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mOptions:\e[0m"
            echo "$MT_EMOJI   --help                Show this help message or use it together with <arg1>"
            echo "$MT_EMOJI "
            echo "$MT_EMOJI \e[1;32mArguments:\e[0m"
            echo "$MT_EMOJI   <arg1>                See under"
            echo "$MT_EMOJI     composer            Composer in Lando app"
            echo "$MT_EMOJI     destroy             Destroys Lando app and remove folder and all files"
            echo "$MT_EMOJI     docker-down         Shutdown Docker"
            echo "$MT_EMOJI     docker-up           Starts Docker"
            echo "$MT_EMOJI     gitkraken           Open git repo in Gitkraken"
            echo "$MT_EMOJI     go                  Go to folder for argument(s)"
            echo "$MT_EMOJI     heidisql            Open Lando app database in HeidiSQL"
            echo "$MT_EMOJI     info                Gives Lando app info for argument(s)"
            echo "$MT_EMOJI     init                Setup folder and Lando app"
            echo "$MT_EMOJI     install-ray         Install Spatie Ray as MU plugin"
            echo "$MT_EMOJI     install-ray-logger  Install Spatie Ray logger as MU plugin"
            echo "$MT_EMOJI     npm                 Node in Lando app"
            echo "$MT_EMOJI     phpstorm            Open git repo in PHPStorm"
            echo "$MT_EMOJI     rebuild             Rebuilds your Lando app from scratch, preserving data"
            echo "$MT_EMOJI     size                Get the size of all your Lando apps"
            echo "$MT_EMOJI     start               Starts your Lando app"
            echo "$MT_EMOJI     stop                Stops your Lando app"
            echo "$MT_EMOJI     update              Check for new Lando update or specified version, and update/downgrades if available"
            echo "$MT_EMOJI     watch               Wrapper function for 'mt npm run watch'"
            echo "$MT_EMOJI     wp                  WP CLI in Lando app"
#            echo "$MT_EMOJI     wp-queue            Wrapper function for wp queue package"
            echo "$MT_EMOJI     wp-password         Set password for a user"
            echo "$MT_EMOJI     yeet                Shutdown WSL (Windows users)"
            echo ""
            ;;
    esac
}
