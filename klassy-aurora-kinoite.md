# Instalar Klassy en Aurora / Fedora Kinoite con Distrobox

Tutorial para compilar e instalar [Klassy](https://github.com/paulmcauley/klassy) en sistemas inmutables basados en Fedora Kinoite (Aurora, Bazzite KDE, etc.) usando Distrobox como entorno de compilación.

> **Requisito:** Plasma 6.3 o superior. Verifica con `plasmashell --version` antes de continuar.

---

## 1 — Crear el contenedor y entrar

```bash
distrobox create --name klassy-builder --image registry.fedoraproject.org/fedora:41
distrobox enter klassy-builder
```

---

## 2 — Instalar dependencias (dentro del contenedor)

```bash
sudo dnf install git cmake extra-cmake-modules gettext
```

```bash
sudo dnf install \
  "cmake(KF5Config)" "cmake(KF5CoreAddons)" "cmake(KF5FrameworkIntegration)" \
  "cmake(KF5GuiAddons)" "cmake(KF5Kirigami2)" "cmake(KF5WindowSystem)" \
  "cmake(KF5I18n)" "cmake(Qt5DBus)" "cmake(Qt5Quick)" "cmake(Qt5Widgets)" \
  "cmake(Qt5X11Extras)" "cmake(KDecoration3)" "cmake(KF6ColorScheme)" \
  "cmake(KF6Config)" "cmake(KF6CoreAddons)" "cmake(KF6FrameworkIntegration)" \
  "cmake(KF6GuiAddons)" "cmake(KF6I18n)" "cmake(KF6KCMUtils)" \
  "cmake(KF6KirigamiPlatform)" "cmake(KF6WindowSystem)" "cmake(Qt6Core)" \
  "cmake(Qt6DBus)" "cmake(Qt6Quick)" "cmake(Qt6Svg)" "cmake(Qt6Widgets)" \
  "cmake(Qt6Xml)"
```

---

## 3 — Clonar y compilar (dentro del contenedor)

```bash
cd ~
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.3
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/.local \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF

make -j$(nproc)
make install
exit
```

---

## 4 — Corregir rutas de plugins (en el host)

CMake instala los plugins en `~/.local/lib64/plugins/` pero Plasma los busca en `~/.local/lib64/qt6/plugins/`. Se crean symlinks para corregirlo:

```bash
mkdir -p ~/.local/lib64/qt6/plugins/kstyle_config
mkdir -p ~/.local/lib64/qt6/plugins/styles
mkdir -p ~/.local/lib64/qt6/plugins/org.kde.kdecoration3
mkdir -p ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm

ln -sf ~/.local/lib64/plugins/kstyle_config/klassystyleconfig.so \
        ~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so

ln -sf ~/.local/lib64/plugins/styles/klassy6.so \
        ~/.local/lib64/qt6/plugins/styles/klassy6.so

ln -sf ~/.local/lib64/plugins/org.kde.kdecoration3/org.kde.klassy.so \
        ~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so

ln -sf ~/.local/lib64/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so \
        ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
```

---

## 5 — Reiniciar la sesión

Cierra sesión y vuelve a entrar, o ejecuta:

```bash
kwin_wayland --replace &
```

---

## 6 — Aplicar el tema

1. **System Settings → Global Theme** → selecciona **Kite**
   > Aplica siempre desde esta pantalla primero, no desde Quick Settings, para que el layout completo se configure correctamente.
2. **System Settings → Window Decorations** → selecciona **Klassy**
3. **System Settings → Application Style** → selecciona **Klassy**

---

## Actualizar Klassy en el futuro

```bash
distrobox enter klassy-builder
cd ~/klassy
git pull
cd build && make -j$(nproc) && make install
exit
kwin_wayland --replace &
```

---

## Por qué este enfoque

Los sistemas inmutables como Aurora y Fedora Kinoite no permiten instalar paquetes de desarrollo en el sistema base. Distrobox resuelve esto creando un contenedor Fedora con acceso completo a `dnf`, mientras que los archivos compilados se instalan en `$HOME/.local`, que es compartido entre el contenedor y el host y persiste entre reinicios.
