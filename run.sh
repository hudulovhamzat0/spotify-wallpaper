#!/bin/bash
# Spotify Wallpaper Script - KDE Plasma with Anime Characters

# Parametreler: -p <karakter klasörü> veya -x <dış script>
CHARACTER_DIR=""
EXTERNAL_SCRIPT=""

while getopts ":p:x:" opt; do
  case ${opt} in
    p )
      CHARACTER_DIR="$OPTARG"
      ;;
    x )
      EXTERNAL_SCRIPT="$OPTARG"
      ;;
    \? )
      echo "Geçersiz seçenek: -$OPTARG" >&2
      exit 1
      ;;
    : )
      echo "Seçenek -$OPTARG bir değer gerektiriyor." >&2
      exit 1
      ;;
  esac
done

# -p ve -x birlikte kullanılamaz
if [[ -n "$CHARACTER_DIR" && -n "$EXTERNAL_SCRIPT" ]]; then
  echo "HATA: -p ve -x aynı anda kullanılamaz!"
  echo "Kullanım:"
  echo "  bash run.sh -p /path/to/anime"
  echo "  bash run.sh -x /path/to/script.sh"
  exit 1
fi

# Eğer -x verildiyse dış scripti çalıştır
if [[ -n "$EXTERNAL_SCRIPT" ]]; then
  if [[ -x "$EXTERNAL_SCRIPT" ]]; then
    echo "Dış script çalıştırılıyor: $EXTERNAL_SCRIPT"
    exec "$EXTERNAL_SCRIPT"
  else
    echo "HATA: '$EXTERNAL_SCRIPT' çalıştırılamaz veya yok."
    exit 1
  fi
fi

# Eğer -p verilmediyse hata
if [[ -z "$CHARACTER_DIR" ]]; then
  echo "HATA: Karakter klasörü belirtilmedi!"
  echo "Kullanım: bash run.sh -p /path/to/anime"
  exit 1
fi

# Karakter dosyaları bu klasöre göre tanımlanacak
CHARACTER_BLACK="$CHARACTER_DIR/black.png"
CHARACTER_BLUE="$CHARACTER_DIR/blue.png"
CHARACTER_GREEN="$CHARACTER_DIR/green.png"
CHARACTER_PINK="$CHARACTER_DIR/pink.png"
CHARACTER_RED="$CHARACTER_DIR/red.png"
CHARACTER_WHITE="$CHARACTER_DIR/white.png"
CHARACTER_YELLOW="$CHARACTER_DIR/yellow.png"

# Font kontrolü
FONT_PATH="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
[ -f "/usr/share/fonts/truetype/open-sans/OpenSans-Bold.ttf" ] && FONT_PATH="/usr/share/fonts/truetype/open-sans/OpenSans-Bold.ttf"

LOGFILE="/tmp/spotify_wallpaper_debug.log"
echo "Başladı: $(date)" > "$LOGFILE"

LAST_TITLE=""
LAST_COVER_URL=""
OLD_WALL=""


# Aşağıdaki while döngüsü, ve kalan tüm orijinal kodun olduğu gibi devam etsin.
# Hiçbir değişikliğe gerek yok çünkü karakter dosyaları artık dışarıdan geldi:
# while true; do ... gibi devam eder.

