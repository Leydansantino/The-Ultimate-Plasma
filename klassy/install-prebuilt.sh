#!/usr/bin/env bash

# The Ultimate Plasma — Klassy prebuilt HOME installer
#
# Installs the Klassy binaries bundled with this repository under ~/.local.
#
# IMPORTANT:
# Prebuilt Klassy binaries are sensitive to Qt/KF6/KDecoration ABI changes.
# The source installer is the recommended installation method.
#
# Nothing in this script is installed into host /usr.

set -Eeuo pipefail


# ==========================================================================
# Configuration
# ==========================================================================

PLASMA_MIN_VERSION="6.6"

LOCAL_PREFIX="${HOME}/.local"

ENV_DIR="${HOME}/.config/environment.d"
ENV_FILE="${ENV_DIR}/klassy.conf"

STATE_DIR="${HOME}/.local/state/the-ultimate-plasma"
STATE_FILE="${STATE_DIR}/klassy-build.txt"

SCRIPT_DIR="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
    pwd
)"


# ==========================================================================
# Helpers
# ==========================================================================

die() {
    echo
    echo "ERROR: $*" >&2
    echo
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

require_file() {
    local file="$1"

    [[ -f "${file}" ]] ||
        die "Required bundled Klassy file is missing: ${file}"
}


# ==========================================================================
# Header
# ==========================================================================

echo
echo "============================================================"
echo " The Ultimate Plasma — Klassy prebuilt installer"
echo "============================================================"
echo
echo "This installer uses the PREBUILT Klassy binaries bundled"
echo "inside The Ultimate Plasma."
echo
echo "WARNING:"
echo "  Klassy binaries depend on Qt/KF6/KDecoration ABI versions."
echo "  The source installer is safer across system updates."
echo
echo "Recommended:"
echo "  ./install-from-source.sh"
echo
echo "This prebuilt installer:"
echo "  • installs only under \$HOME/.local"
echo "  • does not modify host /usr"
echo "  • is provided as a best-effort prebuilt option"
echo "  • may be incompatible with newer Qt/KF6/Plasma releases"
echo


# ==========================================================================
# Plasma requirements
# ==========================================================================

command_exists plasmashell ||
    die "plasmashell was not found."

PLASMA_VERSION="$(
    plasmashell --version 2>/dev/null |
        grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' |
        head -n1 ||
        true
)"

[[ -n "${PLASMA_VERSION}" ]] ||
    die "Could not detect the installed Plasma version."

echo "Plasma detected: ${PLASMA_VERSION}"

if ! version_ge "${PLASMA_VERSION}" "${PLASMA_MIN_VERSION}"; then
    die "This Klassy bundle requires Plasma ${PLASMA_MIN_VERSION} or newer."
fi

if [[ "${PLASMA_VERSION}" != 6.6* ]]; then
    echo
    echo "WARNING:"
    echo "  These bundled binaries were prepared for the Plasma 6.6 era."
    echo "  Your system is running Plasma ${PLASMA_VERSION}."
    echo "  They may work, but ABI compatibility is not guaranteed."
    echo "  The source installer is recommended."
fi


# ==========================================================================
# Explicit confirmation
# ==========================================================================

echo
echo "The bundled binaries may stop working after Qt/KF6 upgrades."
echo

read -r -p "Continue with the prebuilt installation? [y/N] " confirm

case "${confirm}" in
    y|Y|yes|YES|Yes)
        ;;
    *)
        echo "Cancelled."
        exit 0
        ;;
esac


# ==========================================================================
# Verify bundled payload before touching ~/.local
# ==========================================================================

echo
echo "Verifying bundled Klassy payload..."

require_file \
    "${SCRIPT_DIR}/lib64/libklassycommon6.so.6"

require_file \
    "${SCRIPT_DIR}/plugins/styles/klassy6.so"

require_file \
    "${SCRIPT_DIR}/plugins/kstyle_config/klassystyleconfig.so"

require_file \
    "${SCRIPT_DIR}/plugins/org.kde.kdecoration3/org.kde.klassy.so"

require_file \
    "${SCRIPT_DIR}/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"

echo "Bundled payload found."


# ==========================================================================
# Install shared library
# ==========================================================================

echo
echo "Installing Klassy shared library..."

mkdir -p "${LOCAL_PREFIX}/lib64"

install -m 0644 \
    "${SCRIPT_DIR}/lib64/libklassycommon6.so.6" \
    "${LOCAL_PREFIX}/lib64/libklassycommon6.so.6"

