#!/bin/bash

# The Ultimate Plasma — Instalador
# Compatible con Aurora 43 / Fedora Kinoite — Plasma 6.6
# Instala tema completo: Klassy, GTK, colores, tipografía, plasma theme, look-and-feel

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

# ── Verificar versión de Plasma ──────────────────────────────────────────────
if [[ -z "$PLASMA_VERSION" ]]; then
  echo "⚠️  No se pudo detectar la versión de Plasma. Continuando..."
else
  echo "✔  Plasma detectado: $PLASMA_VERSION"
  if [[ "$(echo -e "$PLASMA_VERSION\n$PLASMA_MIN" | sort -V | head -1)" != "$PLASMA_MIN" ]]; then
    echo ""
    echo "✗  Este paquete requiere Plasma $PLASMA_MIN o superior."
    echo "   Tu versión ($PLASMA_VERSION) no es compatible."
    exit 1
  fi
fi

echo ""

# ── 1. Fuente Inter ───────────────────────────────────────────────────────────
echo "→ [1/8] Instalando fuente Inter..."
mkdir -p ~/.local/share/fonts
cp "$SCRIPT_DIR/Inter-VariableFont_opsz,wght.ttf" ~/.local/share/fonts/
cp "$SCRIPT_DIR/Inter-Italic-VariableFont_opsz,wght.ttf" ~/.local/share/fonts/
fc-cache -f ~/.local/share/fonts
echo "   ✔ Fuente Inter instalada"

# ── 2. Klassy — librería compartida ──────────────────────────────────────────
echo "→ [2/8] Instalando Klassy..."
KLASSY_DIR="$SCRIPT_DIR/klassy"
if [ ! -d "$KLASSY_DIR/plugins" ]; then
  echo "✗  Klassy binaries not found at $KLASSY_DIR"
  echo "   Please run klassy/install-prebuilt.sh or klassy/install-from-source.sh first."
  exit 1
fi
mkdir -p ~/.local/lib64
cp "$KLASSY_DIR/lib64/libklassycommon6.so.6" ~/.local/lib64/
ln -sf ~/.local/lib64/libklassycommon6.so.6 ~/.local/lib64/libklassycommon6.so

# Plugins
mkdir -p ~/.local/lib64/plugins/styles
mkdir -p ~/.local/lib64/plugins/kstyle_config
mkdir -p ~/.local/lib64/plugins/org.kde.kdecoration3
mkdir -p ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets

cp "$KLASSY_DIR/plugins/styles/klassy6.so" \
   ~/.local/lib64/plugins/styles/
cp "$KLASSY_DIR/plugins/kstyle_config/klassystyleconfig.so" \
   ~/.local/lib64/plugins/kstyle_config/
cp "$KLASSY_DIR/plugins/org.kde.kdecoration3/org.kde.klassy.so" \
   ~/.local/lib64/plugins/org.kde.kdecoration3/
cp "$KLASSY_DIR/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so" \
   ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/
cp "$KLASSY_DIR/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets/"* \
   ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets/

# Symlinks qt6
mkdir -p ~/.local/lib64/qt6/plugins/styles
mkdir -p ~/.local/lib64/qt6/plugins/kstyle_config
mkdir -p ~/.local/lib64/qt6/plugins/org.kde.kdecoration3
mkdir -p ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm

ln -sf ~/.local/lib64/plugins/styles/klassy6.so \
        ~/.local/lib64/qt6/plugins/styles/klassy6.so
ln -sf ~/.local/lib64/plugins/kstyle_config/klassystyleconfig.so \
        ~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so
ln -sf ~/.local/lib64/plugins/org.kde.kdecoration3/org.kde.klassy.so \
        ~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so
ln -sf ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so \
        ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so

# Klassy share
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/color-schemes
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/.local/share/kf6/kcms
mkdir -p ~/.local/share/kstyle/themes
mkdir -p ~/.local/share/plasma/kcms/systemsettings
mkdir -p ~/.local/share/plasma/layout-templates

cp "$KLASSY_DIR/share/applications/"*          ~/.local/share/applications/
cp "$KLASSY_DIR/share/color-schemes/"*         ~/.local/share/color-schemes/
cp "$KLASSY_DIR/share/icons/hicolor/scalable/apps/klassy-settings.svgz" \
   ~/.local/share/icons/hicolor/scalable/apps/
cp "$KLASSY_DIR/share/kf6/kcms/kcm_klassydecoration.desktop" \
   ~/.local/share/kf6/kcms/
cp "$KLASSY_DIR/share/kstyle/themes/klassy.themerc" \
   ~/.local/share/kstyle/themes/
cp "$KLASSY_DIR/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop" \
   ~/.local/share/plasma/kcms/systemsettings/
cp -r "$KLASSY_DIR/share/plasma/layout-templates/"* \
      ~/.local/share/plasma/layout-templates/

# Configuración de Klassy
mkdir -p ~/.config
cp "$SCRIPT_DIR/klassyrc" ~/.config/klassyrc

echo "   ✔ Klassy instalado"

