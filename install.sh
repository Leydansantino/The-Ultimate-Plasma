#!/bin/bash

# The Ultimate Plasma — Installer
# Compatible with Aurora 43 / Fedora Kinoite — Plasma 6.6
# Installs full theme: Klassy configuration, GTK, colors, typography, plasma theme, look-and-feel

set -e

PLASMA_MIN="6.6"
PLASMA_VERSION=$(plasmashell --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       The Ultimate Plasma Installer      ║"
echo "║         Aurora 43 · Plasma 6.6           ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Check Plasma version ─────────────────────────────────────────────────────
if [[ -z "$PLASMA_VERSION" ]]; then
  echo "⚠️  Could not detect Plasma version. Continuing..."
else
  echo "✔  Plasma detected: $PLASMA_VERSION"
  if [[ "$(echo -e "$PLASMA_VERSION\n$PLASMA_MIN" | sort -V | head -1)" != "$PLASMA_MIN" ]]; then
    echo ""
    echo "✗  This package requires Plasma $PLASMA_MIN or later."
    echo "   Your version ($PLASMA_VERSION) is not compatible."
    exit 1
  fi
fi

echo ""

# ── 1. Inter font ─────────────────────────────────────────────────────────────
echo "→ [1/7] Installing Inter font..."
mkdir -p ~/.local/share/fonts
cp "$SCRIPT_DIR/Inter-VariableFont_opsz,wght.ttf" ~/.local/share/fonts/
cp "$SCRIPT_DIR/Inter-Italic-VariableFont_opsz,wght.ttf" ~/.local/share/fonts/
fc-cache -f ~/.local/share/fonts
echo "   ✔ Inter font installed"

# ── 2. Klassy configuration ───────────────────────────────────────────────────
echo "→ [2/7] Applying Klassy configuration (16px and buttons)..."
mkdir -p ~/.config/klassy

if [ -f "$SCRIPT_DIR/klassyrc" ]; then
    cp "$SCRIPT_DIR/klassyrc" ~/.config/klassy/klassyrc
    echo "   ✔ Klassy configuration applied to ~/.config/klassy/klassyrc"
else
    echo "   ⚠️ Warning: klassyrc file not found in the theme folder."
fi

# ── 3. Color schemes ──────────────────────────────────────────────────────────
echo "→ [3/7] Installing color schemes..."
mkdir -p ~/.local/share/color-schemes
cp "$SCRIPT_DIR/TheUltimatePlasmaDark.colors"  ~/.local/share/color-schemes/
cp "$SCRIPT_DIR/TheUltimatePlasmaLight.colors" ~/.local/share/color-schemes/
echo "   ✔ Color schemes installed"

# ── 4. Plasma Desktop Theme ───────────────────────────────────────────────────
echo "→ [4/7] Installing Plasma Desktop Theme..."
mkdir -p ~/.local/share/plasma/desktoptheme
cp -r "$SCRIPT_DIR/The-Ultimate-Plasma" ~/.local/share/plasma/desktoptheme/
echo "   ✔ Plasma Desktop Theme installed"

echo "   ↻ Rebuilding KDE configuration cache..."
kbuildsycoca6 --noincremental &> /dev/null

# ── 5. Look and Feel ──────────────────────────────────────────────────────────
echo "→ [5/7] Installing Look and Feel (dark and light)..."
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r "$SCRIPT_DIR/The Ultimate Plasma Dark"  ~/.local/share/plasma/look-and-feel/
cp -r "$SCRIPT_DIR/The Ultimate Plasma Light" ~/.local/share/plasma/look-and-feel/
echo "   ✔ Look and Feel installed"

# ── 6. GTK ────────────────────────────────────────────────────────────────────
echo "→ [6/7] Installing GTK 3 and GTK 4 / Libadwaita themes..."
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
cp "$SCRIPT_DIR/gtk-3.0/gtk.css"               ~/.config/gtk-3.0/gtk.css
cp "$SCRIPT_DIR/gtk-4.0/gtk.css"               ~/.config/gtk-4.0/gtk.css
echo "   ✔ GTK installed"

echo "   ↻ Applying Flatpak permissions for themes..."
flatpak override --user --filesystem=$HOME/.themes
flatpak override --user --filesystem=$HOME/.local/share/icons
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

# ── 7. Konsole — adaptive color scheme ───────────────────────────────────────
echo "→ [7/7] Installing Konsole color scheme and adaptive script..."
mkdir -p ~/.local/share/konsole
cp "$SCRIPT_DIR/Adaptive-Plasma.colorscheme" ~/.local/share/konsole/

mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/sync_konsole.sh" ~/.local/bin/sync_konsole.sh
chmod +x ~/.local/bin/sync_konsole.sh

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/sync_konsole.desktop << EOF
[Desktop Entry]
Type=Application
Name=Sync Konsole Colors
Comment=Syncs Konsole colors with the current Plasma theme
Exec=$HOME/.local/bin/sync_konsole.sh
Terminal=false
X-KDE-AutostartEnabled=true
EOF

bash ~/.local/bin/sync_konsole.sh &> /dev/null
echo "   ✔ Konsole configured (autostart registered)"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          ✔ Installation complete         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Log out and back in to apply all changes."
echo ""
echo "Make sure KLASSY is installed and compiled."
echo "(Read the klassy-aurora-kinoite.md guide in this repository if you use Aurora/Kinoite)"
echo ""
echo "Then select your theme in:"
echo "  System Settings → Global Theme"
echo "    → The Ultimate Plasma Dark"
echo "    → The Ultimate Plasma Light"
echo ""
echo "And enable the components in:"
echo "  Window Decorations  → Klassy"
echo "  Application Style   → Klassy"
echo ""
