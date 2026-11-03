#!/usr/bin/env bash
# NothingOS 5.0 for Pixel 9 Pro XL (komodo) - flasher
# Run with the phone in BOOTLOADER mode (Power + Vol-) and connected via USB.
set -e
cd "$(dirname "$0")"
FB=${FASTBOOT:-fastboot}
command -v "$FB" >/dev/null || { echo "fastboot not found (install platform-tools)"; exit 1; }

echo "== Checking files"
sha256sum -c SHA256SUMS || { echo "Checksum mismatch, re-download the archive"; exit 1; }

echo "== Waiting for device in bootloader"
PROD=$($FB getvar product 2>&1 | awk '/^product:/{print $2}')
[ "$PROD" = "komodo" ] || { echo "This is not a Pixel 9 Pro XL (komodo), got: '$PROD'"; exit 1; }
BL=$($FB getvar version-bootloader 2>&1 | awk '/^version-bootloader:/{print $2}')
if [ "$BL" != "ripcurrentpro-15.2-13237002" ]; then
  echo "WARNING: bootloader $BL != ripcurrentpro-15.2-13237002 (stock BP1A.250505.005)."
  echo "Flash the BP1A.250505.005 factory image first (see README)."
  read -rp "Continue anyway? [y/N] " a; [ "$a" = "y" ] || exit 1
fi

echo "== Flashing vendor_boot + vbmeta (bootloader)"
$FB flash vendor_boot vendor_boot.img
$FB flash --disable-verity --disable-verification vbmeta vbmeta.img

echo "== Rebooting to fastbootd"
$FB reboot fastboot
sleep 5
until $FB getvar is-userspace 2>&1 | grep -q "is-userspace: yes"; do sleep 2; done

echo "== Flashing system images (fastbootd)"
$FB flash product product.img
$FB flash system system.img
$FB flash system_ext system_ext.img

read -rp "Wipe data (REQUIRED when coming from stock or another ROM)? [Y/n] " w
if [ "$w" != "n" ]; then $FB -w; fi

$FB reboot
echo "== Done. First boot takes 3-5 minutes."
