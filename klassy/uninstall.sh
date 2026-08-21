#!/usr/bin/env bash

# The Ultimate Plasma — Klassy HOME uninstaller
#
# Removes Klassy files installed by TUP under the user's HOME.
#
# This script intentionally does NOT modify /usr and does NOT remove the
# user's Klassy preferences unless explicitly requested.

set -Eeuo pipefail


# ==========================================================================
# Paths
# ==========================================================================

LOCAL_PREFIX="${HOME}/.local"

ENVIRONMENT_D_FILE="${HOME}/.config/environment.d/klassy.conf"
PLASMA_ENV_FILE="${HOME}/.config/plasma-workspace/env/klassy_env.sh"

STATE_DIR="${HOME}/.local/state/the-ultimate-plasma"
STATE_FILE="${STATE_DIR}/klassy-build.txt"

SOURCE_CACHE="${HOME}/.cache/the-ultimate-plasma/klassy"


# ==========================================================================
# Helpers
# ==========================================================================

remove_file() {
    local path="$1"

    if [[ -e "${path}" || -L "${path}" ]]; then
        rm -f -- "${path}"
        echo "REMOVE  ${path}"
    fi
}


remove_dir() {
    local path="$1"

    if [[ -d "${path}" ]]; then
        rm -rf -- "${path}"
        echo "REMOVE  ${path}"
    fi
}


remove_empty_dir() {
    local path="$1"

    if [[ -d "${path}" ]]; then
        rmdir --ignore-fail-on-non-empty "${path}" 2>/dev/null || true
    fi
}


# ==========================================================================
# Header
# ==========================================================================

echo
echo "============================================================"
echo " The Ultimate Plasma — Klassy HOME uninstaller"
echo "============================================================"
echo
echo "This will remove Klassy files installed by TUP from:"
echo "  ${HOME}/.local"
echo
echo "Host /usr will not be modified."
echo
echo "Your Klassy preferences will be preserved by default."
echo

read -r -p "Continue? [y/N] " confirm

case "${confirm}" in
    y|Y|yes|YES|Yes)
        ;;
    *)
        echo "Cancelled."
        exit 0
        ;;
esac


# ==========================================================================
# Qt compatibility symlinks
# ==========================================================================
#
# Remove these first. They may point to the real plugin files removed later.
#

echo
echo "Removing Qt compatibility symlinks..."

for qt_root in \
    "${LOCAL_PREFIX}/lib64/qt6/plugins" \
    "${LOCAL_PREFIX}/lib/qt6/plugins"
do
    remove_file "${qt_root}/styles/klassy6.so"
    remove_file "${qt_root}/kstyle_config/klassystyleconfig.so"
    remove_file "${qt_root}/org.kde.kdecoration3/org.kde.klassy.so"
    remove_file "${qt_root}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"
done


# ==========================================================================
# Klassy plugins
# ==========================================================================

echo
echo "Removing Klassy plugins..."

for plugin_root in \
    "${LOCAL_PREFIX}/lib64/plugins" \
    "${LOCAL_PREFIX}/lib/plugins"
do
    remove_file "${plugin_root}/styles/klassy6.so"

    remove_file \
        "${plugin_root}/kstyle_config/klassystyleconfig.so"

    remove_file \
        "${plugin_root}/org.kde.kdecoration3/org.kde.klassy.so"

    remove_file \
        "${plugin_root}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"

    remove_dir \
        "${plugin_root}/org.kde.kdecoration3.kcm/klassydecoration"
done


# ==========================================================================
# Klassy shared libraries
# ==========================================================================

echo
echo "Removing Klassy libraries..."

for lib_root in \
    "${LOCAL_PREFIX}/lib64" \
    "${LOCAL_PREFIX}/lib"
do
    remove_file "${lib_root}/libklassycommon6.so"
    remove_file "${lib_root}/libklassycommon6.so.6"

    # CMake installations may produce a more specific SONAME such as
    # libklassycommon6.so.6.x.y.
    #
    # Only files whose basename belongs to libklassycommon6 are considered.

    if [[ -d "${lib_root}" ]]; then
        find "${lib_root}" \
            -maxdepth 1 \
            \( -type f -o -type l \) \
            -name 'libklassycommon6.so.*' \
            -print0 |
        while IFS= read -r -d '' file; do
            remove_file "${file}"
        done
    fi
