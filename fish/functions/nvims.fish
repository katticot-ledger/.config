function nvims
    nvim $(fzf-tmux --preview "bat --theme  TwoDark --color=always  --style=numbers --line-range=:500 {}" --height 70% --reverse)
end
