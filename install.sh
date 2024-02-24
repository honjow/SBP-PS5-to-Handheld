#!/bin/bash

set -e

# cant run this script as root
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as a normal user, not root."
    exit 1
fi

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)
VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor)

HOMEBREW_FOLDER="${HOME}/homebrew"
THEME_FOLDER="${HOME}/themes"

url="https://github.com/honjow/SBP-PS5-to-Handheld.git"

if [[ -d "${HOMEBREW_FOLDER}/SBP-PS5-to-Handheld" ]]; then
    rm -rf "${HOMEBREW_FOLDER}/SBP-PS5-to-Handheld"
else
    git clone "${url}" --depth=1 "${HOMEBREW_FOLDER}/SBP-PS5-to-Handheld"
fi

function set_default() {
    PROFILE=$1
    # replace `: "Xbox" to` `: "$1"
    sed -i "s#: \"Xbox\"#: \"$PROFILE\"#g" "${HOMEBREW_FOLDER}/themes/SBP-PS5-to-Handheld/config_USER.json"

}

if [[ "$PRODUCT" =~ "ROG Ally RC71L" ]]; then
    set_default "ROG Ally"
elif [[ "$PRODUCT" == "G1617-01" ]]; then
    # GPD Win Mini
    set_default "GPD Win Mini"
elif [[ "$PRODUCT" == "G1618-04" ]]; then
    # GPD Win4
    set_default "GPD Win4"
elif [[ "$VENDOR" == "AYANEO" ]]; then
    set_default "AYANEO"
elif [[ "$VENDOR" == "GPD" ]]; then
    set_default "GPD"
elif [[ "$VENDOR" == "AOKZOE" || "$VENDOR" == "ONE-NETBOOK" ]]; then
    set_default "Aokzoe/OneXPlayer"
fi
