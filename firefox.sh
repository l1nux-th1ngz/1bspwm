#!/bin/bash

set -e

# Update
sudo apt update

# Variables
KEYRING_DIR="/etc/apt/keyrings"
KEY_FILE="$KEYRING_DIR/packages.mozilla.org.gpg"
REPO_LIST="/etc/apt/sources.list.d/mozilla.list"
TEMP_KEYRING="$(mktemp)"
EXPECTED_FP="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

echo "Creating keyring directory..."
sudo install -d -m 0755 "$KEYRING_DIR"

echo "Downloading Mozilla's GPG key..."
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O mozilla-key.gpg

echo "Importing key for fingerprint verification..."
gpg --no-default-keyring --keyring "$TEMP_KEYRING" --import mozilla-key.gpg > /dev/null

echo "Verifying GPG fingerprint..."
ACTUAL_FP=$(gpg --no-default-keyring --keyring "$TEMP_KEYRING" --list-keys | awk '/^fpr:/ { print $2 }')

if [[ "$ACTUAL_FP" == "$EXPECTED_FP" ]]; then
  echo "Fingerprint match: $ACTUAL_FP"
  echo "Installing verified key to APT keyring..."
  sudo cp mozilla-key.gpg "$KEY_FILE"
else
  echo "Fingerprint mismatch!"
  echo "   Expected: $EXPECTED_FP"
  echo "   Actual:   $ACTUAL_FP"
  rm mozilla-key.gpg "$TEMP_KEYRING"
  exit 1
fi

rm mozilla-key.gpg "$TEMP_KEYRING"

echo "Adding Mozilla repository to APT sources..."
echo "deb [signed-by=$KEY_FILE] https://packages.mozilla.org/apt mozilla main" | sudo tee "$REPO_LIST" > /dev/null

echo "Configuring APT pinning..."
sudo tee /etc/apt/preferences.d/mozilla > /dev/null <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

echo "Updating package list..."
sudo apt update

echo "Installing Firefox from Mozilla APT repo..."
sudo apt install -y firefox

echo "Firefox installation complete!"
