function ls --wraps='eza --icons' --description 'alias ls eza --icons'
    # Display files in list view with sizes, icons, headers
    eza --long --header --no-user --no-permissions --icons --group-directories-first --color=always --binary
end
