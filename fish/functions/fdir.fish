function fdir
    FZF_DEFAULT_OPTS="--color=bg+:#1d1f21,fg:#c5c8c6,fg+:#ffffff,bg:#282a36 --border=rounded --margin=0,0" set selected_file (fd --exclude .git --exclude raycast --type f . | fzf-tmux -u 60% --layout=reverse --preview "bat --theme='OneHalfDark' --style=grid,numbers --color=always --line-range=:500 {}" --preview-window=right:60%:wrap)
    if test -n "$selected_file"
        nvim "$selected_file"
    end
end
