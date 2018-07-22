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

zshrc::zsh()
{
    # completion
    zstyle ':completion:*' menu select
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

    # zsh-autosuggestions
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${AUTOSUGGEST_HIGHLIGHT_STYLE}"
    bindkey '^ ' autosuggest-accept

    autoload -U compinit && compinit
    zmodload -i zsh/complist
}

zshrc::history()
{
    export HISTSIZE=999999999
    export SAVEHIST=$HISTSIZE
    export HISTFILE=~/.zsh_history

    setopt share_history
    setopt inc_append_history
}

zshrc::local()
{
    [ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
}

zshrc::shell
zshrc::alias
zshrc::plugins
zshrc::zsh
zshrc::local
zshrc::history

