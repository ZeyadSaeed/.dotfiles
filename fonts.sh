#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing ttf-ms-fonts with yay..."
yay -S --noconfirm ttf-ms-fonts

echo "Installing fonts with pacman..."
sudo pacman -S --noconfirm \
  ttf-jetbrains-mono \
  ttf-jetbrains-mono-nerd \
  ttf-symbola \
  ttf-dejavu \
  ttf-liberation \
  ttf-arphic-ukai \
  ttf-arphic-uming

echo "All fonts installed successfully!"
