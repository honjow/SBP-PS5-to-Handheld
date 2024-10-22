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
THEME_FOLDER="${HOMEBREW_FOLDER}/themes"

function set_default() {
    PROFILE=$1
    # replace `: "Xbox" to` `: "$1"
    if [[ -f "${THEME_FOLDER}/SBP-PS5-to-Handheld/config_USER.json" ]]; then
        sed -i "s#: \"Xbox\"#: \"$PROFILE\"#g" "${THEME_FOLDER}/SBP-PS5-to-Handheld/config_USER.json"
    fi
    # replace `: false` `: true`
    if [[ -f "${THEME_FOLDER}/SBP-PS5-to-Handheld/config_USER.json" ]]; then
        sed -i "s#false#true#g" "${THEME_FOLDER}/SBP-PS5-to-Handheld/config_USER.json"
    fi
}

url="https://github.com/honjow/SBP-PS5-to-Handheld.git"

if [[ -d "${THEME_FOLDER}/SBP-PS5-to-Handheld" ]]; then
    rm -rf "${THEME_FOLDER}/SBP-PS5-to-Handheld"
fi

git clone "${url}" --depth=1 "${THEME_FOLDER}/SBP-PS5-to-Handheld"

AYANEO_AIR_LIST="AIR:AIR Pro:AIR Plus:AIR 1S:AIR 1S Limited"

PRODUCT_MATCH=false
if [[ "$PRODUCT" =~ "ROG Ally RC71L" ]]; then
    echo "ROG Ally"
    set_default "ROG Ally"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "G1617-01" ]]; then
    # GPD Win Mini
    echo "GPD Win Mini"
    set_default "GPD Win Mini"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "G1618-04" ]]; then
    ehco "GPD Win 4"
    set_default "GPD Win4"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "G1618-03" ]]; then
    echo "GPD Win3"
    set_default "GPD Win3"
    PRODUCT_MATCH=true
elif [[ ":$AYANEO_AIR_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "AYANEO AIR Series"
    set_default "AYANEO AIR"
    PRODUCT_MATCH=true
elif [[ "$PRODUCT" == "83E1" ]]; then
    echo "Legion Go"
    set_default "Legion Go"
    PRODUCT_MATCH=true
fi

if [[ "$PRODUCT_MATCH" == true ]]; then
    exit 0
fi

if [[ "$VENDOR" == "AYANEO" ]]; then
    echo "AYANEO"
    set_default "AYANEO"
elif [[ "$VENDOR" == "GPD" ]]; then
    echo "GPD"
    set_default "GPD"
elif [[ "$VENDOR" == "AOKZOE" || "$VENDOR" == "ONE-NETBOOK" ]]; then
    echo "Aokzoe/OneXPlayer"
    set_default "Aokzoe/OneXPlayer"
fi