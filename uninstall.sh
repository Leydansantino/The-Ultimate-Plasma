#!/usr/bin/env bash

# The Ultimate Plasma — Uninstaller
# Removes TUP-owned components and restores backed-up user configuration.

set -Eeuo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo
echo "╔══════════════════════════════════════════╗"
echo "║      The Ultimate Plasma Uninstaller     ║"
echo "╚══════════════════════════════════════════╝"
echo
echo "⚠ This will remove The Ultimate Plasma components and restore backed-up"
echo "  Klassy and GTK configuration where available."
echo
echo "  Klassy itself will remain installed."
echo "  The Inter font will remain installed."
echo "  Flatpak theme permissions will remain configured."
echo

read -r -p "Continue? [y/N] " confirm

if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo

# ── Klassy configuration ──────────────────────────────────────────────────────

echo "→ Restoring Klassy configuration..."

KLASSY_BACKUP_DIR="$HOME/.local/state/the-ultimate-plasma/backups/klassy"

restore_klassy_config() {
    local target="$HOME/.config/klassy/klassyrc"
    local backup="$KLASSY_BACKUP_DIR/klassyrc"
    local absent="$KLASSY_BACKUP_DIR/klassyrc.absent"

    if [[ -f "$backup" ]]; then
        mkdir -p "$(dirname "$target")"
        cp -a "$backup" "$target"
        rm -f -- "$backup" "$absent"

        echo "   ✔ Restored previous Klassy configuration"

    elif [[ -f "$absent" ]]; then
        rm -f -- "$target"
        rm -f -- "$absent"

        echo "   ✔ Removed TUP Klassy configuration"

    else
        echo "   • No Klassy backup state found; leaving current configuration untouched"
    fi
}

restore_klassy_config

rmdir "$KLASSY_BACKUP_DIR" 2>/dev/null || true
rmdir "$HOME/.config/klassy" 2>/dev/null || true

echo "   ✔ Klassy configuration handled"

# ── Color schemes ─────────────────────────────────────────────────────────────

echo "→ Removing color schemes..."

rm -f -- \
    "$HOME/.local/share/color-schemes/TheUltimatePlasmaDark.colors" \
    "$HOME/.local/share/color-schemes/TheUltimatePlasmaLight.colors"

echo "   ✔ Color schemes removed"

# ── Plasma Desktop Theme ──────────────────────────────────────────────────────

echo "→ Removing Plasma Desktop Theme..."

rm -rf -- \
    "$HOME/.local/share/plasma/desktoptheme/The-Ultimate-Plasma"

echo "   ✔ Plasma Desktop Theme removed"

# ── Look and Feel ─────────────────────────────────────────────────────────────

echo "→ Removing Look and Feel..."

rm -rf -- \
    "$HOME/.local/share/plasma/look-and-feel/The Ultimate Plasma Dark" \
    "$HOME/.local/share/plasma/look-and-feel/The Ultimate Plasma Light"

echo "   ✔ Look and Feel removed"

# ── GTK ───────────────────────────────────────────────────────────────────────

echo "→ Restoring GTK configuration..."

GTK_BACKUP_DIR="$HOME/.local/state/the-ultimate-plasma/backups/gtk"

restore_gtk_css() {
    local version="$1"
    local target="$HOME/.config/gtk-${version}/gtk.css"
    local backup="$GTK_BACKUP_DIR/gtk-${version}.css"
    local absent="$GTK_BACKUP_DIR/gtk-${version}.absent"

    if [[ -f "$backup" ]]; then
        mkdir -p "$(dirname "$target")"
        cp -a "$backup" "$target"
        rm -f -- "$backup" "$absent"

        echo "   ✔ Restored previous GTK ${version} CSS"

    elif [[ -f "$absent" ]]; then
        rm -f -- "$target"
        rm -f -- "$absent"

        echo "   ✔ Removed TUP GTK ${version} CSS"

    else
        echo "   • No GTK ${version} backup state found; leaving current CSS untouched"
    fi
}

restore_gtk_css "3.0"
restore_gtk_css "4.0"

rmdir "$GTK_BACKUP_DIR" 2>/dev/null || true

echo "   ✔ GTK configuration handled"

# ── Konsole ───────────────────────────────────────────────────────────────────

echo "→ Removing Konsole integration..."

rm -f -- \
    "$HOME/.local/share/konsole/Adaptive-Plasma.colorscheme" \
    "$HOME/.local/bin/sync_konsole.sh" \
    "$HOME/.config/autostart/sync_konsole.desktop"

echo "   ✔ Konsole integration removed"

# ── State cleanup ─────────────────────────────────────────────────────────────

rmdir "$HOME/.local/state/the-ultimate-plasma/backups" 2>/dev/null || true
rmdir "$HOME/.local/state/the-ultimate-plasma" 2>/dev/null || true

# ── KDE cache ─────────────────────────────────────────────────────────────────

if command_exists kbuildsycoca6; then
    echo "→ Rebuilding KDE configuration cache..."

    if kbuildsycoca6 --noincremental &>/dev/null; then
        echo "   ✔ KDE configuration cache rebuilt"
    else
        echo "   ⚠ KDE configuration cache could not be rebuilt immediately."
        echo "     KDE will rebuild it automatically when needed."
    fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo
echo "╔══════════════════════════════════════════╗"
echo "║          ✔ Uninstall complete            ║"
echo "╚══════════════════════════════════════════╝"
echo
echo "The Ultimate Plasma components were removed."
echo
echo "Klassy itself was left installed."
echo "The Inter font was left installed."
echo "Flatpak theme permissions were left unchanged."
echo
echo "Log out and back in for Plasma to fully reload the current configuration."
echo
