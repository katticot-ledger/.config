function nvims
    nvim $(fzf --preview "bat --theme Coldark-Dark --color=always --style=numbers --line-range=:500 {}"  --height 70% --reverse)
end
