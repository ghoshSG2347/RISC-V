#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This setup script is intended for Kali/Debian-based Linux (APT)."
  exit 1
fi

echo "Updating package index..."
sudo apt-get update

echo "Installing VHDL simulator, waveform viewer, and build tools..."
sudo apt-get install -y ghdl gtkwave make git

echo
echo "Installation complete. Verify the tools with:"
echo "  ghdl --version"
echo "  gtkwave --version"
echo "  make --version"
echo
echo "VS Code is not installed or modified by this script."
