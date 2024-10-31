function fvim
    # Define the ripgrep prefix
    set rg_prefix "rg --column --line-number --no-heading --color=always --smart-case"

    # Allow passing an initial query, if no query is passed, set to an empty string
    set initial_query "$argv"

    # Run fzf with the given options
    fzf --tmux 70% --ansi --disabled --query "$initial_query" \
        --bind "start:reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
end