while true; do
    if ! playerctl --player=spotify status &> /dev/null; then
        echo "$(date): Spotify çalışmıyor" >> "$LOGFILE"
        sleep 5
        continue
    fi

    TITLE="$(playerctl metadata title 2>/dev/null)"
    ARTIST="$(playerctl metadata artist 2>/dev/null)"
    COVER_URL="$(playerctl metadata mpris:artUrl 2>/dev/null | sed 's/^.*https/https/')"

    if [[ "$TITLE" != "$LAST_TITLE" || "$COVER_URL" != "$LAST_COVER_URL" ]]; then
        echo "$(date): Yeni şarkı: $ARTIST - $TITLE" >> "$LOGFILE"
        
        if [[ -n "$OLD_WALL" && -f "$OLD_WALL" ]]; then
            ( sleep 10 && rm -f "$OLD_WALL" && echo "$(date): Eski wallpaper silindi: $OLD_WALL" >> "$LOGFILE" ) &
        fi

        LAST_TITLE="$TITLE"
        LAST_COVER_URL="$COVER_URL"
        SAFE_NAME=$(echo "$ARTIST-$TITLE" | tr -cd '[:alnum:]_-')
        FINAL_WALL="/tmp/wallpaper_$SAFE_NAME.jpg"
        OLD_WALL="$FINAL_WALL"

        if wget -q "$COVER_URL" -O /tmp/spotify_cover.jpg; then
            echo "$(date): Kapak indirildi" >> "$LOGFILE"
        else
            echo "$(date): Kapak indirilemedi: $COVER_URL" >> "$LOGFILE"
            continue
        fi

        # Gradient renkleri kapağın en üst ve en alt piksellerinden al
        COLORS=($(convert /tmp/spotify_cover.jpg -resize 1x2\! -format "%[pixel:u.p{0,0}] %[pixel:u.p{0,1}]" info:-))
        COLOR1=${COLORS[0]}
        COLOR2=${COLORS[1]}

        # Get multiple color samples for better accuracy
        DOMINANT_COLOR=$(convert /tmp/spotify_cover.jpg -resize 1x1 -format "%[fx:int(255*r)],%[fx:int(255*g)],%[fx:int(255*b)]" info:-)
        
        # Also get average color from center area of the image
        CENTER_COLOR=$(convert /tmp/spotify_cover.jpg -gravity center -crop 50%x50%+0+0 -resize 1x1 -format "%[fx:int(255*r)],%[fx:int(255*g)],%[fx:int(255*b)]" info:-)
        
        echo "$(date): Dominant color RGB: $DOMINANT_COLOR" >> "$LOGFILE"
        echo "$(date): Center color RGB: $CENTER_COLOR" >> "$LOGFILE"

        # Extract RGB values from dominant color
        IFS=',' read -r RED GREEN BLUE <<< "$DOMINANT_COLOR"
        
        # Extract RGB values from center color
        IFS=',' read -r CENTER_RED CENTER_GREEN CENTER_BLUE <<< "$CENTER_COLOR"
        
        # Use weighted average of both samples
        RED=$(( (RED * 3 + CENTER_RED * 2) / 5 ))
        GREEN=$(( (GREEN * 3 + CENTER_GREEN * 2) / 5 ))
        BLUE=$(( (BLUE * 3 + CENTER_BLUE * 2) / 5 ))

        # Determine if color is more blue/cool or red/warm
        BLUE_SCORE=$((BLUE - RED))
        echo "$(date): RGB: R=$RED G=$GREEN B=$BLUE, Blue score: $BLUE_SCORE" >> "$LOGFILE"

        # Gradient arka plan oluştur
        convert -size 1920x1080 gradient:"$COLOR1"-"$COLOR2" /tmp/spotify_gradient_bg.jpg

        TEXT="$ARTIST - $TITLE"
        FORMATTED_TEXT=$(echo "$TEXT" | fold -s -w 40)

        # Select character based on dominant color analysis
        # Calculate color properties
        BRIGHTNESS=$((RED + GREEN + BLUE))
        MAX_COLOR=$(( RED > GREEN ? (RED > BLUE ? RED : BLUE) : (GREEN > BLUE ? GREEN : BLUE) ))
        SATURATION=0
        if [ $MAX_COLOR -gt 0 ]; then
            MIN_COLOR=$(( RED < GREEN ? (RED < BLUE ? RED : BLUE) : (GREEN < BLUE ? GREEN : BLUE) ))
            SATURATION=$(( (MAX_COLOR - MIN_COLOR) * 100 / MAX_COLOR ))
        fi

        echo "$(date): Brightness: $BRIGHTNESS, Saturation: $SATURATION, Max: $MAX_COLOR" >> "$LOGFILE"

        # Character selection logic - much more accurate with better pink detection
        # Calculate differences more precisely
        RED_DOMINANCE=$((RED - ((GREEN + BLUE) / 2)))
        GREEN_DOMINANCE=$((GREEN - ((RED + BLUE) / 2)))
        BLUE_DOMINANCE=$((BLUE - ((RED + GREEN) / 2)))
        
        # Special calculations for mixed colors
        PINK_SCORE=$((RED + BLUE - (GREEN * 2)))  # Pink = high red + blue, low green
        YELLOW_SCORE=$((RED + GREEN - (BLUE * 2))) # Yellow = high red + green, low blue
        
        echo "$(date): Final RGB: R=$RED G=$GREEN B=$BLUE" >> "$LOGFILE"
        echo "$(date): Dominance - Red: $RED_DOMINANCE, Green: $GREEN_DOMINANCE, Blue: $BLUE_DOMINANCE" >> "$LOGFILE"
        echo "$(date): Mixed - Pink score: $PINK_SCORE, Yellow score: $YELLOW_SCORE" >> "$LOGFILE"
        
        if [ $BRIGHTNESS -lt 180 ]; then
            # Very dark colors
            CHAR_IMAGE="$CHARACTER_BLACK"
            CHARACTER_NAME="Black"
        elif [ $BRIGHTNESS -gt 650 ] || ([ $RED -gt 220 ] && [ $GREEN -gt 220 ] && [ $BLUE -gt 220 ]); then
            # Very bright/white colors
            CHAR_IMAGE="$CHARACTER_WHITE"
            CHARACTER_NAME="White"
        elif [ $PINK_SCORE -gt 60 ] && [ $RED -gt 100 ] && [ $BLUE -gt 80 ]; then
            # Pink/Magenta - prioritize over single colors
            CHAR_IMAGE="$CHARACTER_PINK"
            CHARACTER_NAME="Pink"
        elif [ $YELLOW_SCORE -gt 60 ] && [ $RED -gt 100 ] && [ $GREEN -gt 100 ]; then
            # Yellow - prioritize over single colors
            CHAR_IMAGE="$CHARACTER_YELLOW"
            CHARACTER_NAME="Yellow"
        elif [ $RED_DOMINANCE -gt 35 ] && [ $RED -gt 80 ] && [ $PINK_SCORE -lt 40 ]; then
            # Pure red (not pink)
            CHAR_IMAGE="$CHARACTER_RED"
            CHARACTER_NAME="Red"
        elif [ $BLUE_DOMINANCE -gt 35 ] && [ $BLUE -gt 80 ]; then
            # Blue is clearly dominant
            CHAR_IMAGE="$CHARACTER_BLUE"
            CHARACTER_NAME="Blue"
        elif [ $GREEN_DOMINANCE -gt 35 ] && [ $GREEN -gt 80 ]; then
            # Green is clearly dominant
            CHAR_IMAGE="$CHARACTER_GREEN"
            CHARACTER_NAME="Green"
        else
            # Fallback - check for subtle mixed colors or pick dominant
            if [ $PINK_SCORE -gt 20 ] && [ $RED -gt 60 ] && [ $BLUE -gt 50 ]; then
                CHAR_IMAGE="$CHARACTER_PINK"
                CHARACTER_NAME="Pink (subtle)"
            elif [ $YELLOW_SCORE -gt 20 ] && [ $RED -gt 60 ] && [ $GREEN -gt 60 ]; then
                CHAR_IMAGE="$CHARACTER_YELLOW"
                CHARACTER_NAME="Yellow (subtle)"
            elif [ $RED_DOMINANCE -gt $GREEN_DOMINANCE ] && [ $RED_DOMINANCE -gt $BLUE_DOMINANCE ]; then
                CHAR_IMAGE="$CHARACTER_RED"
                CHARACTER_NAME="Red (dominant)"
            elif [ $BLUE_DOMINANCE -gt $GREEN_DOMINANCE ]; then
                CHAR_IMAGE="$CHARACTER_BLUE"
                CHARACTER_NAME="Blue (dominant)"
            else
                CHAR_IMAGE="$CHARACTER_GREEN"
                CHARACTER_NAME="Green (dominant)"
            fi
        fi

        echo "$(date): $CHARACTER_NAME karakter seçildi - RGB($RED,$GREEN,$BLUE)" >> "$LOGFILE"

        # Random corner position (bottom-left or bottom-right)
        if [ $((RANDOM % 2)) -eq 0 ]; then
            CHAR_POSITION="southwest"
            CHAR_GEOMETRY="+100+35"
            echo "$(date): Sol alt köşe seçildi" >> "$LOGFILE"
        else
            CHAR_POSITION="southeast"
            CHAR_GEOMETRY="+0+35"
            echo "$(date): Sağ alt köşe seçildi" >> "$LOGFILE"
        fi

        # Check if character file exists
        if [[ ! -f "$CHAR_IMAGE" ]]; then
            echo "$(date): Karakter dosyası bulunamadı: $CHAR_IMAGE" >> "$LOGFILE"
            continue
        fi

        # Kapağı gradient arka plana yerleştir, anime karakter ekle ve yazı ekle
        if convert /tmp/spotify_gradient_bg.jpg \
            \( /tmp/spotify_cover.jpg -resize 500x500^ -gravity center -extent 500x500 \) -gravity center -geometry +0-100 -composite \
\( "$CHAR_IMAGE" -resize 350x350 \) -gravity "$CHAR_POSITION" -geometry "$CHAR_GEOMETRY" -composite \
            -font "$FONT_PATH" -pointsize 40 -fill white -stroke black -strokewidth 2 -gravity center \
            -annotate +0+350 "$FORMATTED_TEXT" "$FINAL_WALL"; then
            echo "$(date): Görsel oluşturuldu: $FINAL_WALL (Karakter: $CHARACTER_NAME)" >> "$LOGFILE"
        else
            echo "$(date): convert başarısız oldu" >> "$LOGFILE"
            continue
        fi

        # KDE wallpaper ayarla
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