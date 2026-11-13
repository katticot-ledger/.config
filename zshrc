
# Octop
export PATH="/Users/keita/.octop/bin:$PATH"

# Completions
fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit
compinit

# fzf-tab
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

