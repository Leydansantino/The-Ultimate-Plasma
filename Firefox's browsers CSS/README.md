# The Ultimate Plasma (TUP) - Browser Integration

Este repositorio contiene la integración visual definitiva para navegadores basados en Mozilla (Firefox, LibreWolf y Waterfox) con el ecosistema de **The Ultimate Plasma (TUP)**.

Mediante la inyección de CSS avanzado (`userChrome.css`), este parche obliga a tu navegador a respetar los estándares de diseño de KDE Plasma, logrando:
*   **Colorimetría Dinámica:** El navegador absorbe los colores de tu tema de Plasma.
*   **Redondeo de Ventana:** Esquinas perfectas recortadas por hardware (`clip-path`).
*   **Pestañas Flotantes:** Diseño de pestañas elevadas con sombras sutiles y separadores semánticos.
*   **Menús Nativos:** Menús desplegables sin fondos blancos intrusivos, respetando el desenfoque y color del sistema.

---

## 📁 Estructura del Repositorio

El repositorio está dividido en dos directorios principales según el motor de tu navegador:

*   `Firefox/`: Compatible con **Mozilla Firefox** y **LibreWolf**.
*   `Waterfox/`: Optimizado para las variables internas de **Waterfox**.

---

## ⚙️ Requisitos Previos

Antes de instalar los archivos, debes indicarle a tu navegador que permita la carga de hojas de estilo personalizadas.

1. Abre tu navegador y escribe `about:config` en la barra de direcciones.
2. Acepta la advertencia de riesgo.
3. Busca la siguiente preferencia:
   `toolkit.legacyUserProfileCustomizations.stylesheets`
4. Haz doble clic sobre ella para cambiar su valor a **`true`**.

---

## 🚀 Instrucciones de Instalación

### Paso 1: Encontrar tu carpeta de Perfil
1. En tu navegador, ve a la barra de direcciones y escribe `about:support`.
2. Busca la fila que dice **"Directorio de perfil"** (Profile Directory) y haz clic en el botón **"Abrir directorio"** (Open Directory).
3. Una vez en esa carpeta, crea una nueva carpeta llamada **`chrome`** (todo en minúsculas) si aún no existe.

### Paso 2: Copiar los Archivos
Entra a la carpeta `chrome` que acabas de crear y copia el contenido del directorio correspondiente a tu navegador (`Firefox/` o `Waterfox/`).

Tu carpeta `chrome` debería verse así:
```text
[Tu-Directorio-De-Perfil]/chrome/
├── generar-colores.sh
├── kde-colors.css
└── userChrome.css