# ── 3. Esquemas de color ──────────────────────────────────────────────────────
echo "→ [3/8] Instalando esquemas de color..."
mkdir -p ~/.local/share/color-schemes
cp "$SCRIPT_DIR/TheUltimatePlasmaDark.colors"  ~/.local/share/color-schemes/
cp "$SCRIPT_DIR/TheUltimatePlasmaLight.colors" ~/.local/share/color-schemes/
echo "   ✔ Esquemas de color instalados"

# ── 4. Plasma Desktop Theme ───────────────────────────────────────────────────
echo "→ [4/8] Instalando Plasma Desktop Theme..."
mkdir -p ~/.local/share/plasma/desktoptheme
cp -r "$SCRIPT_DIR/The-Ultimate-Plasma" ~/.local/share/plasma/desktoptheme/
echo "   ✔ Plasma Desktop Theme instalado"

# ── 5. Look and Feel ──────────────────────────────────────────────────────────
echo "→ [5/8] Instalando Look and Feel (oscuro y claro)..."
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r "$SCRIPT_DIR/The Ultimate Plasma Dark"  ~/.local/share/plasma/look-and-feel/
cp -r "$SCRIPT_DIR/The Ultimate Plasma Light" ~/.local/share/plasma/look-and-feel/
echo "   ✔ Look and Feel instalado"

# ── 6. GTK ────────────────────────────────────────────────────────────────────
echo "→ [6/8] Instalando temas GTK 3 y GTK 4 / Libadwaita..."
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
cp "$SCRIPT_DIR/gtk-3.0/gtk.css"               ~/.config/gtk-3.0/gtk.css
cp "$SCRIPT_DIR/gtk-4.0/gtk.css"               ~/.config/gtk-4.0/gtk.css
cp "$SCRIPT_DIR/gtk-4.0/libadwaita.css"        ~/.config/gtk-4.0/libadwaita.css
cp "$SCRIPT_DIR/gtk-4.0/libadwaita-tweaks.css" ~/.config/gtk-4.0/libadwaita-tweaks.css
echo "   ✔ GTK instalado"

flatpak override --user --filesystem=$HOME/.themes
flatpak override --user --filesystem=$HOME/.local/share/icons
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

# ── 7. Konsole — esquema adaptativo ──────────────────────────────────────────
echo "→ [7/8] Instalando esquema de Konsole y script adaptativo..."
mkdir -p ~/.local/share/konsole
cp "$SCRIPT_DIR/Adaptive-Plasma.colorscheme" ~/.local/share/konsole/

# Copiar sync_konsole.sh a un lugar permanente
mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/sync_konsole.sh" ~/.local/bin/sync_konsole.sh
chmod +x ~/.local/bin/sync_konsole.sh

# Registrar como autostart
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/sync_konsole.desktop << EOF
[Desktop Entry]
Type=Application
Name=Sync Konsole Colors
Comment=Sincroniza colores de Konsole con el tema actual de Plasma
Exec=$HOME/.local/bin/sync_konsole.sh
Terminal=false
X-KDE-AutostartEnabled=true
EOF

# Ejecutar ahora para aplicar los colores actuales
bash ~/.local/bin/sync_konsole.sh
echo "   ✔ Konsole configurado (autostart registrado)"

# ── 8. Layout del escritorio ──────────────────────────────────────────────────
echo "→ [8/8] Aplicando configuración del escritorio..."
cp "$SCRIPT_DIR/plasma-org.kde.plasma.desktop-appletsrc" \
   ~/.config/plasma-org.kde.plasma.desktop-appletsrc

# Adaptar rutas de wallpaper al usuario actual
SYSTEM_WALLPAPER=$(find /usr/share/wallpapers -name "*.jpg" -o -name "*.png" 2>/dev/null | head -1)
if [ -z "$SYSTEM_WALLPAPER" ]; then
  SYSTEM_WALLPAPER="/usr/share/wallpapers/Next/contents/images/3840x2160.png"
fi

sed -i "s|Image=/usr/share/wallpapers/[^']*|Image=${SYSTEM_WALLPAPER}|g"   ~/.config/plasma-org.kde.plasma.desktop-appletsrc

sed -i "s|SlidePaths=/usr/share/wallpapers/|SlidePaths=${HOME}/.local/share/wallpapers/,/usr/share/wallpapers/|g"   ~/.config/plasma-org.kde.plasma.desktop-appletsrc

echo "   ✔ Layout del escritorio aplicado (wallpaper: ${SYSTEM_WALLPAPER})"

# ── Listo ─────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         ✔ Instalación completa           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Cierra sesión y vuelve a entrar para aplicar todos los cambios."
echo ""
echo "Luego selecciona tu tema en:"
echo "  System Settings → Global Theme"
echo "    → The Ultimate Plasma Dark"
echo "    → The Ultimate Plasma Light"
echo ""
echo "Y activa los componentes en:"
echo "  Window Decorations  → Klassy"
echo "  Application Style   → Klassy"
echo ""
echo "El script sync_konsole.sh se ejecutará automáticamente"
echo "al iniciar sesión para adaptar Konsole al tema activo."
echo "También puedes ejecutarlo manualmente en cualquier momento:"
echo "  ~/.local/bin/sync_konsole.sh"
echo ""
