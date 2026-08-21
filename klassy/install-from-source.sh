#!/usr/bin/env bash

# The Ultimate Plasma — Klassy HOME installer
#
# Builds Klassy inside a Fedora Distrobox and installs it entirely under
# ~/.local on the host.
#
# Nothing is installed into /usr on the host.
#
# The compatibility symlinks near the end of this script are intentional.
# They make Klassy's Qt style, style configuration module, KWin decoration
# and decoration KCM discoverable by Plasma without modifying the immutable
# host filesystem.

set -Eeuo pipefail


# ==========================================================================
# Configuration
# ==========================================================================

KLASSY_REPO="https://github.com/paulmcauley/klassy.git"
KLASSY_BRANCH="plasma6.6"

PLASMA_MIN_VERSION="6.6"
DEFAULT_FEDORA_VERSION="44"

TUP_CACHE_DIR="${HOME}/.cache/the-ultimate-plasma"
KLASSY_SRC_DIR="${TUP_CACHE_DIR}/klassy"

STATE_DIR="${HOME}/.local/state/the-ultimate-plasma"
ENV_DIR="${HOME}/.config/environment.d"
ENV_FILE="${ENV_DIR}/klassy.conf"


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


# ==========================================================================
# Header
# ==========================================================================

echo
echo "============================================================"
echo " The Ultimate Plasma — Klassy HOME installer"
echo "============================================================"
echo
echo "This installer:"
echo "  • builds Klassy inside Distrobox"
echo "  • builds Qt6/KF6 only"
echo "  • installs Klassy under \$HOME/.local"
echo "  • does not install Klassy into host /usr"
echo


# ==========================================================================
# Host requirements
# ==========================================================================

command_exists distrobox ||
    die "Distrobox was not found."

command_exists git ||
    die "Git was not found."

command_exists plasmashell ||
    die "plasmashell was not found. This installer is intended for KDE Plasma."


# ==========================================================================
# Plasma version
# ==========================================================================

PLASMA_VERSION="$(
    plasmashell --version 2>/dev/null |
        grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' |
        head -n1 || true
)"

if [[ -z "${PLASMA_VERSION}" ]]; then
    die "Could not detect the installed Plasma version."
fi

echo "Plasma detected: ${PLASMA_VERSION}"

if ! version_ge "${PLASMA_VERSION}" "${PLASMA_MIN_VERSION}"; then
    die "Klassy ${KLASSY_BRANCH} requires Plasma ${PLASMA_MIN_VERSION} or newer."
fi


# ==========================================================================
# Fedora builder version
# ==========================================================================
#
# The old TUP installer used Fedora 41.
#
# Klassy plasma6.6 requires a much newer Qt6/KF6 stack, so Fedora 44 is the
# current baseline.
#
# Advanced users can override it:
#
#   TUP_KLASSY_FEDORA_VERSION=44 ./install-from-source.sh
#

HOST_VERSION_ID="$(
    (
        . /etc/os-release 2>/dev/null || true
        printf '%s' "${VERSION_ID:-}"
    )
)"

if [[ -n "${TUP_KLASSY_FEDORA_VERSION:-}" ]]; then

    FEDORA_VERSION="${TUP_KLASSY_FEDORA_VERSION}"

elif [[ "${HOST_VERSION_ID}" =~ ^[0-9]+$ ]] &&
     (( HOST_VERSION_ID >= DEFAULT_FEDORA_VERSION )); then

    FEDORA_VERSION="${HOST_VERSION_ID}"

else

    FEDORA_VERSION="${DEFAULT_FEDORA_VERSION}"

fi

CONTAINER="tup-klassy-f${FEDORA_VERSION}"
FEDORA_IMAGE="registry.fedoraproject.org/fedora:${FEDORA_VERSION}"

echo "Fedora builder: ${FEDORA_VERSION}"
echo "Distrobox:      ${CONTAINER}"
echo "Install prefix: ${HOME}/.local"
echo


# ==========================================================================
# Create Distrobox
# ==========================================================================

if distrobox list 2>/dev/null | grep -Fq "${CONTAINER}"; then

    echo "Using existing Distrobox:"
    echo "  ${CONTAINER}"

else

    echo "Creating Distrobox:"
    echo "  ${CONTAINER}"
    echo

    distrobox create \
        --name "${CONTAINER}" \
        --image "${FEDORA_IMAGE}" \
        --yes ||
        die "Could not create Distrobox ${CONTAINER}."

fi


# ==========================================================================
# Build Klassy
# ==========================================================================
#
# Distrobox shares the user's HOME with the host.
#
# Therefore:
#
#   CMAKE_INSTALL_PREFIX=$HOME/.local
#
# writes directly into the host user's HOME while all build dependencies
# remain inside the Fedora container.
#
# BUILD_QT5=OFF is important. Plasma 6 uses Qt6 and we do not need the old
# Qt5/KF5 dependency tree just to build TUP's Klassy installation.
#

