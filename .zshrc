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
    zplug "mafredri/zsh-async", from:github

    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
    export PURE_GIT_PULL=0 # Disable remote update check cause it is slow on large repos

    # Fish emulation
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-history-substring-search"
    #zplug "zsh-users/zsh-syntax-highlighting"
    zplug "zdharma/fast-syntax-highlighting"
    zplug "zsh-users/zsh-completions"
    zplug "felixr/docker-zsh-completion"
    zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"

    # Install any new plugins
    if ! zplug check --verbose; then
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

zshrc::completion()
{
    if [ $commands[helm] ]; then
      source <(helm completion zsh)
    fi
}

zshrc::shell
zshrc::alias
zshrc::plugins
zshrc::zsh
zshrc::local
zshrc::history
zshrc::completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
