#!/usr/bin/env bash
# =================================================================
# generar-colores.sh (Motor de TUP)
# =================================================================

set -euo pipefail

# 1. Crear el directorio maestro de The Ultimate Plasma
TUP_DIR="$HOME/.config/TUP"
mkdir -p "$TUP_DIR"
OUTPUT="$TUP_DIR/kde-colors.css"

# 2. Buscar el archivo de colores GTK origen
GTK_COLORS_SYSTEM="$HOME/.config/gtk-3.0/colors.css"
GTK_COLORS_FLATPAK="$HOME/.var/app/org.mozilla.firefox/config/gtk-3.0/colors.css"

if [[ -f "$GTK_COLORS_FLATPAK" ]]; then
    SOURCE="$GTK_COLORS_FLATPAK"
elif [[ -f "$GTK_COLORS_SYSTEM" ]]; then
    SOURCE="$GTK_COLORS_SYSTEM"
else
    echo "✗ No se encontró colors.css de GTK. ¿Seguro que el tema está aplicado?" >&2
    exit 1
fi

echo "✓ Leyendo colores desde: $SOURCE"
echo "⏳ Generando maestro en: $OUTPUT..."

# ── Parsear @define-color y construir el CSS ─────────────────────
python3 - "$SOURCE" "$OUTPUT" << 'PYTHON'
import sys, re
from pathlib import Path
from datetime import datetime

source = Path(sys.argv[1])
output = Path(sys.argv[2])

lines = source.read_text(encoding="utf-8").splitlines()
colors = {}
for line in lines:
    m = re.match(r'@define-color\s+(\S+)\s+(.+?)\s*;', line)
    if m:
        colors[m.group(1)] = m.group(2)

breeze = {k: v for k, v in colors.items() if k.endswith("_breeze")}

if not breeze:
    print("✗ No se encontraron variables *_breeze", file=sys.stderr)
    sys.exit(1)

def to_css_var(name):
    base = name.removesuffix("_breeze")
    return "--breeze-" + base.replace("_", "-")

def resolve(val, seen=None):
    if seen is None:
        seen = set()
    if val.startswith("@"):
        ref = val[1:]
        if ref in seen or ref not in colors:
            return val
        seen.add(ref)
        return resolve(colors[ref], seen)
    return val

ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

css_lines = [
    f"/* Generado por generar-colores.sh — {ts} */",
    ":root {",
    "  /* ── Colores Breeze del tema activo ─────────────────────── */",
]

for key, val in sorted(breeze.items()):
    val = resolve(val)
    css_lines.append(f"  {to_css_var(key)}: {val};")

css_lines += [
    "",
    "  /* ── Roles semánticos para userChrome.css ─────────────── */",
    "  --kde-tabs-bg:           var(--breeze-theme-titlebar-background);",
    "  --kde-tabs-fg:           var(--breeze-theme-titlebar-foreground);",
    "  --kde-tab-active-bg:     var(--breeze-theme-selected-bg-color);",
    "  --kde-tab-active-fg:     var(--breeze-theme-selected-fg-color);",
    "  --kde-tab-active-line:   var(--breeze-theme-hovering-selected-bg-color);",
    "  --kde-tab-inactive-bg:   var(--breeze-theme-titlebar-background-backdrop);",
    "  --kde-tab-inactive-fg:   var(--breeze-theme-titlebar-foreground-backdrop);",
    "  --kde-toolbar-bg:        var(--breeze-theme-header-background);",
    "  --kde-toolbar-fg:        var(--breeze-theme-header-foreground);",
    "  --kde-border:            var(--breeze-borders);",
    "}"
]

output.write_text("\n".join(css_lines), encoding="utf-8")
PYTHON

echo "✨ ¡Listo! Archivo maestro actualizado."
echo "💡 El archivo maestro vive en: $OUTPUT"
