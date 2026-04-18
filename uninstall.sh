#!/bin/bash

# The Ultimate Plasma — Desinstalador
# Elimina los componentes instalados por install.sh
# Conserva: fuente Inter
# Hace backup de: plasma-org.kde.plasma.desktop-appletsrc

set -e

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║      The Ultimate Plasma Uninstaller     ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "⚠️  Esto eliminará el tema, Klassy y la configuración GTK."
echo "   La fuente Inter NO será eliminada."
echo "   El layout del escritorio será respaldado, no eliminado."
echo ""
read -p "¿Continuar? [s/N] " confirm
[[ "$confirm" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }
echo ""

#── Klassy — plugins ──────────────────────────────────────────────────────────
echo "→ Eliminando Klassy..."

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

echo "   ✔ Klassy eliminado"

# ── Esquemas de color ─────────────────────────────────────────────────────────
echo "→ Eliminando esquemas de color..."
rm -f ~/.local/share/color-schemes/TheUltimatePlasmaDark.colors
rm -f ~/.local/share/color-schemes/TheUltimatePlasmaLight.colors
echo "   ✔ Esquemas de color eliminados"

# ── Plasma Desktop Theme ──────────────────────────────────────────────────────
echo "→ Eliminando Plasma Desktop Theme..."
rm -rf ~/.local/share/plasma/desktoptheme/The-Ultimate-Plasma
echo "   ✔ Plasma Desktop Theme eliminado"

# ── Look and Feel ─────────────────────────────────────────────────────────────
echo "→ Eliminando Look and Feel..."
rm -rf ~/.local/share/plasma/look-and-feel/The\ Ultimate\ Plasma\ Dark
rm -rf ~/.local/share/plasma/look-and-feel/The\ Ultimate\ Plasma\ Light
echo "   ✔ Look and Feel eliminado"

# ── GTK ───────────────────────────────────────────────────────────────────────
echo "→ Eliminando configuración GTK..."
rm -f ~/.config/gtk-3.0/gtk.css
rm -f ~/.config/gtk-4.0/gtk.css
echo "   ✔ GTK eliminado"

# ── Konsole ───────────────────────────────────────────────────────────────────
echo "→ Eliminando configuración de Konsole..."
rm -f ~/.local/share/konsole/Adaptive-Plasma.colorscheme
rm -f ~/.local/bin/sync_konsole.sh
rm -f ~/.config/autostart/sync_konsole.desktop
echo "   ✔ Konsole eliminado"

# ── Layout del escritorio — backup, no borrar ─────────────────────────────────
echo "→ Respaldando layout del escritorio..."
BACKUP="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc.bak-ultimate-plasma"
if [[ -f ~/.config/plasma-org.kde.plasma.desktop-appletsrc ]]; then
  cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc "$BACKUP"
  echo "   ✔ Backup guardado en: $BACKUP"
  echo "   (el layout actual no fue modificado)"
else
  echo "   (no se encontró appletsrc, nada que respaldar)"
fi

# ── Listo ─────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        ✔ Desinstalación completa         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Cierra sesión y vuelve a entrar para que Plasma"
echo "cargue el tema por defecto del sistema."
echo ""
echo "La fuente Inter permanece instalada. Si quieres eliminarla:"
echo "  rm ~/.local/share/fonts/Inter-*.ttf && fc-cache -f ~/.local/share/fonts"
echo ""
