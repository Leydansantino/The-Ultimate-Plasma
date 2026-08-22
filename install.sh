#!/usr/bin/env bash

# The Ultimate Plasma — Installer
# HOME-only installation for immutable KDE Plasma systems.

set -Eeuo pipefail

PLASMA_MIN="6.6"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

die() {
    echo "✗ $*" >&2
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# ── Environment detection ─────────────────────────────────────────────────────

if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
fi

DISTRO_NAME="${PRETTY_NAME:-${NAME:-Unknown Linux}}"

PLASMA_VERSION=""

if command_exists plasmashell; then
    PLASMA_VERSION="$(
        plasmashell --version 2>/dev/null |
        grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' |
        head -n 1 || true
    )"
fi

echo
echo "╔══════════════════════════════════════════╗"
echo "║       The Ultimate Plasma Installer      ║"
echo "╚══════════════════════════════════════════╝"
echo
echo "System: $DISTRO_NAME"

if [[ -n "$PLASMA_VERSION" ]]; then
    echo "Plasma: $PLASMA_VERSION"
else
    echo "Plasma: unable to detect"
fi

echo

# ── Requirements ──────────────────────────────────────────────────────────────

command_exists cp ||
    die "Required command not found: cp"

command_exists mkdir ||
    die "Required command not found: mkdir"

command_exists grep ||
    die "Required command not found: grep"

command_exists sort ||
    die "Required command not found: sort"

command_exists fc-cache ||
    die "Required command not found: fc-cache"

command_exists kbuildsycoca6 ||
    die "Required KDE command not found: kbuildsycoca6"

install_file() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"
    cp -a "$source" "$target"
}

install_tree() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp -a "$source" "$target"
}

if ! command_exists flatpak; then
    echo "⚠ Flatpak was not found."
    echo "  Flatpak theme permissions will be skipped."
fi

if [[ -z "$PLASMA_VERSION" ]]; then
    echo "⚠ Could not detect the Plasma version."
    echo "  Continuing without Plasma version validation."
elif ! version_ge "$PLASMA_VERSION" "$PLASMA_MIN"; then
    die "KDE Plasma ${PLASMA_MIN} or newer is required (detected ${PLASMA_VERSION})."
fi

# ── Payload validation ─────────────────────────────────────────────────────────

required_files=(
    "Inter-VariableFont_opsz,wght.ttf"
    "Inter-Italic-VariableFont_opsz,wght.ttf"
    "TheUltimatePlasmaDark.colors"
    "TheUltimatePlasmaLight.colors"
    "Adaptive-Plasma.colorscheme"
    "gtk-3.0/gtk.css"
    "gtk-4.0/gtk.css"
    "sync_konsole.sh"
)

required_dirs=(
    "The-Ultimate-Plasma"
    "The Ultimate Plasma Dark"
    "The Ultimate Plasma Light"
)

for file in "${required_files[@]}"; do
    [[ -f "$SCRIPT_DIR/$file" ]] ||
        die "Required payload file not found: $file"
done

for dir in "${required_dirs[@]}"; do
    [[ -d "$SCRIPT_DIR/$dir" ]] ||
        die "Required payload directory not found: $dir"
done

echo "✔ Environment checks passed"
echo

# ── 1. Inter font ─────────────────────────────────────────────────────────────
echo "→ [1/7] Installing Inter font..."
install_file \
    "$SCRIPT_DIR/Inter-VariableFont_opsz,wght.ttf" \
    "$HOME/.local/share/fonts/Inter-VariableFont_opsz,wght.ttf"

install_file \
    "$SCRIPT_DIR/Inter-Italic-VariableFont_opsz,wght.ttf" \
    "$HOME/.local/share/fonts/Inter-Italic-VariableFont_opsz,wght.ttf"

fc-cache -f "$HOME/.local/share/fonts"
echo "   ✔ Inter font installed"

# ── 2. Klassy configuration ───────────────────────────────────────────────────
KLASSY_BACKUP_DIR="$HOME/.local/state/the-ultimate-plasma/backups/klassy"
mkdir -p "$KLASSY_BACKUP_DIR"

backup_klassy_config() {
    local target="$HOME/.config/klassy/klassyrc"
    local backup="$KLASSY_BACKUP_DIR/klassyrc"
    local absent="$KLASSY_BACKUP_DIR/klassyrc.absent"

    if [[ ! -e "$backup" && ! -e "$absent" ]]; then
        if [[ -f "$target" ]]; then
            cp -a "$target" "$backup"
            echo "   ✔ Backed up existing Klassy configuration"
        else
            touch "$absent"
            echo "   • No existing Klassy configuration to back up"
        fi
    fi
}
echo "→ [2/7] Applying Klassy configuration (16px and buttons)..."

mkdir -p "$HOME/.config/klassy"

backup_klassy_config

