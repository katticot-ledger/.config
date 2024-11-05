function fobs
    set selected_file (fd --exclude raycast --type f   . '/Users/keita.atticot/Google Drive/My Drive/obsidian' | fzf --preview "bat --style=numbers --color=always --line-range=:500 {}")
    if test -n "$selected_file"
        nvim "$selected_file"
    end
end
