#!/bin/bash

# Spotify Wallpaper Script - KDE Plasma
# Dinlenen şarkının albüm kapağını arka plan yapar

LOGFILE="/tmp/spotify_wallpaper_debug.log"
echo "Başladı: $(date)" > "$LOGFILE"

FONT_PATH="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
[ -f "/usr/share/fonts/truetype/open-sans/OpenSans-Bold.ttf" ] && FONT_PATH="/usr/share/fonts/truetype/open-sans/OpenSans-Bold.ttf"

LAST_TITLE=""
OLD_WALL=""

while true; do
  if ! playerctl --player=spotify status &> /dev/null; then
    echo "$(date): Spotify çalışmıyor" >> "$LOGFILE"
    sleep 5
    continue
  fi

  TITLE="$(playerctl metadata title 2>/dev/null)"
  ARTIST="$(playerctl metadata artist 2>/dev/null)"
  COVER_URL="$(playerctl metadata mpris:artUrl 2>/dev/null | sed 's/^.*https/https/')"

  if [[ "$TITLE" != "$LAST_TITLE" && -n "$TITLE" ]]; then
    echo "$(date): Yeni şarkı: $ARTIST - $TITLE" >> "$LOGFILE"

    # Önceki wallpaper'ı sil
    if [[ -n "$OLD_WALL" && -f "$OLD_WALL" ]]; then
      ( sleep 10 && rm -f "$OLD_WALL" && echo "$(date): Eski wallpaper silindi: $OLD_WALL" >> "$LOGFILE" ) &
    fi

    LAST_TITLE="$TITLE"
    SAFE_NAME=$(echo "$ARTIST-$TITLE" | tr -cd '[:alnum:]_-')
    FINAL_WALL="/tmp/wallpaper_$SAFE_NAME.jpg"
    OLD_WALL="$FINAL_WALL"

    if wget -q "$COVER_URL" -O /tmp/spotify_cover.jpg; then
      echo "$(date): Kapak indirildi" >> "$LOGFILE"
    else
      echo "$(date): Kapak indirilemedi: $COVER_URL" >> "$LOGFILE"
      continue
    fi

    TEXT="$ARTIST - $TITLE"
    FORMATTED_TEXT=$(echo "$TEXT" | fold -s -w 40)

    if convert -size 1920x1080 xc:black \
      \( /tmp/spotify_cover.jpg -resize 500x500^ -gravity center -extent 500x500 \) -gravity center -geometry +0-100 -composite \
      -font "$FONT_PATH" -pointsize 40 -fill white -stroke black -strokewidth 2 -gravity center \
      -annotate +0+300 "$FORMATTED_TEXT" "$FINAL_WALL"; then
      echo "$(date): Görsel oluşturuldu: $FINAL_WALL" >> "$LOGFILE"
    else
      echo "$(date): convert başarısız oldu" >> "$LOGFILE"
      continue
    fi

    if qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (i=0;i<allDesktops.length;i++) {
      d = allDesktops[i];
      d.wallpaperPlugin = 'org.kde.image';
      d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
      d.writeConfig('Image', 'file://$FINAL_WALL');
    }"; then
      echo "$(date): Wallpaper değiştirildi: $FINAL_WALL" >> "$LOGFILE"
    else
      echo "$(date): qdbus wallpaper komutu başarısız oldu" >> "$LOGFILE"
    fi
  fi

  sleep 5
done
