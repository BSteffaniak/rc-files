# "Run Commands" files

### Setup

1. Clone the repo: `git clone git@github.com:BSteffaniak/rc-files.git ~/.rc-files`
1. Load the env in the rc file:
    * Bash:
        ```
        printf '\n[ -f ~/.rc-files/env.sh ] && . ~/.rc-files/env.sh' >>~/.bashrc
        ```
    * Powershell:
        ```
        cat $env:userprofile/.rc-files/Microsoft.PowerShell_profile.ps1 >>$profile
        ```