done


# ==========================================================================
# Klassy data files
# ==========================================================================

echo
echo "Removing Klassy data files..."

remove_file \
    "${LOCAL_PREFIX}/share/applications/kcm_klassydecoration.desktop"

remove_file \
    "${LOCAL_PREFIX}/share/applications/klassy-settings.desktop"

remove_file \
    "${LOCAL_PREFIX}/share/applications/klassystyleconfig.desktop"

remove_file \
    "${LOCAL_PREFIX}/share/color-schemes/KlassyDark.colors"

remove_file \
    "${LOCAL_PREFIX}/share/color-schemes/KlassyLight.colors"

remove_file \
    "${LOCAL_PREFIX}/share/icons/hicolor/scalable/apps/klassy-settings.svgz"

remove_file \
    "${LOCAL_PREFIX}/share/kf6/kcms/kcm_klassydecoration.desktop"

remove_file \
    "${LOCAL_PREFIX}/share/kstyle/themes/klassy.themerc"

remove_file \
    "${LOCAL_PREFIX}/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop"

remove_dir \
    "${LOCAL_PREFIX}/share/plasma/layout-templates/org.kde.klassy.plasma.desktop.bottomPanel"

remove_dir \
    "${LOCAL_PREFIX}/share/plasma/layout-templates/org.kde.klassy.plasma.desktop.leftPanel"


# ==========================================================================
# Environment files
# ==========================================================================

echo
echo "Removing Klassy environment configuration..."

# install-from-source.sh
remove_file "${ENVIRONMENT_D_FILE}"

# Legacy/prebuilt TUP installer
remove_file "${PLASMA_ENV_FILE}"


# ==========================================================================
# TUP installation state
# ==========================================================================

echo
echo "Removing TUP Klassy installation state..."

remove_file "${STATE_FILE}"

remove_empty_dir "${STATE_DIR}"


# ==========================================================================
# Optional source cache
# ==========================================================================

echo
read -r -p \
    "Remove the cached Klassy source tree in ~/.cache/the-ultimate-plasma? [y/N] " \
    remove_cache

case "${remove_cache}" in
    y|Y|yes|YES|Yes)
        remove_dir "${SOURCE_CACHE}"
        remove_empty_dir "${HOME}/.cache/the-ultimate-plasma"
        ;;
esac


# ==========================================================================
# Optional user configuration
# ==========================================================================

echo
echo "Klassy user preferences were NOT removed."
echo

read -r -p \
    "Also remove Klassy user preferences? [y/N] " \
    remove_config

case "${remove_config}" in
    y|Y|yes|YES|Yes)

        remove_file "${HOME}/.config/klassyrc"

        # Some Klassy versions/configurations may use this directory.
        remove_dir "${HOME}/.config/klassy"

        ;;

    *)
        echo "Keeping Klassy user preferences."
        ;;

esac


# ==========================================================================
# Remove empty directories created only for Klassy where possible
# ==========================================================================

for dir in \
    "${LOCAL_PREFIX}/lib64/qt6/plugins/styles" \
    "${LOCAL_PREFIX}/lib64/qt6/plugins/kstyle_config" \
    "${LOCAL_PREFIX}/lib64/qt6/plugins/org.kde.kdecoration3" \
    "${LOCAL_PREFIX}/lib64/qt6/plugins/org.kde.kdecoration3.kcm" \
    "${LOCAL_PREFIX}/lib/qt6/plugins/styles" \
    "${LOCAL_PREFIX}/lib/qt6/plugins/kstyle_config" \
    "${LOCAL_PREFIX}/lib/qt6/plugins/org.kde.kdecoration3" \
    "${LOCAL_PREFIX}/lib/qt6/plugins/org.kde.kdecoration3.kcm"
do
    remove_empty_dir "${dir}"
done


# ==========================================================================
# Refresh KDE metadata
# ==========================================================================

if command -v kbuildsycoca6 >/dev/null 2>&1; then

    echo
    echo "Refreshing KDE service metadata..."

    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

fi


# ==========================================================================
# Finished
# ==========================================================================

echo
echo "============================================================"
echo " Klassy HOME uninstall completed"
echo "============================================================"
echo
echo "Klassy files managed by TUP were removed from the user HOME."
echo "Host /usr was not modified."
echo
echo "Log out and log back in to clear the old Plasma environment."
echo
