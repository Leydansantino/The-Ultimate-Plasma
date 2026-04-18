#!/bin/bash

# The Ultimate Plasma — Uninstaller
# Removes components installed by install.sh
# Keeps: Inter font
# Backs up: plasma-org.kde.plasma.desktop-appletsrc

set -e

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║      The Ultimate Plasma Uninstaller     ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "⚠️  This will remove the theme, Klassy and the GTK configuration."
echo "   The Inter font will NOT be removed."
echo "   The desktop layout will be backed up, not deleted."
echo ""
read -p "Continue? [y/N] " confirm
[[ "$confirm" =~ ^[yY]$ ]] || { echo "Cancelled."; exit 0; }
echo ""

#── Klassy — plugins ──────────────────────────────────────────────────────────
echo "→ Removing Klassy..."

rm -f ~/.local/lib64/libklassycommon6.so
rm -f ~/.local/lib64/libklassycommon6.so.6

rm -f ~/.local/lib64/plugins/styles/klassy6.so
rm -f ~/.local/lib64/plugins/kstyle_config/klassystyleconfig.so
rm -f ~/.local/lib64/plugins/org.kde.kdecoration3/org.kde.klassy.so
rm -f ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
rm -rf ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration

rm -f ~/.local/lib64/qt6/plugins/styles/klassy6.so
rm -f ~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so
rm -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so
rm -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so

rm -f ~/.local/share/applications/kcm_klassydecoration.desktop
rm -f ~/.local/share/applications/klassy-settings.desktop
rm -f ~/.local/share/applications/klassystyleconfig.desktop
rm -f ~/.local/share/color-schemes/KlassyDark.colors
rm -f ~/.local/share/color-schemes/KlassyLight.colors
rm -f ~/.local/share/icons/hicolor/scalable/apps/klassy-settings.svgz
rm -f ~/.local/share/kf6/kcms/kcm_klassydecoration.desktop
rm -f ~/.local/share/kstyle/themes/klassy.themerc
rm -f ~/.local/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop
rm -rf ~/.local/share/plasma/layout-templates/org.kde.klassy.plasma.desktop.bottomPanel
rm -rf ~/.local/share/plasma/layout-templates/org.kde.klassy.plasma.desktop.leftPanel
rm -f ~/.config/klassyrc

echo "   ✔ Klassy removed"

# ── Color schemes ─────────────────────────────────────────────────────────────
echo "→ Removing color schemes..."
rm -f ~/.local/share/color-schemes/TheUltimatePlasmaDark.colors
rm -f ~/.local/share/color-schemes/TheUltimatePlasmaLight.colors
echo "   ✔ Color schemes removed"

# ── Plasma Desktop Theme ──────────────────────────────────────────────────────
echo "→ Removing Plasma Desktop Theme..."
rm -rf ~/.local/share/plasma/desktoptheme/The-Ultimate-Plasma
echo "   ✔ Plasma Desktop Theme removed"

# ── Look and Feel ─────────────────────────────────────────────────────────────
echo "→ Removing Look and Feel..."
rm -rf ~/.local/share/plasma/look-and-feel/The\ Ultimate\ Plasma\ Dark
rm -rf ~/.local/share/plasma/look-and-feel/The\ Ultimate\ Plasma\ Light
echo "   ✔ Look and Feel removed"

# ── GTK ───────────────────────────────────────────────────────────────────────
echo "→ Removing GTK configuration..."
rm -f ~/.config/gtk-3.0/gtk.css
rm -f ~/.config/gtk-4.0/gtk.css
echo "   ✔ GTK configuration removed"

# ── Konsole ───────────────────────────────────────────────────────────────────
echo "→ Removing Konsole configuration..."
rm -f ~/.local/share/konsole/Adaptive-Plasma.colorscheme
rm -f ~/.local/bin/sync_konsole.sh
rm -f ~/.config/autostart/sync_konsole.desktop
echo "   ✔ Konsole configuration removed"

# ── Desktop layout — backup, do not delete ────────────────────────────────────
echo "→ Backing up desktop layout..."
BACKUP="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc.bak-ultimate-plasma"
if [[ -f ~/.config/plasma-org.kde.plasma.desktop-appletsrc ]]; then
  cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc "$BACKUP"
  echo "   ✔ Backup saved to: $BACKUP"
  echo "   (current layout was not modified)"
else
  echo "   (appletsrc not found, nothing to back up)"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          ✔ Uninstall complete            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Log out and back in for Plasma to load the system default theme."
echo ""
echo "The Inter font remains installed. To remove it:"
echo "  rm ~/.local/share/fonts/Inter-*.ttf && fc-cache -f ~/.local/share/fonts"
echo ""
