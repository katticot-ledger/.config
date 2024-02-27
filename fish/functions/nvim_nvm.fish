function nvim_nvm --description 'Set Node version using nvm and start Neovim'
    nvm use 18
    command nvim $argv
end
