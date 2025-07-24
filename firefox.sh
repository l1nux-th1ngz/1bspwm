#!/bin/bash

# Update
sudo apt update

# Variables
KEYRING_DIR="/etc/apt/keyrings"
KEY_FILE="$KEYRING_DIR/packages.mozilla.org.asc"
REPO_LIST="/etc/apt/sources.list.d/mozilla.list"
EXPECTED_FP="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

echo "Creating keyring directory..."
sudo install -d -m 0755 "$KEYRING_DIR"

echo "Downloading Mozilla's GPG key..."
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee "$KEY_FILE" > /dev/null

echo "Verifying GPG fingerprint..."
ACTUAL_FP=$(gpg --no-default-keyring --keyring "$KEY_FILE" --list-keys | awk '/^fpr:/ { print $10 }')

if [[ "$ACTUAL_FP" == "$EXPECTED_FP" ]]; then
  echo "Fingerprint match: $ACTUAL_FP"
else
  echo "Fingerprint mismatch!"
  echo "   Expected: $EXPECTED_FP"
  echo "   Actual:   $ACTUAL_FP"
  exit 1
fi

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

echo "Updating package list..."
sudo apt update

echo "Firefox installation complete!"
