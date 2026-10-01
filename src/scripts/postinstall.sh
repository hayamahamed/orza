#!/bin/sh
set -eu

DEFAULTS_FILE="/opt/orza/defaults"

# Set application icons.
seticon() {
    ICON_DIR="/opt/orza/icon"
    ICON_DEST="/usr/share/icons/hicolor"

    mkdir -p "$ICON_DEST/scalable/apps"

    cp "$ICON_DIR/orifice" \
        "$ICON_DEST/scalable/apps/orza"

    for size in 16 24 32 48 64 128 256; do
        mkdir -p "$ICON_DEST/${size}x${size}/apps"

        cp "$ICON_DIR/orza-$size" \
            "$ICON_DEST/${size}x${size}/apps/orifice"
    done

    gtk-update-icon-cache -f -t "$ICON_DEST" 2>/dev/null || true
}

seticon


# Set up the Chrome management service.
# Creates the chromemgmt group, configures the service binary,
# and creates the device trust signing key when enabled.
chrome_management_service_setup() {
    if [ ! -f "$DEFAULTS_FILE" ]; then
        return
    fi

    if ! grep -q "install_device_trust_key_management_command=true" \
        "$DEFAULTS_FILE"; then
        return
    fi

    if ! getent group chromemgmt >/dev/null 2>&1; then
        groupadd chromemgmt
    fi

    chgrp chromemgmt \
        "/opt/orifice/chrome-management-service"

    chmod 2755 \
        "/opt/orifice/chrome-management-service"

    SIGNING_KEY_DIR="/etc/orifice/policies/enrollment"
    SIGNING_KEY_FILE="$SIGNING_KEY_DIR/DeviceTrustSigningKey"

    mkdir -p "$SIGNING_KEY_DIR"

    if [ ! -e "$SIGNING_KEY_FILE" ]; then
        touch "$SIGNING_KEY_FILE"
    fi

    chgrp chromemgmt "$SIGNING_KEY_FILE"
    chmod 664 "$SIGNING_KEY_FILE"
}

chrome_management_service_setup


