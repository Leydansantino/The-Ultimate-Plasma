# Klassy for immutable KDE Plasma systems

Klassy integration for [The Ultimate Plasma](https://github.com/Leydansantino/The-Ultimate-Plasma).

This directory provides HOME-only installation methods for
[Klassy](https://github.com/paulmcauley/klassy), with a focus on immutable
Fedora/Kinoite-derived systems such as Aurora.

Nothing installed by these scripts requires writing Klassy files into `/usr`.

---

## Recommended installation — Build from source

The recommended method is `install-from-source.sh`.

It builds Klassy inside a Fedora Distrobox container and installs the result
under:

```text
~/.local
```

The current builder targets the Klassy `plasma6.6` branch and uses Qt6/KF6
dependencies only.

### Requirements

- KDE Plasma 6.6 or newer
- Distrobox
- Podman or another Distrobox-compatible container backend
- Internet access during the build

### Install

```bash
git clone https://github.com/Leydansantino/The-Ultimate-Plasma
cd The-Ultimate-Plasma/klassy

chmod +x install-from-source.sh
./install-from-source.sh
```

The installer:

- creates a Fedora build container
- installs the required Qt6/KF6 development dependencies inside the container
- builds Klassy from source
- installs Klassy under `~/.local`
- creates the Qt plugin compatibility symlinks required by Plasma
- configures the HOME-local plugin and library paths through `environment.d`
- records the Klassy revision used for the build

The host `/usr` is not modified.

---

## Prebuilt installation — Experimental

`install-prebuilt.sh` installs the Klassy binaries bundled with this repository.

```bash
chmod +x install-prebuilt.sh
./install-prebuilt.sh
```

This method is provided as a best-effort option.

Klassy plugins are linked against Qt, KDE Frameworks and KDecoration libraries,
so prebuilt binaries may become incompatible after system updates even when the
Plasma major version is still supported.

For this reason:

> **Use `install-from-source.sh` unless you specifically want to test the
> bundled prebuilt binaries.**

The prebuilt installer performs basic compatibility checks and verifies the
installed plugins, but it cannot guarantee ABI compatibility with every future
Qt/KF6/Plasma release.

---

## Installation paths

Klassy is installed entirely inside the user's HOME directory.

Important paths include:

```text
~/.local/lib64/
~/.local/lib64/plugins/
~/.local/lib64/qt6/plugins/
~/.local/share/
~/.config/environment.d/klassy.conf
~/.local/state/the-ultimate-plasma/klassy-build.txt
```

The following Qt compatibility symlinks are intentionally created so Plasma can
discover Klassy correctly:

```text
~/.local/lib64/qt6/plugins/styles/klassy6.so
~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so
~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so
~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
```

These symlinks are part of the supported installation layout and should not be
removed manually while Klassy is installed.

---

## After installation

Log out and log back in so Plasma receives the updated environment.

Then open **System Settings** and select Klassy under:

1. **Colors & Themes → Application Style**
2. **Colors & Themes → Window Decorations**

A full logout/login is preferred over manually restarting KWin.

---

## Uninstall

Run:

```bash
cd The-Ultimate-Plasma/klassy
chmod +x uninstall.sh
./uninstall.sh
```

The uninstaller removes the Klassy files managed by The Ultimate Plasma from
the user's HOME directory.

It also cleans both the current `environment.d` configuration and the legacy
TUP Plasma environment hook.

By default, personal Klassy preferences are preserved.

The uninstaller can optionally remove:

- the cached Klassy source tree
- the user's Klassy configuration

The host `/usr` is not modified.

---

## Source build cache and state

The source installer keeps its Klassy source checkout under:

```text
~/.cache/the-ultimate-plasma/klassy
```

Build information is recorded under:

```text
~/.local/state/the-ultimate-plasma/klassy-build.txt
```

This makes it possible to identify which Klassy revision and build environment
were used for the installation.

---

## Repository structure

```text
klassy/
├── README.md
├── install-from-source.sh
├── install-prebuilt.sh
├── uninstall.sh
├── lib64/
├── plugins/
│   ├── styles/
│   ├── kstyle_config/
│   ├── org.kde.kdecoration3/
│   └── org.kde.kdecoration3.kcm/
└── share/
```

`lib64/`, `plugins/` and `share/` contain the payload used by the experimental
prebuilt installer.

---

## Troubleshooting

### Klassy does not appear in System Settings

First log out and log back in.

Then verify the four compatibility plugin paths:

```bash
readlink -f ~/.local/lib64/qt6/plugins/styles/klassy6.so
readlink -f ~/.local/lib64/qt6/plugins/kstyle_config/klassystyleconfig.so
readlink -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so
readlink -f ~/.local/lib64/qt6/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so
```

All four should resolve to existing files.

You can also refresh KDE's service cache:

```bash
kbuildsycoca6 --noincremental
```

### Prebuilt Klassy stops working after an update

Remove it with:

```bash
./uninstall.sh
```

Then install the source-built version:

```bash
./install-from-source.sh
```

This rebuilds Klassy against a compatible Qt/KF6 environment instead of relying
on the bundled binaries.

---

## Credits

Klassy is developed by
[Paul McAuley](https://github.com/paulmcauley/klassy).

The Ultimate Plasma provides the HOME-local installation and integration
workflow used in this repository.
