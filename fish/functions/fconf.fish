function fconf --description "Blazing-fast fuzzy find & edit config files"
    # Base dir: arg > $XDG_CONFIG_HOME > ~/.config
    set -l base_dir (test -n "$argv[1"]; and echo $argv[1]; or echo (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo ~/.config))

    # Quick deps check (fast fail)
    for cmd in fd fzf bat
        type -q $cmd; or begin
            echo "Missing: $cmd (brew install $cmd)" >&2
            return 1
        end
    end

    # Choose editor quickly
    set -l editor (set -q EDITOR; and echo $EDITOR; or begin
        type -q nvim; and echo nvim; or type -q vim; and echo vim; or echo vi
    end)

    # Optional initial query (everything after the 1st arg)
    set -l query (string join " " $argv[2..-1])

    # Fast file list (hidden, follow symlinks, ignore junk)
    set -l files (fd --hidden --follow --color=never --type f \
        --exclude .git --exclude node_modules --exclude raycast \
        . $base_dir)

    test (count $files) -eq 0; and begin
        echo "No files found in: $base_dir"
        return 1
    end

    # fzf tuned for speed: v2 algo, no sort, preview hidden by default
    set -l selected (printf "%s\n" $files | fzf \
        --query="$query" \
        --algo=v2 \
        --no-sort \
        --tiebreak=begin,index \
        --height=85% --layout=reverse --border \
        --prompt=" config> " \
        --multi --cycle \
        --preview='bat --style=plain --color=always --paging=never --line-range=:300 {}' \
        --preview-window=right,60%,wrap,hidden \
        --bind 'alt-p:toggle-preview' \
        --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' \
        --bind 'ctrl-o:execute-silent(open -R {})' \
        --bind 'enter:accept')

    test -z "$selected"; and return

    # Open selection (handles multi-select)
    $editor $selected
end
