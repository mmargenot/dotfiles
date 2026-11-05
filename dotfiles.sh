#!/bin/bash
#############################
# Symlink the configs in this repo into place. Safe to re-run: correct links
# are left alone, and anything else is backed up to ~/.dotfiles-backup first.
#
# Secrets do not belong in this public repo: put them in ~/.zshrc.local.
#############################
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# link <file in repo> <destination>
link() {
    local src="$REPO/$1" dest="$2"

    if [ "$(readlink "$dest" || true)" = "$src" ]; then
        echo "ok      $dest"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # Backups can hold secrets, so keep them private.
        (umask 077 && mkdir -p "$BACKUP")
        local saved="$BACKUP/${dest#"$HOME"/}"
        mkdir -p "$(dirname "$saved")"
        cp -RP "$dest" "$saved"
        echo "backup  $dest -> $saved"
    fi

    # Swap in one rename so running apps never see the file missing.
    ln -s "$src" "$dest.dotfiles-tmp.$$"
    mv -f "$dest.dotfiles-tmp.$$" "$dest"
    echo "linked  $dest"
}

# shell
link zsh.config "$HOME/.zshrc"
link zprofile.config "$HOME/.zprofile"

# vim / neovim
mkdir -p "$HOME/.vim/tmp" "$HOME/.vim/.undo" "$HOME/.vim/.swp"
link vim.config "$HOME/.vimrc"
link init.vim "$HOME/.config/nvim/init.vim"

# git
link git.config "$HOME/.gitconfig"

# ruff
link ruff.toml "$HOME/.config/ruff/ruff.toml"

# herdr: mods are linked file by file so the stubs herdr generates beside them
# stay out of the repo.
link herdr/herdr-core/config.toml "$HOME/.config/herdr-core/config.toml"
link herdr/herdr-app/keys.json "$HOME/.config/herdr-app/keys.json"
link herdr/herdr-app/settings.json "$HOME/.config/herdr-app/settings.json"
for mod in tmux-prefix worktree-prefixed; do
    for file in main.js mod.json; do
        link "herdr/herdr-app/mods/$mod/$file" "$HOME/.config/herdr-app/mods/$mod/$file"
    done
done

# OS-specific
case "$(uname -s)" in
    Darwin)
        link ghostty.config "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
        ;;
    Linux)
        link ghostty.config "$HOME/.config/ghostty/config"
        link bash.config "$HOME/.bashrc"
        ;;
esac

if [ ! -f "$HOME/.zshrc.local" ]; then
    echo "note: no ~/.zshrc.local yet; create it for API keys and other secrets"
fi
