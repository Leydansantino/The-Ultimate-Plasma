# The Ultimate Plasma
 
A complete theme for KDE Plasma that unifies the look of Qt, GTK3, GTK4, and Libadwaita applications under a single visual language. Uses Klassy for window decorations and application style, ensuring consistent button icons across all apps — including GNOME and Chromium-based browsers.
 
**Compatible with Aurora 43 / Fedora Kinoite — Plasma 6.6**
 
---
 
## What's included
 
- **Klassy** — window decorations and Qt application style (consistent button icons everywhere)
- **GTK 3 & GTK 4 / Libadwaita** — GNOME apps and Chromium follow the system color scheme
- **Plasma Desktop Theme** — panel, widgets, and system tray styling
- **Look and Feel** — dark and light global themes ready to switch between
- **Color schemes** — `TheUltimatePlasmaDark` and `TheUltimatePlasmaLight`
- **Inter font** — variable font used as the system-wide typeface
- **Adaptive Konsole** — terminal automatically picks background and foreground colors from the active theme on login
 
---
 
## Installation
 
> [!IMPORTANT]
> **Klassy must be installed before running the main installer.** The theme depends on Klassy for window decorations and application style. Skip this step and nothing will look right.
 
### Step 1 — Install Klassy
 
If you are on **Aurora 43 / Plasma 6.6**, use the prebuilt binaries:
 
```bash
git clone https://github.com/Leydansantino/The-Ultimate-Plasma
cd The-Ultimate-Plasma/klassy
chmod +x install-prebuilt.sh
./install-prebuilt.sh
```
 
On a **different Plasma version**, compile from source instead (requires [Distrobox](https://distrobox.it)):
 
```bash
chmod +x install-from-source.sh
./install-from-source.sh
```
 
See [klassy/README.md](klassy/README.md) for full details on both options.
 
### Step 2 — Install the theme
 
```bash
cd The-Ultimate-Plasma
chmod +x install.sh
./install.sh
```
 
Log out and back in to apply all changes.
 
---
 
## Applying the theme
 
After logging back in:
 
1. **System Settings → Global Theme** → choose `The Ultimate Plasma Dark` or `The Ultimate Plasma Light`
   > Always apply from this screen first, not from Quick Settings
2. **System Settings → Window Decorations** → select `Klassy`
3. **System Settings → Application Style** → select `Klassy`
 
To switch between dark and light, just change the Global Theme from System Settings at any time.
 
---
 
## Uninstall
 
```bash
chmod +x uninstall.sh
./uninstall.sh
```
 
The Inter font will not be removed. The desktop layout config will be backed up, not deleted.
 
---
 
## Adaptive Konsole
 
`sync_konsole.sh` reads the active Plasma theme colors and injects them into the `Adaptive-Plasma` Konsole profile. It runs automatically on login via autostart.
 
If you switch between dark and light during a session, run it manually:
 
```bash
~/.local/bin/sync_konsole.sh
```
 
---
 
## Installing Klassy standalone
 
If you only want Klassy without the full theme, see the [klassy/README.md](klassy/README.md).
 
---
 
## Repository structure
 
```
The-Ultimate-Plasma/
├── install.sh
├── uninstall.sh
├── README.md
├── Inter-VariableFont_opsz,wght.ttf
├── Inter-Italic-VariableFont_opsz,wght.ttf
├── TheUltimatePlasmaDark.colors
├── TheUltimatePlasmaLight.colors
├── Adaptive-Plasma.colorscheme
├── klassyrc
├── plasma-org.kde.plasma.desktop-appletsrc
├── sync_konsole.sh
├── klassy/                          ← Klassy prebuilt binaries
├── The-Ultimate-Plasma/             ← Plasma Desktop Theme
├── The Ultimate Plasma Dark/        ← Dark Look and Feel
├── The Ultimate Plasma Light/       ← Light Look and Feel
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
