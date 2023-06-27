# "Run Commands" files

### Setup

1. Clone the repo: `git clone git@github.com:BSteffaniak/rc-files.git ~/.rc-files`
1. Load the files in the rc files:
    * Zsh: `printf '\n. ~/.rc-files/restore-history.sh' >> ~/.zshrc`
    * Bash:
        ```
        printf '\n. ~/.rc-files/config.sh' >> ~/.bashrc
        printf '\n. ~/.rc-files/restore-history.sh' >> ~/.bashrc
        ```
