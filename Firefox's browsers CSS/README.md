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
├── generar-colores.sh
├── kde-colors.css
└── userChrome.css