ln -sfn \
    "${LOCAL_PREFIX}/lib64/libklassycommon6.so.6" \
    "${LOCAL_PREFIX}/lib64/libklassycommon6.so"


# ==========================================================================
# Install plugins
# ==========================================================================

echo
echo "Installing Klassy plugins..."

PLUGIN_ROOT="${LOCAL_PREFIX}/lib64/plugins"

mkdir -p \
    "${PLUGIN_ROOT}/styles" \
    "${PLUGIN_ROOT}/kstyle_config" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3.kcm/klassydecoration/presets"

install -m 0755 \
    "${SCRIPT_DIR}/plugins/styles/klassy6.so" \
    "${PLUGIN_ROOT}/styles/klassy6.so"

install -m 0755 \
    "${SCRIPT_DIR}/plugins/kstyle_config/klassystyleconfig.so" \
    "${PLUGIN_ROOT}/kstyle_config/klassystyleconfig.so"

install -m 0755 \
    "${SCRIPT_DIR}/plugins/org.kde.kdecoration3/org.kde.klassy.so" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3/org.kde.klassy.so"

install -m 0755 \
    "${SCRIPT_DIR}/plugins/org.kde.kdecoration3.kcm/kcm_klassydecoration.so" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"


if [[ -d \
    "${SCRIPT_DIR}/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets" ]]
then

    cp -a \
        "${SCRIPT_DIR}/plugins/org.kde.kdecoration3.kcm/klassydecoration/presets/." \
        "${PLUGIN_ROOT}/org.kde.kdecoration3.kcm/klassydecoration/presets/"

fi


# ==========================================================================
# Qt compatibility symlinks
# ==========================================================================

QT_PLUGIN_ROOT="${LOCAL_PREFIX}/lib64/qt6/plugins"

echo
echo "Creating Klassy Qt compatibility symlinks..."

mkdir -p \
    "${QT_PLUGIN_ROOT}/styles" \
    "${QT_PLUGIN_ROOT}/kstyle_config" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3.kcm"


ln -sfn \
    "${PLUGIN_ROOT}/styles/klassy6.so" \
    "${QT_PLUGIN_ROOT}/styles/klassy6.so"

ln -sfn \
    "${PLUGIN_ROOT}/kstyle_config/klassystyleconfig.so" \
    "${QT_PLUGIN_ROOT}/kstyle_config/klassystyleconfig.so"

ln -sfn \
    "${PLUGIN_ROOT}/org.kde.kdecoration3/org.kde.klassy.so" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3/org.kde.klassy.so"

ln -sfn \
    "${PLUGIN_ROOT}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"


# ==========================================================================
# Install Klassy data files
# ==========================================================================

echo
echo "Installing Klassy data files..."

mkdir -p \
    "${LOCAL_PREFIX}/share/applications" \
    "${LOCAL_PREFIX}/share/color-schemes" \
    "${LOCAL_PREFIX}/share/icons/hicolor/scalable/apps" \
    "${LOCAL_PREFIX}/share/kf6/kcms" \
    "${LOCAL_PREFIX}/share/kstyle/themes" \
    "${LOCAL_PREFIX}/share/plasma/kcms/systemsettings" \
    "${LOCAL_PREFIX}/share/plasma/layout-templates"


if [[ -d "${SCRIPT_DIR}/share/applications" ]]; then
    cp -a \
        "${SCRIPT_DIR}/share/applications/." \
        "${LOCAL_PREFIX}/share/applications/"
fi

if [[ -d "${SCRIPT_DIR}/share/color-schemes" ]]; then
    cp -a \
        "${SCRIPT_DIR}/share/color-schemes/." \
        "${LOCAL_PREFIX}/share/color-schemes/"
fi

if [[ -f \
    "${SCRIPT_DIR}/share/icons/hicolor/scalable/apps/klassy-settings.svgz" ]]
then
    install -m 0644 \
        "${SCRIPT_DIR}/share/icons/hicolor/scalable/apps/klassy-settings.svgz" \
        "${LOCAL_PREFIX}/share/icons/hicolor/scalable/apps/klassy-settings.svgz"
fi

if [[ -f \
    "${SCRIPT_DIR}/share/kf6/kcms/kcm_klassydecoration.desktop" ]]
then
    install -m 0644 \
        "${SCRIPT_DIR}/share/kf6/kcms/kcm_klassydecoration.desktop" \
        "${LOCAL_PREFIX}/share/kf6/kcms/kcm_klassydecoration.desktop"
