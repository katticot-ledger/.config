function git_commit_browser
    # Define the command to fetch commit history with format for fzf display
    set SEARCH_QUERY "git log --pretty=format:'%C(yellow)%h %Cgreen%ad %Cblue%an %Creset%s' --date=short"

    # Run fzf-tmux with preview to display commit details using bat
    set selected_commit (env FZF_DEFAULT_COMMAND=$SEARCH_QUERY fzf-tmux -u 50 \
        --ansi \
        --layout=reverse \
        --preview-window 'right:60%:wrap' \
        --preview "git show --color=always {1} | bat --paging=always --style=plain" \
        --expect=enter \
        --bind "enter:execute-silent(open $(git config --get remote.origin.url | sed -e 's/\.git$//' -e 's/^git@github.com:/https:\/\/github.com\//')/commit/{1})"
    )

    # Check if a commit was selected (fzf exits if no commit is selected)
    if test -z "$selected_commit"
        echo "No commit selected."
        return
    end
end
