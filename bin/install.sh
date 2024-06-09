#!/bin/bash

# Installing rust
install_rust() {
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    if [ $? -eq 0 ]; then
        echo "Rust installed successfully."
    else
        echo "Rust installation failed." >&2
        exit 1
    fi
}

# Setting up Zsh
setup_zsh() {
    echo "Setting up Zsh..."

    ZSH_DIR=~/.zsh

    if [ ! -d "$ZSH_DIR/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions.git $ZSH_DIR/zsh-completions
    else
        echo "zsh-completions already exists."
    fi

    if [ ! -d "$ZSH_DIR/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_DIR/zsh-autosuggestions
    else
        echo "zsh-autosuggestions already exists."
    fi

    if [ ! -d "$ZSH_DIR/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_DIR/zsh-syntax-highlighting
    else
        echo "zsh-syntax-highlighting already exists."
    fi
}

# Adding symbolic links
add_symbolic_links() {
    echo "Creating necessary directories..."
    mkdir -p ~/.config/wezterm

    echo "Creating symbolic links..."
    if [ -f "$(pwd)/gitconfig" ]; then
        ln -is "$(pwd)/gitconfig" ~/.gitconfig
    else
        echo "gitconfig file not found."
    fi

    if [ -f "$(pwd)/wezterm/wezterm.lua" ]; then
        ln -is "$(pwd)/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
    else
        echo "wezterm.lua file not found."
    fi

    if [ -f "$(pwd)/starship/starship.toml" ]; then
        ln -is "$(pwd)/starship/starship.toml" ~/.config/starship.toml
    else
        echo "starship.toml file not found."
    fi

    if [ -f "$(pwd)/zshrc/zshrc" ]; then
        cp -i "$(pwd)/zshrc/zshrc" ~/.zshrc
    else
        echo "zshrc file not found."
    fi
}

# Setting up GIT config
setup_git_config() {
    read -p "Your name for GIT commits: " git_name
    if [[ -z "$git_name" ]]; then
        echo "GIT name cannot be empty." >&2
        exit 1
    fi

    read -p "Your email for GIT commits: " git_email
    if [[ -z "$git_email" ]]; then
        echo "GIT email cannot be empty." >&2
        exit 1
    fi

    echo "" >> ~/.zshrc
    echo "# GIT CONFIG" >> ~/.zshrc
    echo "export GIT_AUTHOR_NAME=\"$git_name\"" >> ~/.zshrc
    echo "export GIT_AUTHOR_EMAIL=\"$git_email\"" >> ~/.zshrc
    echo "export GIT_COMMITTER_NAME=\"$git_name\"" >> ~/.zshrc
    echo "export GIT_COMMITTER_EMAIL=\"$git_email\"" >> ~/.zshrc

    echo "GIT config set up successfully."
}

# Main script execution
install_rust
setup_zsh
add_symbolic_links
setup_git_config

