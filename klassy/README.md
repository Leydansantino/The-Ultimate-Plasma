# Klassy for Aurora / Fedora Kinoite

Installer for [Klassy](https://github.com/paulmcauley/klassy) on immutable Fedora Kinoite-based systems.

> This folder is part of [The Ultimate Plasma](https://github.com/Leydansantino/The-Ultimate-Plasma). You can also install Klassy standalone by following the instructions below.

---

## Install — Compile from source with Distrobox

Works on any Aurora / Fedora Kinoite version with Plasma 6.3 or higher. Requires [Distrobox](https://distrobox.it) installed.

```bash
git clone https://github.com/Leydansantino/The-Ultimate-Plasma
cd The-Ultimate-Plasma/klassy
chmod +x install-from-source.sh
./install-from-source.sh
```

The script creates a Fedora 41 container, installs all dependencies, compiles Klassy, and automatically fixes the plugin paths.

---

## Uninstall

```bash
cd
cd The-Ultimate-Plasma/klassy
chmod +x uninstall.sh
./uninstall.sh
```
 
---
 
## After installing
 
Log out and back in, or run:
 
```bash
kwin_wayland --replace &
```
 
Then apply in System Settings:
 
1. **Window Decorations** → select **Klassy**
2. **Application Style** → select **Klassy**
 
---
 
## Repository structure
 
```
klassy/
├── README.md
├── install-prebuilt.sh         # Option A: prebuilt binaries
├── install-from-source.sh      # Option B: compile with Distrobox
├── uninstall.sh
├── lib64/                      # Shared library
├── plugins/                    # Prebuilt plugin binaries
│   ├── styles/
│   ├── kstyle_config/
│   ├── org.kde.kdecoration3/
│   └── org.kde.kdecoration3.kcm/
└── share/
```
 
---
 
## Credits
 
- [Klassy](https://github.com/paulmcauley/klassy) by Paul McAuley
