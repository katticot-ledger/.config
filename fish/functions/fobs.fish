function fobs
    set base_dir '/Users/keita/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian'

    cd $base_dir
    set selected_file (fd --exclude raycast --type f . | \
       fzf --preview "bat --style=numbers --color=always --line-range=:500 {}" \
       --height 40% \
       --border rounded \
       --preview-window right:60% \
       --bind 'ctrl-/:toggle-preview')

    if test $selected_file
        nvim "$selected_file"
    end
end
