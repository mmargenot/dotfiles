#!/bin/bash
#############################
# Set up a macOS dev machine: install the tools, then link the configs in this
# repo into place. Safe to re-run: anything already installed is skipped.
#############################
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pinned so re-runs don't pull a newer node without the global language servers.
NODE_VERSION="22.23.2"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "bootstrap_macos_dev.sh only supports macOS" >&2
    exit 1
fi

# brew_install <formula> [command it provides]
brew_install() {
    local formula="$1" cmd="${2:-$1}"
    if command -v "$cmd" >/dev/null 2>&1 || brew list --formula "$formula" >/dev/null 2>&1; then
        echo "$formula already installed"
    else
        echo "Installing $formula"
        brew install "$formula"
    fi
}

# npm_global <package> <command it provides>
npm_global() {
    if command -v "$2" >/dev/null 2>&1; then
        echo "$1 already installed"
    else
        echo "Installing $1"
        npm install -g "$1"
    fi
}

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# ghostty
if [ -e /Applications/Ghostty.app ] || [ -e "$HOME/Applications/Ghostty.app" ]; then
    echo "ghostty already installed"
else
    echo "Installing ghostty"
    brew install --cask ghostty
fi

# neovim
brew_install neovim nvim

# herdr: the official installer sets up the desktop app and herdr-core. The
# `herdr` Homebrew formula is a different, terminal-only program.
if [ -e "$HOME/Applications/Herdr.app" ] || [ -e /Applications/Herdr.app ]; then
    echo "herdr already installed"
else
    echo "Installing herdr"
    curl -fsSL https://releases.herdr.dev/app/install.sh | sh
fi

# `herdr` as a shorthand for `herdr-app`
if [ ! -e "$HOME/.local/bin/herdr" ] && [ ! -L "$HOME/.local/bin/herdr" ]; then
    mkdir -p "$HOME/.local/bin"
    ln -s herdr-app "$HOME/.local/bin/herdr"
    echo "linked  $HOME/.local/bin/herdr -> herdr-app"
fi

# tools zsh.config expects
brew_install fzf
brew_install pyenv
brew_install pyenv-virtualenv
brew_install nvm

# node, via nvm. nvm is a shell function and doesn't run under `set -eu`.
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
set +eu
# shellcheck disable=SC1091
. "$(brew --prefix nvm)/nvm.sh"
nvm install "$NODE_VERSION" || exit 1
if [ ! -e "$NVM_DIR/alias/default" ]; then
    nvm alias default "$NODE_VERSION" || exit 1
fi
set -eu

# language servers enabled in vim.config (ruff is installed with the uv tools)
npm_global typescript tsc
npm_global typescript-language-server typescript-language-server
npm_global pyright pyright-langserver

brew_install go
brew_install gopls

# rustup is keg-only, so it isn't on PATH by default.
brew_install rustup
PATH="$(brew --prefix rustup)/bin:$PATH"
if ! rustup show active-toolchain >/dev/null 2>&1; then
    rustup default stable
fi
rustup component add rust-analyzer

# uv and its tools (a tool that is already installed is left as it is)
brew_install uv
uv tool install ruff
uv tool install ty

# configs
"$BASH" "$REPO/dotfiles.sh"
