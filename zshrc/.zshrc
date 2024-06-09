export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

eval "$(starship init zsh)"

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh

export STARSHIP_CONFIG=~/.config/starship.toml

alias cl='clear'

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons"

# Config
alias zshconfig="vim ~/.zshrc"
alias starshipconfig="vim ~/.config/starship.toml"
