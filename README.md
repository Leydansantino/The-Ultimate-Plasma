# The Ultimate Plasma

Tema completo para KDE Plasma que unifica la apariencia de aplicaciones Qt, GTK3, GTK4 y Libadwaita bajo un mismo lenguaje visual, usando Klassy para las decoraciones de ventana y el estilo de aplicaciones.

**Compatible con Aurora 43 / Fedora Kinoite — Plasma 6.6**

---

## Qué incluye

- **Klassy** — decoraciones de ventana y estilo de aplicaciones Qt (botones homogéneos en todas las apps)
- **GTK 3 y GTK 4 / Libadwaita** — apps de GNOME y Chromium siguen el esquema de color del sistema
- **Plasma Desktop Theme** — tema de panel, widgets y bandeja del sistema
- **Look and Feel** — temas globales oscuro y claro listos para alternar
- **Esquemas de color** — `TheUltimatePlasmaDark` y `TheUltimatePlasmaLight`
- **Fuente Inter** — tipografía variable para todo el sistema
- **Konsole adaptativo** — el terminal toma el color de fondo y texto del tema activo automáticamente al iniciar sesión

---

## Instalación

```bash
git clone https://github.com/TU_USUARIO/TheUltimatePlasma
cd TheUltimatePlasma
chmod +x install.sh
./install.sh
```

Cierra sesión y vuelve a entrar para aplicar todos los cambios.

---

## Aplicar el tema

Después de iniciar sesión:

1. **System Settings → Global Theme** → elige `The Ultimate Plasma Dark` o `The Ultimate Plasma Light`
   > Aplica siempre desde esta pantalla, no desde Quick Settings
2. **System Settings → Window Decorations** → selecciona `Klassy`
3. **System Settings → Application Style** → selecciona `Klassy`

Para alternar entre oscuro y claro en el futuro, basta con cambiar el Global Theme desde System Settings.

---

## Konsole adaptativo

El script `sync_konsole.sh` lee los colores del tema activo de Plasma y los inyecta en el perfil de Konsole `Adaptive-Plasma`. Se ejecuta automáticamente al iniciar sesión.

Si cambias de tema oscuro a claro (o viceversa) durante la sesión, ejecuta manualmente:

```bash
~/.local/bin/sync_konsole.sh
```

---

## Estructura del repositorio

```
TheUltimatePlasma/
├── install.sh
├── README.md
├── Inter-VariableFont_opsz,wght.ttf
├── Inter-Italic-VariableFont_opsz,wght.ttf
├── TheUltimatePlasmaDark.colors
├── TheUltimatePlasmaLight.colors
├── Adaptive-Plasma.colorscheme
├── klassyrc
├── plasma-org.kde.plasma.desktop-appletsrc
├── sync_konsole.sh
├── klassy/                          ← binarios de Klassy precompilados
│   ├── lib64/
│   ├── plugins/
│   └── share/
├── The-Ultimate-Plasma/             ← Plasma Desktop Theme
├── The Ultimate Plasma Dark/        ← Look and Feel oscuro
├── The Ultimate Plasma Light/       ← Look and Feel claro
├── gtk-3.0/
│   └── gtk.css
└── gtk-4.0/
    ├── gtk.css
    ├── libadwaita.css
    └── libadwaita-tweaks.css
```

---

## Credits

- [Klassy](https://github.com/paulmcauley/klassy) by Paul McAuley
- Fuente [Inter](https://rsms.me/inter/) by Rasmus Andersson
- Utterly Round (https://github.com/HimDek/Utterly-Round-Plasma-Style/tree/master/desktoptheme) by Him Dek
- MacSonoma-Light (https://github.com/vinceliuice/MacSonoma-kde/tree/main/plasma/desktoptheme/MacSonoma-Light) by Vince Liuice
