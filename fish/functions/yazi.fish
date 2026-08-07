function yazi
    if set -q HERDR_ENV; and test "$HERDR_ENV" = 1
        env ZELLIJ_SESSION_NAME=1 command yazi $argv
    else
        command yazi $argv
    end
end
