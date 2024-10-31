function fdir
    set selected_file (fd --exclude raycast --type f . |fzf --tmux 100%,60% --border horizontal  --preview "bat --style=numbers --color=always --line-range=:500 {}")
    if test -n "$selected_file"
        nvim "$selected_file"
    end
end
