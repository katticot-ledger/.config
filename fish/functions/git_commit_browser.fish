function git_commit_browser
    # Define the command to fetch commit history with format for fzf display
    set SEARCH_QUERY "git log --pretty=format:'%C(yellow)%h %Cgreen%ad %Cblue%an %Creset%s' --date=short"

    # Run fzf-tmux with a preview to display commit details and tags
    env FZF_DEFAULT_COMMAND=$SEARCH_QUERY fzf-tmux -u 50 \
        --ansi \
        --layout=reverse \
        --exact \
        --nth=3,4 \
        --delimiter=" " \
        --preview-window 'right:60%:wrap' \
        --preview "
            echo -e '\033[1;35m🔖 Tags:\033[0m';  
            git tag --contains {1} || echo -e '\033[31mNo tags found\033[0m';
            echo -e '\033[1;34m───────────────────────────────────────────────\033[0m';
            echo -e '\033[1;32mCommit Details:\033[0m';
            git show --color=always {1} | bat --paging=always --style=plain
        " \
        --bind "enter:execute(open (string replace '.git' '' (string replace 'git@github.com:' 'https://github.com/' (git config --get remote.origin.url)))/commit/{1})" \
        --bind "ctrl-t:execute(tmux new-window -n 'Commit Tags' 'echo 🔖 Tags for {1}; git tag --contains {1} || echo No tags found; read')"
end