echo
echo "============================================================"
echo " Building Klassy"
echo "============================================================"
echo

distrobox enter "${CONTAINER}" -- \
    env \
        KLASSY_REPO="${KLASSY_REPO}" \
        KLASSY_BRANCH="${KLASSY_BRANCH}" \
        KLASSY_SRC_DIR="${KLASSY_SRC_DIR}" \
    bash -c '

set -Eeuo pipefail

echo
echo "Installing Qt6/KF6 build dependencies..."
echo

sudo dnf install -y \
    --setopt=install_weak_deps=False \
    git \
    gcc-c++ \
    make \
    cmake \
    extra-cmake-modules \
    gettext \
    "cmake(KDecoration3)" \
    "cmake(KF6ColorScheme)" \
    "cmake(KF6Config)" \
    "cmake(KF6ConfigWidgets)" \
    "cmake(KF6CoreAddons)" \
    "cmake(KF6FrameworkIntegration)" \
    "cmake(KF6GuiAddons)" \
    "cmake(KF6I18n)" \
    "cmake(KF6IconThemes)" \
    "cmake(KF6KCMUtils)" \
    "cmake(KF6WindowSystem)" \
    "cmake(Qt6Core)" \
    "cmake(Qt6DBus)" \
    "cmake(Qt6Quick)" \
    "cmake(Qt6Svg)" \
    "cmake(Qt6Widgets)" \
    "cmake(Qt6Xml)"

echo
echo "Preparing Klassy source tree..."
echo

mkdir -p "$(dirname "${KLASSY_SRC_DIR}")"

if [[ -d "${KLASSY_SRC_DIR}/.git" ]]; then

    echo "Updating existing TUP Klassy source cache..."

    cd "${KLASSY_SRC_DIR}"

    git fetch --prune origin

    git checkout -B \
        "${KLASSY_BRANCH}" \
        "origin/${KLASSY_BRANCH}"

else

    echo "Cloning Klassy..."

    rm -rf "${KLASSY_SRC_DIR}"

    git clone \
        --branch "${KLASSY_BRANCH}" \
        --single-branch \
        "${KLASSY_REPO}" \
        "${KLASSY_SRC_DIR}"

    cd "${KLASSY_SRC_DIR}"

fi

echo
echo "Klassy source revision:"
git --no-pager log -1 --oneline
echo


# Always start from a fresh build directory.
#
# This prevents CMake paths from an older Fedora/KF6/Qt6 environment from
# leaking into the new build.

rm -rf build
mkdir build
cd build


echo "Configuring Klassy..."
echo

cmake .. \
    -DCMAKE_INSTALL_PREFIX="${HOME}/.local" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF \
    -DBUILD_QT5=OFF \
    -DBUILD_QT6=ON


echo
echo "Compiling Klassy..."
echo

cmake --build . \
    --parallel "$(nproc)"


echo
echo "Installing Klassy into ${HOME}/.local..."
echo

# IMPORTANT:
#
# Never use sudo here.
#
# Klassy itself belongs entirely to the users HOME.

cmake --install .


echo
echo "Klassy build and HOME installation completed."
echo

'


# ==========================================================================
# Determine Plasma's user Qt plugin directory
# ==========================================================================

SYSTEM_QT_PLUGIN_DIR=""

if command_exists qtpaths6; then

    SYSTEM_QT_PLUGIN_DIR="$(
        qtpaths6 --query QT_INSTALL_PLUGINS 2>/dev/null ||
        qtpaths6 --plugin-dir 2>/dev/null ||
        true
    )"

elif command_exists qtpaths; then

    SYSTEM_QT_PLUGIN_DIR="$(
        qtpaths --query QT_INSTALL_PLUGINS 2>/dev/null ||
        true
    )"

fi


case "${SYSTEM_QT_PLUGIN_DIR}" in

    */lib/qt6/plugins)
        USER_QT_PLUGIN_DIR="${HOME}/.local/lib/qt6/plugins"
        ;;

    */lib64/qt6/plugins)
        USER_QT_PLUGIN_DIR="${HOME}/.local/lib64/qt6/plugins"
        ;;

    *)
        # Fedora x86_64 default.
        #
        # This also preserves the path used by the original working
        # The Ultimate Plasma Klassy installer.
        USER_QT_PLUGIN_DIR="${HOME}/.local/lib64/qt6/plugins"
        ;;

esac


echo
echo "Qt plugin directory used for the HOME installation:"
echo "  ${USER_QT_PLUGIN_DIR}"
echo


# ==========================================================================
# Locate Klassy plugins
# ==========================================================================

