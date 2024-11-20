function fobs
    set base_dir '/Users/keita.atticot/Library/CloudStorage/GoogleDrive-keita.atticot@ledger.fr/My Drive/obsidian'
    set selected_file (fd --exclude raycast --type f . $base_dir | sed "s|$base_dir/||" | fzf --preview "bat --style=numbers --color=always --line-range=:500 $base_dir/{}")
    if test $selected_file
        nvim "$base_dir/$selected_file"
    end
end
