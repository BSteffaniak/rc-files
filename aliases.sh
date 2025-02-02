#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
    if grep -q Microsoft /proc/version; then
        alias pbcopy='clip.exe'
    else
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
    fi
fi

function reload-session() {
    # shellcheck disable=SC1090
    . ~/.profile
    . ~/.bashrc
}

function devship() {
    airship --use-links "$@"
}

function nvims() {
    nvim -c 'lua Handle_load_session()' "$@"
}

function cmd() {
    /mnt/c/Windows/System32/cmd.exe /c "$@"
}

function cmdenv() {
    env_vars=""
    VARS_ARRAY="$(sed 'y/;/ /' <<<"$VARS")"
    while IFS='=' read -r -d '' n v; do
        if [[ " ${VARS_ARRAY[*]} " =~ [[:space:]]${n}[[:space:]] ]]; then
            local line="${n}=${v}"
            if [[ -z "$env_vars" ]]; then
                env_vars="set $line"
            else
                env_vars="$env_vars&& set $line"
            fi
        fi
    done < <(env -0)

    echo "cmd.exe /V /C \"$env_vars&& $*\""
    cmd.exe /V /C "$env_vars&& $*"
}

function wincmdenv() {
    wd="$(pwd)"
    mnt_wd="${wd/"$HOME"/"$BRADE"}"

    if [[ ! -d $mnt_wd ]]; then
        read -p "mnt directory \"$mnt_wd\" doesn't exist. Try creating it? (y/n)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting"
            return 1
        fi

        mkdir -p "$mnt_wd"
    fi

    echo "cmdenv $*"

    (
        cd "$mnt_wd" || exit 1
        cmdenv "$@"
    )
}

function wincmd() {
    wd="$(pwd)"
    mnt_wd="${wd/"$HOME"/"$BRADE"}"

    if [[ ! -d $mnt_wd ]]; then
        read -p "mnt directory \"$mnt_wd\" doesn't exist. Try creating it? (y/n)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting"
            return 1
        fi

        mkdir -p "$mnt_wd"
    fi

    echo "cmd $*"

    (
        cd "$mnt_wd" || exit 1
        cmd "$@"
    )
}

function wincd() {
    wd="$(pwd)"
    mnt_wd="${wd/"$HOME"/"$BRADE"}"

    if [[ ! -d $mnt_wd ]]; then
        read -p "mnt directory \"$mnt_wd\" doesn't exist. Try creating it? (y/n)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting"
            return 1
        fi

        mkdir -p "$mnt_wd"
    fi

    cd "$mnt_wd" || return 1
}

function winsync() {
    wd="$(pwd)"
    mnt_wd="${wd/"$HOME"/"$BRADE"}"

    if [[ ! -d $mnt_wd ]]; then
        read -p "mnt directory \"$mnt_wd\" doesn't exist. Try creating it? (y/n)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting"
            return 1
        fi

        mkdir -p "$mnt_wd"
    fi

    local excludes=()
    if [[ -f ".gitignore" ]]; then
        excludes+=(--exclude-from='.gitignore')
    fi

    while read -r filename; do
        if [[ -f "$filename" ]]; then
            excludes+=(--exclude-from="$filename")
        fi
    done <<<"$(find . -name '.gitignore')"

    echo "rsync $* -r --exclude={'.','..','.git'} ${excludes[*]} $* ./* .* \"$mnt_wd\""

    rsync "$@" \
        -r \
        --exclude={'.','..','.git'} \
        "${excludes[@]}" \
        "$@" \
        ./* .* \
        "$mnt_wd"
}

function wingsync() {
    wd="$(pwd)"
    mnt_wd="${wd/"$HOME"/"$BRADE"}"

    if [[ ! -d $mnt_wd ]]; then
        read -p "mnt directory \"$mnt_wd\" doesn't exist. Try creating it? (y/n)? " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting"
            return 1
        fi

        git clone "$(git remote get-url origin)" --depth 1 "$mnt_wd" || return 1
    fi

    local files=()
    while read -r filename; do
        if [[ -f "$filename" ]]; then
            files+=("$filename")
        fi
    done <<<"$(git ls-files --others --exclude-standard --modified)"

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files to copy"
        return 0
    fi

    (
        cd "$mnt_wd" || return 1
        wincmd git add . || return 1
        wincmd git stash || return 1
        wincmd git pull || return 1
    )

    echo "rsync $* -R ${files[*]} \"$mnt_wd\""

    rsync "$@" \
        -R \
        "${files[@]}" \
        "$mnt_wd"
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
