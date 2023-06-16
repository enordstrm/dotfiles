#!/usr/bin/env bash

DOT_ORIGIN_URL="${DOT_ORIGIN:-https://github.com/enordstrm/dotfiles}"
DOT_GIT_DIR="${DOT_GIT_DIR:-${HOME}/.dot.git}"
DOT_BACKUP_DIR="${DOT_BACKUP_DIR:-${HOME}/.dot.bak}"

dot() {
    git --git-dir="${DOT_GIT_DIR}" --work-tree="${HOME}" "$@"
}

main() {
    if [ ! -d "${DOT_GIT_DIR}" ]; then
        git clone --bare "${DOT_ORIGIN_URL}" "${DOT_GIT_DIR}"
    fi

    if [ ! dot checkout ]; then
        echo -n "Files exist, making backup... "
        mkdir -p "${DOT_BACKUP_DIR}"
        dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} \
            ${DOT_BACKUP_DIR}/{}
        echo "done"

        dot checkout
    fi

    # Hide untracked files since work tree is our home directly (by default).
    dot config status.showUntrachedFiles no

    # Explictly add which branches to fetch from the remote "origin". This is
    # not set by default for bare repositories.
    dot config remote.origin.fetch "+refs/heads/*;refs/remotes/origin/*"
}

main "${@}"

