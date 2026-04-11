#!/bin/bash

# 1. Leer los colores dinámicos de tu tema actual en Plasma 6
# Tomamos el fondo de la Ventana y el texto de la Ventana
BG_COLOR=$(kreadconfig6 --file kdeglobals --group "Colors:Window" --key "BackgroundNormal")
FG_COLOR=$(kreadconfig6 --file kdeglobals --group "Colors:Window" --key "ForegroundNormal")

# (Opcional) Si prefieres que lea el color blanco puro de la vista (como Dolphin),
# descomenta estas dos líneas y comenta las de arriba:
# BG_COLOR=$(kreadconfig6 --file kdeglobals --group "Colors:View" --key "BackgroundNormal")
# FG_COLOR=$(kreadconfig6 --file kdeglobals --group "Colors:View" --key "ForegroundNormal")

# Validar que no estén vacíos (por seguridad)
if [ -z "$BG_COLOR" ]; then BG_COLOR="250,248,252"; fi
if [ -z "$FG_COLOR" ]; then FG_COLOR="60,55,75"; fi

# 2. Definir la ruta del esquema de Konsole
KONSOLE_DIR="$HOME/.local/share/konsole"
mkdir -p "$KONSOLE_DIR"
SCHEME_FILE="$KONSOLE_DIR/Adaptive-Plasma.colorscheme"

# 3. Inyectar los colores en el archivo de Konsole
cat <<EOF > "$SCHEME_FILE"
[General]
Anchor=0.5,0.5
Blur=true
ColorRandomization=false
Description=Adaptive Plasma
FillStyle=Tile
Opacity=0.85
Wallpaper=
WallpaperOpacity=1

[Background]
Color=$BG_COLOR
[BackgroundFaint]
Color=$BG_COLOR
[BackgroundIntense]
Color=$BG_COLOR

[Foreground]
Color=$FG_COLOR
[ForegroundFaint]
Color=$FG_COLOR
[ForegroundIntense]
Color=$FG_COLOR

[Color0]
Color=45,45,50
[Color0Intense]
Color=30,30,35
[Color1]
Color=218,68,83
[Color1Intense]
Color=198,48,63
[Color2]
Color=39,174,96
[Color2Intense]
Color=19,154,76
[Color3]
Color=246,116,0
[Color3Intense]
Color=226,96,0
[Color4]
Color=57,153,230
[Color4Intense]
Color=37,133,210
[Color5]
Color=155,89,182
[Color5Intense]
Color=135,69,162
[Color6]
Color=29,153,243
[Color6Intense]
Color=9,133,223
[Color7]
Color=200,200,205
[Color7Intense]
Color=180,180,185
EOF

echo "¡Esquema de Konsole actualizado exitosamente con los colores del sistema: BG($BG_COLOR) FG($FG_COLOR)!"
