#!/bin/bash

echo "Spotify Wallpaper Kuruluyor..."

DEPENDENCIES=(playerctl wget imagemagick qdbus)

for pkg in "${DEPENDENCIES[@]}"; do
  if ! command -v "$pkg" &> /dev/null; then
    echo "Eksik bağımlılık: $pkg"
    echo "Lütfen sistem paket yöneticisi ile kurun (örnek: sudo apt install $pkg)"
    exit 1
  fi
done

chmod +x spotify-wallpaper.sh
mkdir -p ~/.local/bin
cp spotify-wallpaper.sh ~/.local/bin/

echo "Kurulum tamamlandı. Script şuraya kopyalandı: ~/.local/bin/spotify-wallpaper.sh"
echo "Başlatmak için terminale şunu yazın: bash ~/.local/bin/spotify-wallpaper.sh"
