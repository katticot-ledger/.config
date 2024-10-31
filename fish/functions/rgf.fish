function rgf
    set search_term $argv[1]

    if test -z "$search_term"
        echo "Please provide a search term."
        return 1
    end

    # Use rg to search for the term and pipe results to fzf-tmux
    rg --column --line-number --no-heading --color=always $search_term | fzf --tmux 70% --ansi --preview 'bat --style=numbers --color=always --line-range=:500 {1}' \
        --bind 'enter:execute(nvim {1}:{2})'
end
