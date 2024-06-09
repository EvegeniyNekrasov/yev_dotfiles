#!/bin/bash

install_brew() {
    echo "[INFO LOG] Checking if Homebrew is installed..."

    if command -v brew &> /dev/null; then
        echo "[INFO LOG] Homebrew is already installed."
    else
        echo "[INFO LOG] Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            echo "[INFO LOG] Homebrew installed successfully."
        else
            echo "[ERROR LOG] Homebrew installation failed." >&2
            exit 1
        fi
    fi
}

install_eza() {
    echo "[INFO LOG] Checking if eza is installed..."

    if command -v eza &> /dev/null; then
        echo "[INFO LOG] eza is already installed."
    else
        echo "[INFO LOG] eza not found. Installing eza..."
        brew install eza
        if [ $? -eq 0 ]; then
            echo "[INFO LOG] eza installed successfully."
        else
            echo "[ERROR LOG] eza installation failed." >&2
            exit 1
        fi
    fi
}

install_rust() {
    echo "[INFO LOG] Checking if Rust is installed..."

    if command -v rustc &> /dev/null; then
        echo "[INFO LOG] Rust is already installed."
    else
        echo "[INFO LOG] Rust not found. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        if [ $? -eq 0 ]; then
            echo "[INFO LOG] Rust installed successfully."
        else
            echo "[ERROR LOG] Rust installation failed." >&2
            exit 1
        fi
    fi
}

setup_zsh() {
    echo "Setting up Zsh..."

    ZSH_DIR=~/.zsh

    if [ ! -d "$ZSH_DIR/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions.git $ZSH_DIR/zsh-completions
    else
        echo "zsh-completions already exists."
    fi

    if [ ! -d "$ZSH_DIR/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_DIR/zsh-syntax-highlighting
    else
        echo "zsh-syntax-highlighting already exists."
    fi

    if [ ! -d "$ZSH_DIR/zsh-syntax-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_DIR/zsh-autosuggestions
    else
        echo "zsh-syntax-highlighting already exists."
    fi
}

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

    ZSHRC_SOURCE="$(pwd)/zshrc/.zshrc"

    if [ -f "$ZSHRC_SOURCE" ]; then
        # Backup existing ~/.zshrc if it exists
        if [ -f "$HOME/.zshrc" ]; then
            cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
        fi
        
        # Copy the new zshrc file to the home directory
        cp "$ZSHRC_SOURCE" "$HOME/.zshrc"
        
        echo ".zshrc has been replaced with the new one."
    else
        echo "zshrc file not found."
    fi
}

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
install_brew
install_rust
install_eza
setup_zsh
add_symbolic_links
setup_git_config