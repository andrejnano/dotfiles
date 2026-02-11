#!/usr/bin/env bash
# macOS defaults — run once on fresh setup, then after major OS updates
# Some changes require logout/restart to take effect
set -euo pipefail

info() { printf '\033[0;34m[macos]\033[0m %s\n' "$1"; }

# ── Keyboard ─────────────────────────────────────────────
info "Keyboard: fast repeat, no auto-correct"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# ── Trackpad ─────────────────────────────────────────────
info "Trackpad: tap to click, natural scroll"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# ── Finder ───────────────────────────────────────────────
info "Finder: show hidden, extensions, path bar, no .DS_Store on network"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ── Dock ─────────────────────────────────────────────────
info "Dock: auto-hide, small icons, fast animation"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# ── Screenshots ──────────────────────────────────────────
info "Screenshots: save to ~/Screenshots, no shadow"
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ── Mission Control ──────────────────────────────────────
info "Mission Control: don't rearrange spaces"
defaults write com.apple.dock mru-spaces -bool false

# ── Safari (dev) ─────────────────────────────────────────
info "Safari: dev menu, full URL"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# ── Activity Monitor ─────────────────────────────────────
info "Activity Monitor: show all processes, CPU icon in dock"
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor IconType -int 5

# ── Restart affected apps ────────────────────────────────
info "Restarting affected apps..."
for app in "Finder" "Dock" "SystemUIServer" "Safari"; do
  killall "$app" 2>/dev/null || true
done

printf '\n\033[0;32mDone.\033[0m Some changes require logout/restart.\n'
