ENVIRON_DIR="$HOME/.environ"
ENVIRON_FILENAME="$ENVIRON_DIR/env_$$_save.env"
ENVIRON_DEBUG=false

mkdir -p "$ENVIRON_DIR" 2> /dev/null

_environ_debug()
{
    if [[ "$ENVIRON_DEBUG" == true ]]; then
        /bin/echo "ENVIRON [debug]: $*"
    fi
}

environ_clear_current_env()
{
    _environ_debug "### Current env ###"
    local old_ifs=$IFS
    IFS="="
    while read -r variable value
    do
        [[ "$variable" == "_" ]] && continue
        _environ_debug "Unsetting $variable"
        unset "$variable" || true
    done <<< "$(env)"
    IFS=$old_ifs
}

environ_load_env()
{
    _environ_debug "Loading environment from $ENVIRON_FILENAME"
    set -a
    source "$ENVIRON_FILENAME"
    set +a
}

environ_save_env()
{
    _environ_debug "Saving environment to $ENVIRON_FILENAME"
    echo -n > "$ENVIRON_FILENAME"
    local old_ifs="$IFS"
    IFS="="
    while read -r variable value
    do
        [[ "$variable" == "_" ]] && continue
        echo "$variable=\"$value\"" >> "$ENVIRON_FILENAME"
        _environ_debug "${variable}=${value}"
    done <<< "$(env)"
    IFS=$old_ifs
    _environ_debug "save done"
}

environ()
{
    local action=""
    for i in "$@"
    do
        case $i in
            load) action="load"; shift ;;
            save) action="save"; shift ;;
            *) echo "unknown option"; return 1;;
        esac
    done
    _environ_debug "action=${action}"

    if [ -z "$action" ]
    then
        echo "No action supplied"
        return 1
    fi

    if [[ "$action" == "save" ]]
    then
        environ_save_env
        return 0
    fi

    if [[ "$action" == "load" ]]
    then
        environ_clear_current_env
        environ_load_env
        return 0
    fi
}

