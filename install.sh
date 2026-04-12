#!/bin/bash

# The Ultimate Plasma — Instalador
# Compatible con Aurora 43 / Fedora Kinoite — Plasma 6.6
# Instala tema completo: Configuración Klassy, GTK, colores, tipografía, plasma theme, look-and-feel

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

# ── 2. Configuración de Klassy ───────────────────────────────────────────────
echo "→ [2/8] Aplicando configuración de Klassy (16px y botones)..."
# Validamos y creamos la ruta correcta para Klassy
mkdir -p ~/.config/klassy

if [ -f "$SCRIPT_DIR/klassyrc" ]; then
    cp "$SCRIPT_DIR/klassyrc" ~/.config/klassy/klassyrc
    echo "   ✔ Configuración de Klassy aplicada en ~/.config/klassy/klassyrc"
else
    echo "   ⚠️ Advertencia: No se encontró el archivo klassyrc en la carpeta."
fi

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

echo "   ↻ Actualizando la caché de configuración de KDE..."
kbuildsycoca6 --noincremental &> /dev/null

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

echo "   ↻ Aplicando permisos de Flatpak para temas..."
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
bash ~/.local/bin/sync_konsole.sh &> /dev/null
echo "   ✔ Konsole configurado (autostart registrado)"

# ── Listo ─────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         ✔ Instalación completa           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Cierra sesión y vuelve a entrar para aplicar todos los cambios."
echo ""
echo "Recuerda que debes tener KLASSY instalado y compilado."
echo "(Lee la guía klassy-aurora-kinoite.md de este repositorio si usas Aurora/Kinoite)"
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
