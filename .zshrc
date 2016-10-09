
export DOT_DIR="$(dirname "$(readlink -f "$0")")"

zshrc::shell_load()
{
    source "${DOT_DIR}/shellrc"
}

zshrc::plugins() {
    source "${DOT_DIR}/zplug/init.zsh"

    # Prompt and its dependencies
    zplug "mafredri/zsh-async"
    zplug "sindresorhus/pure"

    # Fish emulation
    #zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-syntax-highlighting"
    zplug "zsh-users/zsh-history-substring-search"

    # Install any new plugins
    if ! zplug check; then
        zplug install
    fi

    # Load all installed plugins
    zplug load
}

source "${DOT_DIR}/alias"

[ -r "$HOME/.workrc" ] && source "$HOME/.workrc"

zshrc::shell_load
zshrc::plugins

