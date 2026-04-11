#!/bin/bash

# Klassy — compilar e instalar desde fuente usando Distrobox
# Compatible con Aurora / Fedora Kinoite (cualquier versión de Plasma 6.3+)

set -e

CONTAINER="klassy-builder"
FEDORA_IMAGE="registry.fedoraproject.org/fedora:41"

echo "================================================"
echo " Klassy — compilar desde fuente con Distrobox"
echo "================================================"
echo ""

# Verificar que distrobox está instalado
if ! command -v distrobox &>/dev/null; then
  echo "✗  distrobox no encontrado. Instálalo desde:"
  echo "   https://distrobox.it"
  exit 1
fi

# Verificar versión de Plasma
PLASMA_VERSION=$(plasmashell --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1)
if [[ -n "$PLASMA_VERSION" ]]; then
  echo "✔  Plasma detectado: $PLASMA_VERSION"
else
  echo "⚠️  No se pudo detectar la versión de Plasma. Continuando..."
fi

echo ""
echo "→ Creando contenedor Distrobox (Fedora 41)..."
distrobox create --name "$CONTAINER" --image "$FEDORA_IMAGE" --yes 2>/dev/null || \
  echo "   (el contenedor ya existe, continuando)"

echo ""
echo "→ Instalando dependencias y compilando dentro del contenedor..."
echo "   Esto puede tardar varios minutos la primera vez."
echo ""

distrobox enter "$CONTAINER" -- bash -c '
set -e

echo "→ Instalando dependencias..."
sudo dnf install -y git cmake extra-cmake-modules gettext \
  "cmake(KF5Config)" "cmake(KF5CoreAddons)" "cmake(KF5FrameworkIntegration)" \
  "cmake(KF5GuiAddons)" "cmake(KF5Kirigami2)" "cmake(KF5WindowSystem)" \
  "cmake(KF5I18n)" "cmake(Qt5DBus)" "cmake(Qt5Quick)" "cmake(Qt5Widgets)" \
  "cmake(Qt5X11Extras)" "cmake(KDecoration3)" "cmake(KF6ColorScheme)" \
  "cmake(KF6Config)" "cmake(KF6CoreAddons)" "cmake(KF6FrameworkIntegration)" \
  "cmake(KF6GuiAddons)" "cmake(KF6I18n)" "cmake(KF6KCMUtils)" \
  "cmake(KF6KirigamiPlatform)" "cmake(KF6WindowSystem)" "cmake(Qt6Core)" \
  "cmake(Qt6DBus)" "cmake(Qt6Quick)" "cmake(Qt6Svg)" "cmake(Qt6Widgets)" \
  "cmake(Qt6Xml)"

echo ""
echo "→ Clonando repositorio..."
cd ~
if [ -d "klassy" ]; then
  echo "   Repositorio ya existe, actualizando..."
  cd klassy && git pull
else
  git clone https://github.com/paulmcauley/klassy
  cd klassy
fi

git checkout plasma6.3

echo ""
echo "→ Compilando..."
mkdir -p build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/.local \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF

make -j$(nproc)
make install

echo ""
echo "✔  Compilación e instalación completadas."
'

echo ""
echo "→ Corrigiendo rutas de plugins..."

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

echo ""
echo "✔  Todo listo."
echo ""
echo "Siguiente paso: cierra sesión y vuelve a entrar, o ejecuta:"
echo ""
echo "   kwin_wayland --replace &"
echo ""
echo "Luego aplica el tema en:"
echo "  System Settings → Global Theme        → Kite"
echo "  System Settings → Window Decorations  → Klassy"
echo "  System Settings → Application Style   → Klassy"
echo ""