if [[ -f "$SCRIPT_DIR/klassyrc" ]]; then
    cp "$SCRIPT_DIR/klassyrc" "$HOME/.config/klassy/klassyrc"
    echo "   ✔ Klassy configuration applied"
else
    echo "   ⚠ Warning: klassyrc file not found in the theme folder."
fi

# ── 3. Color schemes ──────────────────────────────────────────────────────────
echo "→ [3/7] Installing color schemes..."
install_file \
    "$SCRIPT_DIR/TheUltimatePlasmaDark.colors" \
    "$HOME/.local/share/color-schemes/TheUltimatePlasmaDark.colors"

install_file \
    "$SCRIPT_DIR/TheUltimatePlasmaLight.colors" \
    "$HOME/.local/share/color-schemes/TheUltimatePlasmaLight.colors"
echo "   ✔ Color schemes installed"

# ── 4. Plasma Desktop Theme ───────────────────────────────────────────────────
echo "→ [4/7] Installing Plasma Desktop Theme..."
install_tree \
    "$SCRIPT_DIR/The-Ultimate-Plasma" \
    "$HOME/.local/share/plasma/desktoptheme/The-Ultimate-Plasma"
echo "   ✔ Plasma Desktop Theme installed"

echo "   ↻ Rebuilding KDE configuration cache..."

if kbuildsycoca6 --noincremental &>/dev/null; then
    echo "   ✔ KDE configuration cache rebuilt"
else
    echo "   ⚠ KDE configuration cache could not be rebuilt immediately."
    echo "     KDE will rebuild it automatically when needed."
fi

# ── 5. Look and Feel ──────────────────────────────────────────────────────────
echo "→ [5/7] Installing Look and Feel (dark and light)..."
install_tree \
    "$SCRIPT_DIR/The Ultimate Plasma Dark" \
    "$HOME/.local/share/plasma/look-and-feel/The Ultimate Plasma Dark"

install_tree \
    "$SCRIPT_DIR/The Ultimate Plasma Light" \
    "$HOME/.local/share/plasma/look-and-feel/The Ultimate Plasma Light"
echo "   ✔ Look and Feel installed"

# ── 6. GTK ────────────────────────────────────────────────────────────────────
echo "→ [6/7] Installing GTK 3 and GTK 4 theming..."

GTK_BACKUP_DIR="$HOME/.local/state/the-ultimate-plasma/backups/gtk"
mkdir -p "$GTK_BACKUP_DIR"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"

backup_gtk_css() {
    local version="$1"
    local target="$HOME/.config/gtk-${version}/gtk.css"
    local backup="$GTK_BACKUP_DIR/gtk-${version}.css"
    local absent="$GTK_BACKUP_DIR/gtk-${version}.absent"

    # Preserve the pre-TUP state only once.
    if [[ ! -e "$backup" && ! -e "$absent" ]]; then
        if [[ -f "$target" ]]; then
            cp -a "$target" "$backup"
            echo "   ✔ Backed up existing GTK ${version} CSS"
        else
            touch "$absent"
            echo "   • No existing GTK ${version} CSS to back up"
        fi
    fi
}

backup_gtk_css "3.0"
backup_gtk_css "4.0"

cp "$SCRIPT_DIR/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
cp "$SCRIPT_DIR/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

echo "   ✔ GTK installed"

if command_exists flatpak; then
    echo "   ↻ Applying Flatpak permissions for themes..."

    if flatpak override --user --filesystem="$HOME/.themes" &&
       flatpak override --user --filesystem="$HOME/.local/share/icons" &&
       flatpak override --user --filesystem=xdg-config/gtk-3.0:ro &&
       flatpak override --user --filesystem=xdg-config/gtk-4.0:ro; then
        echo "   ✔ Flatpak theme permissions applied"
    else
        echo "   ⚠ Could not apply one or more Flatpak theme permissions."
        echo "     The rest of The Ultimate Plasma was still installed."
    fi
fi

# ── 7. Konsole — adaptive color scheme ───────────────────────────────────────
echo "→ [7/7] Installing Konsole color scheme and adaptive script..."

install_file \
    "$SCRIPT_DIR/Adaptive-Plasma.colorscheme" \
    "$HOME/.local/share/konsole/Adaptive-Plasma.colorscheme"

install_file \
    "$SCRIPT_DIR/sync_konsole.sh" \
    "$HOME/.local/bin/sync_konsole.sh"

chmod +x "$HOME/.local/bin/sync_konsole.sh"

mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/sync_konsole.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Sync Konsole Colors
Comment=Syncs Konsole colors with the current Plasma theme
Exec=$HOME/.local/bin/sync_konsole.sh
Terminal=false
X-KDE-AutostartEnabled=true
EOF

if bash "$HOME/.local/bin/sync_konsole.sh" &>/dev/null; then
    echo "   ✔ Konsole configured (autostart registered)"
else
    echo "   ⚠ Konsole color sync could not run immediately."
    echo "     The autostart entry was installed and will try again next login."
fi

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
