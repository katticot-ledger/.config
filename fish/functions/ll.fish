function ll --wraps=ls
    # Display files in list view with sizes, icons, headers, and hidden files
    # Use $argv to specify a directory, or default to the current directory if no argument is given
    eza --long --header --all --no-user --no-permissions --icons --group-directories-first --color=always --binary $argv
end
