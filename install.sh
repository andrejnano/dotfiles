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
brew bundle --file="$DOTFILES/Brewfile" --no-lock
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

link_file "$DOTFILES/vim/vimrc"                "$HOME/.vimrc"
link_file "$DOTFILES/zsh/zshrc"                "$HOME/.zshrc"
link_file "$DOTFILES/git/gitconfig"            "$HOME/.gitconfig"
link_file "$DOTFILES/git/gitignore_global"     "$HOME/.gitignore_global"
link_file "$DOTFILES/tmux/tmux.conf"           "$HOME/.tmux.conf"
link_file "$DOTFILES/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
link_file "$DOTFILES/ripgrep/ripgreprc"        "$HOME/.ripgreprc"
link_file "$DOTFILES/starship/starship.toml"   "$HOME/.config/starship.toml"
link_file "$DOTFILES/ssh/config"               "$HOME/.ssh/config"

# ── Directories ──────────────────────────────────────────

mkdir -p "$HOME/.vim/undo"
ok "~/.vim/undo directory"

mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh"
chmod 700 "$HOME/.ssh/sockets" 2>/dev/null || true
ok "~/.ssh/sockets directory"

mkdir -p "$HOME/Screenshots"
ok "~/Screenshots directory"

# ── Hushlogin ────────────────────────────────────────────

touch "$HOME/.hushlogin"
ok "~/.hushlogin (suppress 'Last login' message)"

# ── macOS defaults ───────────────────────────────────────

if [ "$(uname)" = "Darwin" ]; then
  info "Applying macOS defaults..."
  bash "$DOTFILES/macos/defaults.sh"
  ok "macOS defaults"
fi

# ── Done ─────────────────────────────────────────────────

printf '\n\033[0;32mDone.\033[0m\n'
printf 'Open a new terminal tab to load the new shell config.\n'
if [ -d "$BACKUP_DIR" ]; then
  printf 'Backups saved to: %s\n' "$BACKUP_DIR"
fi
