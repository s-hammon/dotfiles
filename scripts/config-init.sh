#!/usr/bin/env bash
DOTFILES_REPO="git@github.com:s-hammon/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles.bk"

# clone if not already present
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "Bare repo already exists at $DOTFILES_DIR"
fi

function config {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# checkout dotfiles
if config checkout >/dev/null 2>&1; then
    echo "Checked out dotfiles from origin"
else
    echo "Conflict detected. Moving existing dotfiles to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | while read -r file; do
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$file" "$BACKUP_DIR/$file"
    done

    if config checkout >/dev/null 2>&1; then
        echo "Successfully checked out dotfiles after backup."
    else
        echo "Error: failed to checkout dotfiles after backup."
        exit 1
    fi
fi

# checkout dotfiles
config config status.showUntrackedFiles no
echo "Dotfiles initialization complete."
