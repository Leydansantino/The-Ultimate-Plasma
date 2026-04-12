#!/bin/bash

# Klassy installer para Aurora 43 / Plasma 6.6
# Instala binarios precompilados en ~/.local

set -e

PLASMA_MIN="6.6"
PLASMA_VERSION=$(plasmashell --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1)

echo "================================================"
echo " Klassy installer — Aurora 43 / Plasma 6.6"
echo "================================================"
echo ""

# Verificar versión de Plasma
if [[ -z "$PLASMA_VERSION" ]]; then
  echo "⚠️  No se pudo detectar la versión de Plasma."
  echo "   Continúa bajo tu propio riesgo."
else
  echo "✔  Plasma detectado: $PLASMA_VERSION"
  if [[ "$(echo -e "$PLASMA_VERSION\n$PLASMA_MIN" | sort -V | head -1)" != "$PLASMA_MIN" ]]; then
    echo ""
    echo "✗  Este paquete requiere Plasma $PLASMA_MIN o superior."
    echo "   Tu versión ($PLASMA_VERSION) no es compatible."
    echo "   Usa install-from-source.sh para compilar para tu versión."
    exit 1
  fi
fi

echo ""
echo "→ Instalando en ~/.local ..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Librería compartida
mkdir -p ~/.local/lib64
cp "$SCRIPT_DIR/lib64/libklassycommon6.so.6" ~/.local/lib64/
ln -sf ~/.local/lib64/libklassycommon6.so.6 ~/.local/lib64/libklassycommon6.so

# Plugins
mkdir -p ~/.local/lib64/plugins/styles
mkdir -p ~/.local/lib64/plugins/kstyle_config
mkdir -p ~/.local/lib64/plugins/org.kde.kdecoration3
mkdir -p ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets

cp "$SCRIPT_DIR/plugins/styles/klassy6.so" \
   ~/.local/lib64/plugins/styles/

cp "$SCRIPT_DIR/plugins/kstyle_config/klassystyleconfig.so" \
   ~/.local/lib64/plugins/kstyle_config/

cp "$SCRIPT_DIR/plugins/org.kde.kdecoration3/org.kde.klassy.so" \
   ~/.local/lib64/plugins/org.kde.kdecoration3/

cp "$SCRIPT_DIR/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so" \
   ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/

cp "$SCRIPT_DIR/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets/"* \
   ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets/

# Symlinks para que Plasma encuentre los plugins
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

# Archivos share
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/color-schemes
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/.local/share/kf6/kcms
mkdir -p ~/.local/share/kstyle/themes
mkdir -p ~/.local/share/plasma/kcms/systemsettings
mkdir -p ~/.local/share/plasma/layout-templates

cp "$SCRIPT_DIR/share/applications/"* \
   ~/.local/share/applications/

cp "$SCRIPT_DIR/share/color-schemes/"* \
   ~/.local/share/color-schemes/

cp "$SCRIPT_DIR/share/icons/hicolor/scalable/apps/klassy-settings.svgz" \
   ~/.local/share/icons/hicolor/scalable/apps/

cp "$SCRIPT_DIR/share/kf6/kcms/kcm_klassydecoration.desktop" \
   ~/.local/share/kf6/kcms/

cp "$SCRIPT_DIR/share/kstyle/themes/klassy.themerc" \
   ~/.local/share/kstyle/themes/

cp "$SCRIPT_DIR/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop" \
   ~/.local/share/plasma/kcms/systemsettings/

cp -r "$SCRIPT_DIR/share/plasma/layout-templates/"* \
      ~/.local/share/plasma/layout-templates/

echo "Configurando variables de entorno para Klassy..."
mkdir -p ~/.config/plasma-workspace/env/

cat << 'EOF' > ~/.config/plasma-workspace/env/klassy_env.sh
#!/bin/bash
# Decirle a Qt dónde buscar los plugins
export QT_PLUGIN_PATH="$HOME/.local/lib64/qt6/plugins:$HOME/.local/lib/qt6/plugins:$QT_PLUGIN_PATH"

# Decirle al sistema dónde buscar la librería libklassycommon6.so
export LD_LIBRARY_PATH="$HOME/.local/lib64:$HOME/.local/lib:$LD_LIBRARY_PATH"
EOF

chmod +x ~/.config/plasma-workspace/env/klassy_env.sh

echo "Actualizando la base de datos de KDE..."
kbuildsycoca6 --noincremental &> /dev/null

echo ""
echo "✔  Instalación completa."
echo ""
echo "Siguiente paso: cierra sesión y vuelve a entrar, o ejecuta:"
echo ""
echo "   kwin_wayland --replace &"
echo ""
echo "Luego configura en System Settings:"
echo "  Window Decorations  → Klassy"
echo "  Application Style   → Klassy"
echo ""
