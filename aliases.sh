#!/bin/bash

function reload-session() {
    # shellcheck disable=SC1090
    . ~/.bashrc
}

function devship() {
    airship --use-links "$@"
}

function nvims() {
    nvim -c 'lua Handle_load_session()' "$@"
}

function cmd() {
    cmd.exe /c "$@"
}

function set-flat-logging-levels() {
    export LOGGING_LABEL_LOGGING_LEVELS="$1"
}

# shellcheck disable=SC2120
enable-flat-logging() {
    local level=$1
    local show_prefix=$2
    local prefix_separator=$3
    local suffix=$4

    [[ -z $level ]] && level=DEBUG
    [[ -z $show_prefix ]] && show_prefix=true
    [[ -z $prefix_separator ]] && prefix_separator='
'
    [[ -z $suffix ]] && suffix='
'

    set-flat-logging-levels "*:$level"
    export LOGGING_DEFAULT_SHOW_PREFIX="$show_prefix"
    export LOGGING_DEFAULT_PREFIX_SEPARATOR="$prefix_separator"
    export LOGGING_DEFAULT_SUFFIX="$suffix"
}

disable-flat-logging() {
    unset LOGGING_LABEL_LOGGING_LEVELS
    unset LOGGING_DEFAULT_SHOW_PREFIX
    unset LOGGING_DEFAULT_PREFIX_SEPARATOR
    unset LOGGING_DEFAULT_SUFFIX
}

reset-flat-logging() {
    disable-flat-logging
    enable-flat-logging
}

unmarshal-dynamodb() {
    jq -f ~/unmarshal_dynamodb.jq "$1"
}

benchmark() {
    for i in {1..400000}; do
        echo -e '\r'
        echo -e "Iteration $i:\r"
        echo -e '\033[0K\033[1mBold\033[0m \033[7mInvert\033[0m \033[4mUnderline\033[0m'
        echo -e '\033[0K\033[1m\033[7m\033[4mBold & Invert & Underline\033[0m'
        echo
        echo -e '\033[0K\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
        echo -e '\033[0K\033[1m\033[4m\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
        echo
        echo -e '\033[0K\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo -e '\033[0K\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo
        echo -e '\033[0K\033[30m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        echo -e '\033[0K\033[30m\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
    done
}
