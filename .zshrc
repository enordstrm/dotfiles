
export DOT_DIR="${HOME}"
export SHELL=$(which zsh)

zshrc::shell()
{
    source "${DOT_DIR}/.shellrc"
}

zshrc::plugins() 
{
    source "${DOT_DIR}/.zplug/init.zsh"

    # Prompt and its dependencies
    zplug "mafredri/zsh-async"
    zplug "sindresorhus/pure"

    # Fish emulation
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-syntax-highlighting"

    # Install any new plugins
    if ! zplug check; then
        zplug install
    fi

    # Load all installed plugins
    zplug load
}

zshrc::alias() 
{
    source "${DOT_DIR}/.alias"
}

zshrc::settings()
{
    zstyle ':completion:*' menu select
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
}

zshrc::shell
zshrc::settings
zshrc::alias
zshrc::plugins