fi

if [[ -f \
    "${SCRIPT_DIR}/share/kstyle/themes/klassy.themerc" ]]
then
    install -m 0644 \
        "${SCRIPT_DIR}/share/kstyle/themes/klassy.themerc" \
        "${LOCAL_PREFIX}/share/kstyle/themes/klassy.themerc"
fi

if [[ -f \
    "${SCRIPT_DIR}/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop" ]]
then
    install -m 0644 \
        "${SCRIPT_DIR}/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop" \
        "${LOCAL_PREFIX}/share/plasma/kcms/systemsettings/kcm_klassydecoration.desktop"
fi

if [[ -d "${SCRIPT_DIR}/share/plasma/layout-templates" ]]; then
    cp -a \
        "${SCRIPT_DIR}/share/plasma/layout-templates/." \
        "${LOCAL_PREFIX}/share/plasma/layout-templates/"
fi


# ==========================================================================
# Environment
# ==========================================================================

echo
echo "Registering Klassy HOME environment..."

mkdir -p "${ENV_DIR}"

cat > "${ENV_FILE}" <<'EOF'
# The Ultimate Plasma — Klassy HOME installation

QT_PLUGIN_PATH=${HOME}/.local/lib64/qt6/plugins:${HOME}/.local/lib/qt6/plugins:${HOME}/.local/lib64/plugins:${HOME}/.local/lib/plugins:${QT_PLUGIN_PATH}

LD_LIBRARY_PATH=${HOME}/.local/lib64:${HOME}/.local/lib:${LD_LIBRARY_PATH}

XDG_DATA_DIRS=${HOME}/.local/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
EOF


# Remove the legacy TUP environment hook if present.
#
# The modern environment.d file above replaces it.

rm -f \
    "${HOME}/.config/plasma-workspace/env/klassy_env.sh"


# ==========================================================================
# Save installation state
# ==========================================================================

mkdir -p "${STATE_DIR}"

cat > "${STATE_FILE}" <<EOF
installation=prebuilt
source=The-Ultimate-Plasma bundled binaries
plasma=${PLASMA_VERSION}
prefix=${LOCAL_PREFIX}
qt_plugin_dir=${QT_PLUGIN_ROOT}
EOF


# ==========================================================================
# Refresh KDE metadata
# ==========================================================================

if command_exists kbuildsycoca6; then
    echo
    echo "Refreshing KDE service metadata..."

    kbuildsycoca6 --noincremental >/dev/null 2>&1 ||
        true
fi


# ==========================================================================
# Verification
# ==========================================================================

echo
echo "Verifying installed Klassy files..."

VERIFY_FAILED=0

for file in \
    "${LOCAL_PREFIX}/lib64/libklassycommon6.so.6" \
    "${PLUGIN_ROOT}/styles/klassy6.so" \
    "${PLUGIN_ROOT}/kstyle_config/klassystyleconfig.so" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3/org.kde.klassy.so" \
    "${PLUGIN_ROOT}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"
do

    if [[ -f "${file}" ]]; then
        echo "OK  ${file}"
    else
        echo "MISSING  ${file}"
        VERIFY_FAILED=1
    fi

done


for link in \
    "${QT_PLUGIN_ROOT}/styles/klassy6.so" \
    "${QT_PLUGIN_ROOT}/kstyle_config/klassystyleconfig.so" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3/org.kde.klassy.so" \
    "${QT_PLUGIN_ROOT}/org.kde.kdecoration3.kcm/kcm_klassydecoration.so"
do

    if [[ -L "${link}" && -e "${link}" ]]; then
        echo "OK  ${link}"
        echo "    -> $(readlink -f "${link}")"
    else
        echo "MISSING  ${link}"
        VERIFY_FAILED=1
    fi

done


if (( VERIFY_FAILED != 0 )); then
    die "One or more Klassy prebuilt files could not be verified."
fi


# ==========================================================================
# Finished
# ==========================================================================

echo
echo "============================================================"
echo " Klassy prebuilt HOME installation completed"
echo "============================================================"
echo
echo "Installed under:"
echo "  ${LOCAL_PREFIX}"
echo
echo "Host /usr was not modified."
echo
echo "IMPORTANT:"
echo "  If Klassy fails after a Qt/KF6 system update, uninstall this"
echo "  prebuilt version and use ./install-from-source.sh instead."
echo
echo "Log out and log back in before testing Klassy."
echo
