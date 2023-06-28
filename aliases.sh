#!/bin/bash

function reload-session() {
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
