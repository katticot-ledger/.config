function ll --wraps=ls
    # Display files in list view with sizes, icons, headers, and hidden files
    eza --long --header --all --no-user --no-permissions --icons --group-directories-first --color=always --binary
end
