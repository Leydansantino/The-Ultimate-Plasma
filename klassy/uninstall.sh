#!/bin/bash

# Klassy — Desinstalador
# Elimina los archivos instalados por install-prebuilt.sh o install-from-source.sh

set -e

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         Klassy Uninstaller               ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "⚠️  Esto eliminará Klassy de tu sistema."
echo ""
read -p "¿Continuar? [s/N] " confirm
[[ "$confirm" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }
echo ""

# ── Librería compartida ───────────────────────────────────────────────────────
echo "→ Eliminando librería compartida..."
rm -f ~/.local/lib64/libklassycommon6.so
rm -f ~/.local/lib64/libklassycommon6.so.6
echo "   ✔ Hecho"

# ── Plugins ───────────────────────────────────────────────────────────────────
echo "→ Eliminando plugins..."
rm -f ~/.local/lib64/plugins/styles/klassy6.so
rm -f ~/.local/lib64/plugins/kstyle_config/klassystyleconfig.so
rm -f ~/.local/lib64/plugins/org.kde.kdecoration3/org.kde.klassy.so
rm -f ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
rm -rf ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration

# Symlinks qt6
rm -f ~/.local/lib64/qt6/plugins/styles/klassy6.so
rm -f ~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so
rm -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so
rm -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
echo "   ✔ Hecho"

# ── Archivos share ────────────────────────────────────────────────────────────
echo "→ Eliminando archivos de datos..."
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
echo "   ✔ Hecho"

# ── Configuración ─────────────────────────────────────────────────────────────
echo "→ Eliminando configuración..."
rm -f ~/.config/klassyrc
echo "   ✔ Hecho"

# ── Listo ─────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        ✔ Desinstalación completa         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Cierra sesión y vuelve a entrar para que Plasma"
echo "cargue la decoración y estilo por defecto del sistema."
echo ""
