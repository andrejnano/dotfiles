#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ── Helpers ──────────────────────────────────────────────

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

link_file() {
  local src="$1" dst="$2"

  # Already correct symlink
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "$dst (already linked)"
    return
  fi

  # Backup existing file
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    warn "backed up $dst → $BACKUP_DIR/"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dst")"

  ln -s "$src" "$dst"
  ok "$dst → $src"
}

# ── Homebrew ─────────────────────────────────────────────

info "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew"

info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile" --no-lock 2>/dev/null || true
ok "Brew packages"

# ── Oh My Zsh ────────────────────────────────────────────

info "Checking Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ok "Oh My Zsh"

# ── Symlinks ─────────────────────────────────────────────

info "Linking dotfiles..."

link_file "$DOTFILES/vim/vimrc"               "$HOME/.vimrc"
link_file "$DOTFILES/zsh/zshrc"               "$HOME/.zshrc"
link_file "$DOTFILES/git/gitconfig"           "$HOME/.gitconfig"
link_file "$DOTFILES/tmux/tmux.conf"          "$HOME/.tmux.conf"
link_file "$DOTFILES/aerospace/aerospace.toml" "$HOME/.aerospace.toml"

# ── Directories ──────────────────────────────────────────

mkdir -p "$HOME/.vim/undo"
ok "~/.vim/undo directory"

# ── macOS defaults ───────────────────────────────────────

if [ "$(uname)" = "Darwin" ]; then
  info "Applying macOS defaults..."

  # Key repeat speed
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Show file extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Disable press-and-hold for keys (enables key repeat everywhere)
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Disable smart quotes and dashes (breaks code in terminals)
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  ok "macOS defaults (restart apps to apply)"
fi

# ── Done ─────────────────────────────────────────────────

printf '\n\033[0;32mDone.\033[0m\n'
printf 'Open a new terminal tab to load the new shell config.\n'
if [ -d "$BACKUP_DIR" ]; then
  printf 'Backups saved to: %s\n' "$BACKUP_DIR"
fi