find_plugin() {

    local relative="$1"
    local candidate

    for candidate in \
        "${HOME}/.local/lib64/plugins/${relative}" \
        "${HOME}/.local/lib/plugins/${relative}" \
        "${HOME}/.local/lib64/qt6/plugins/${relative}" \
        "${HOME}/.local/lib/qt6/plugins/${relative}"
    do

        if [[ -f "${candidate}" ]]; then
            printf '%s\n' "${candidate}"
            return 0
        fi

    done

    return 1
}


link_plugin() {

    local relative="$1"
    local source
    local target

    source="$(find_plugin "${relative}")" ||
        die "Klassy plugin was not found after installation: ${relative}"

    target="${USER_QT_PLUGIN_DIR}/${relative}"

    mkdir -p "$(dirname "${target}")"


    # If source and destination already resolve to the same file, leave it
    # untouched.

    if [[ -e "${target}" ]] &&
       [[ "$(readlink -f "${source}")" == "$(readlink -f "${target}")" ]]; then

        echo "OK:"
        echo "  ${relative}"
        return 0

    fi


    ln -sfn "${source}" "${target}"


    echo "LINK:"
    echo "  ${target}"
    echo "    -> ${source}"

}


# ==========================================================================
# Critical HOME-only compatibility symlinks
# ==========================================================================
#
# DO NOT REMOVE THESE CASUALLY.
#
# These four links are what made it possible for the original TUP installer
# to expose a ~/.local Klassy installation correctly to Plasma without
# installing anything into /usr.
#

echo
echo "Creating Klassy compatibility symlinks..."
echo

link_plugin "styles/klassy6.so"

link_plugin \
    "kstyle_config/klassystyleconfig.so"

link_plugin \
    "org.kde.kdecoration3/org.kde.klassy.so"

link_plugin \
    "org.kde.kdecoration3.kcm/kcm_klassydecoration.so"


# ==========================================================================
# Plasma environment
# ==========================================================================

echo
echo "Registering Klassy HOME environment..."
echo

mkdir -p "${ENV_DIR}"

cat > "${ENV_FILE}" <<'EOF'
# The Ultimate Plasma — Klassy HOME installation
#
# Makes the user-local Klassy Qt/KDE plugins and libraries visible to Plasma.

QT_PLUGIN_PATH=${HOME}/.local/lib64/qt6/plugins:${HOME}/.local/lib/qt6/plugins:${HOME}/.local/lib64/plugins:${HOME}/.local/lib/plugins:${QT_PLUGIN_PATH}

LD_LIBRARY_PATH=${HOME}/.local/lib64:${HOME}/.local/lib:${LD_LIBRARY_PATH}

XDG_DATA_DIRS=${HOME}/.local/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
EOF


echo "Environment file:"
echo "  ${ENV_FILE}"


# ==========================================================================
# Save installation information
# ==========================================================================

mkdir -p "${STATE_DIR}"

KLASSY_COMMIT="$(
    git -C "${KLASSY_SRC_DIR}" rev-parse HEAD 2>/dev/null ||
    true
)"

cat > "${STATE_DIR}/klassy-build.txt" <<EOF
repository=${KLASSY_REPO}
branch=${KLASSY_BRANCH}
commit=${KLASSY_COMMIT}
fedora_builder=${FEDORA_VERSION}
container=${CONTAINER}
prefix=${HOME}/.local
qt_plugin_dir=${USER_QT_PLUGIN_DIR}
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
# Verify important files
# ==========================================================================

echo
echo "Verifying Klassy plugins..."
echo

VERIFY_FAILED=0

for plugin in \
    "styles/klassy6.so" \
    "kstyle_config/klassystyleconfig.so" \
    "org.kde.kdecoration3/org.kde.klassy.so" \
    "org.kde.kdecoration3.kcm/kcm_klassydecoration.so"
do

    target="${USER_QT_PLUGIN_DIR}/${plugin}"

    if [[ -e "${target}" ]]; then

        echo "OK  ${target}"
        echo "    -> $(readlink -f "${target}")"

    else

        echo "MISSING  ${target}"
        VERIFY_FAILED=1

    fi

done


if (( VERIFY_FAILED != 0 )); then
    die "One or more Klassy plugins could not be verified."
fi


# ==========================================================================
# Finished
# ==========================================================================

echo
echo "============================================================"
echo " Klassy HOME installation completed successfully"
echo "============================================================"
echo
echo "Klassy was installed under:"
echo "  ${HOME}/.local"
echo
echo "Host /usr was not modified by the Klassy installation."
echo
echo "Build information:"
echo "  ${STATE_DIR}/klassy-build.txt"
echo
echo "Log out and log back in before testing Klassy."
echo
echo "Then check:"
echo "  System Settings -> Colors & Themes -> Application Style"
echo "  System Settings -> Colors & Themes -> Window Decorations"
echo
