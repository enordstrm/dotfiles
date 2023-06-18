#!/usr/bin/env bash

DOT_ORIGIN_URL="${DOT_ORIGIN:-https://github.com/enordstrm/dotfiles}"
DOT_GIT_DIR="${DOT_GIT_DIR:-${HOME}/.dot.git}"
DOT_BACKUP_DIR="${DOT_BACKUP_DIR:-${HOME}/.dot.bak}"
DOT_TMUX_PLUGIN_INSTALL_SCRIPT="${TMUX_PLUGIN_INSTALL_SCRIPT:-${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh}"

dot::git() {
    git --git-dir="${DOT_GIT_DIR}" --work-tree="${HOME}" "$@"
}

dot::tmux_plugin_install() {
    if [ -f "${DOT_TMUX_PLUGIN_INSTALL_SCRIPT}" ]; then
        ${DOT_TMUX_PLUGIN_INSTALL_SCRIPT}
    else
        echo "Warning: ${DOT_TMUX_PLUGIN_INSTALL_SCRIPT} not found!"
    fi
}

main() {
    if [ ! -d "${DOT_GIT_DIR}" ]; then
        git clone --bare "${DOT_ORIGIN_URL}" "${DOT_GIT_DIR}"
    fi

    # Explictly add which branches to fetch from the remote "origin". This is
    # not set by default for bare repositories.
    #dot config remote.origin.fetch "+refs/heads/*;refs/remotes/origin/*"

    if ! dot::git checkout; then
        echo -n "Files exist, making backup... "
        mkdir -p "${DOT_BACKUP_DIR}"
        dot::git checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} \
            "${DOT_BACKUP_DIR}/{}"
        echo "done"

        dot::git checkout
    fi

    dot::git submodule update --init --recursive

    # Hide untracked files since work tree is our home directly (by default).
    dot::git config status.showUntrachedFiles no

    # Install TMUX plugins
    dot::tmux_plugin_install
}

main "${@}"
