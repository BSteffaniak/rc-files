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
