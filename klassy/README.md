# Klassy para Aurora / Fedora Kinoite

Instalador de [Klassy](https://github.com/paulmcauley/klassy) para sistemas inmutables basados en Fedora Kinoite.

Incluye dos opciones: binarios precompilados para instalación rápida, y un script que compila desde fuente usando Distrobox para cualquier versión.

---

## Opción A — Binarios precompilados (rápido)

Compilados para:

| Sistema | Plasma | KDE Frameworks | Qt |
|---|---|---|---|
| Aurora 43 | 6.6.3 | 6.24.0 | 6.10.2 |

Si tu sistema coincide, es la forma más rápida:

```bash
git clone https://github.com/TU_USUARIO/klassy-aurora
cd klassy-aurora
chmod +x install-prebuilt.sh
./install-prebuilt.sh
```

> Si tu versión de Plasma no coincide, el script te avisará y deberás usar la Opción B.

---

## Opción B — Compilar desde fuente con Distrobox (cualquier versión)

Funciona en cualquier versión de Aurora / Fedora Kinoite con Plasma 6.3 o superior. Requiere [Distrobox](https://distrobox.it) instalado.

```bash
git clone https://github.com/TU_USUARIO/klassy-aurora
cd klassy-aurora
chmod +x install-from-source.sh
./install-from-source.sh
```

El script crea un contenedor Fedora 41, instala las dependencias, compila Klassy y corrige las rutas de plugins automáticamente.

---

## Después de instalar

Cierra sesión y vuelve a entrar, o ejecuta:

```bash
kwin_wayland --replace &
```

Luego aplica el tema en System Settings:

1. **Global Theme** → selecciona **Kite** (aplica siempre desde esta pantalla primero)
2. **Window Decorations** → selecciona **Klassy**
3. **Application Style** → selecciona **Klassy**

---

## Actualizar

Si usaste la Opción B, para actualizar a una versión nueva de Klassy simplemente vuelve a ejecutar:

```bash
./install-from-source.sh
```

---

## Estructura del repositorio

```
klassy-aurora/
├── README.md
├── install-prebuilt.sh         # Opción A: binarios precompilados
├── install-from-source.sh      # Opción B: compilar con Distrobox
├── plugins/                    # Binarios precompilados
│   ├── styles/
│   │   └── klassy6.so
│   ├── kstyle_config/
│   │   └── klassystyleconfig.so
│   ├── org.kde.kdecoration3/
│   │   └── org.kde.klassy.so
│   └── org.kde.kdecoration3.kcm/
│       ├── kcm_klassydecoration.so
│       └── klassydecoration/presets/
└── share/                      # Temas, iconos, colores, plasma style
```

---

## Por qué este enfoque

Aurora y Fedora Kinoite son sistemas inmutables: no se pueden instalar paquetes de desarrollo en el sistema base. Distrobox resuelve esto creando un contenedor Fedora con acceso completo a `dnf`. Los archivos compilados se instalan en `$HOME/.local`, que es compartido entre el contenedor y el host y persiste entre reinicios.

Un detalle importante: CMake instala los plugins en `~/.local/lib64/plugins/` pero Plasma los busca en `~/.local/lib64/qt6/plugins/`. Ambos scripts corrigen esto creando symlinks automáticamente.

---

## Créditos

- [Klassy](https://github.com/paulmcauley/klassy) por Paul McAuley
