function jir
    set SEARCH_QUERY "jira issue list s~Done -s~ABANDONNED -s~Abandoned --plain --columns id,summary,status"
    env FZF_DEFAULT_COMMAND=$SEARCH_QUERY fzf-tmux -u 40 \
        --layout=reverse \
        --header-lines=1 \
        --preview-window 'right:40%:wrap' \
        --preview "jira issue view {1}" \
        --bind "enter:execute-silent(open https://ledgerhq.atlassian.net/browse/{1})" \
        --bind "m:execute(jira issue move {1})"

end
