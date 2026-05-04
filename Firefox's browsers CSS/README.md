# The Ultimate Plasma (TUP) - Browser Integration

This repository contains the definitive visual integration for Mozilla-based browsers (Firefox, LibreWolf, and Waterfox) within the **The Ultimate Plasma (TUP)** ecosystem.

By leveraging advanced CSS injection (`userChrome.css`), this patch forces your browser to adhere to KDE Plasma design standards, achieving:

*   **Dynamic Color Scheme:** The browser contextually absorbs your active Plasma accent and background colors.
*   **Hardware-Level Window Rounding:** Perfect corner rounding implemented via GPU-accelerated `clip-path`.
*   **Floating Tabs:** A modern, "elevated" tab design with subtle shadows and semantic separators.
*   **Themed Menus:** Clean dropdown panels that respect system transparency and tinting, eliminating intrusive white backgrounds.

---

## 📁 Repository Structure

The repository is organized into two main directories based on the specific browser engine:

*   `Firefox/`: Compatible with **Mozilla Firefox** and **LibreWolf**.
*   **Waterfox/**: Optimized specifically for **Waterfox** internal variables and layout.

---

## ⚙️ Prerequisites

Before installing the files, you must instruct your browser to allow the loading of custom stylesheets.

1. Open your browser and type `about:config` in the address bar.
2. Accept the "Proceed with Caution" warning.
3. Search for the following preference:
   `toolkit.legacyUserProfileCustomizations.stylesheets`
4. Double-click it to set its value to **`true`**.

---

## 🚀 Installation Instructions

### Step 1: Locate your Profile Folder
1. In your browser, type `about:support` in the address bar.
2. Look for the **"Profile Directory"** (or "Profile Folder") row and click the **"Open Directory"** (or "Open Folder") button.
3. Once inside that folder, create a new directory named **`chrome`** (all lowercase) if it doesn't already exist.

### Step 2: Copy the Files
Enter the `chrome` folder you just created and copy the contents of the directory corresponding to your browser (`Firefox/` or `Waterfox/`).

Your `chrome` folder should look like this:
```text
[Your-Profile-Directory]/chrome/
├── kde-colors.css
└── userChrome.css
```

### Step 3: Generate Dynamic Colors (Crucial)
To ensure the browser detects your current Plasma theme colors, you must execute the included script. Open a terminal inside your chrome folder and run:

```
chmod +x generar-colores.sh
./generar-colores.sh
```

Note: This script extracts your system's color scheme and creates/links the kde-colors.css file required for the theme to function.

### Step 4: Apply Changes
Simply restart your browser for the changes to take effect. Welcome to the The Ultimate Plasma experience!

🛠️ Troubleshooting & Notes
Title Bar: This theme is optimized to work without the native Title Bar enabled. Ensure the Title Bar is disabled in your browser's customization settings (Right-click the toolbar -> Customize Toolbar -> Uncheck "Title Bar").

OLED Optimization: The shadows and rounding are specifically tuned for high-density displays (HiDPI/2K/4K).

Updates: If a major browser update breaks a specific UI element, simply perform a git pull from this repository and replace your userChrome.css with the updated version.
