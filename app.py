import subprocess
import requests
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from io import BytesIO
import time
import os
import random

def get_current_song():
    try:
        title = subprocess.check_output(["playerctl", "metadata", "xesam:title"]).decode().strip()
        artist = subprocess.check_output(["playerctl", "metadata", "xesam:artist"]).decode().strip()
        art_url = subprocess.check_output(["playerctl", "metadata", "mpris:artUrl"]).decode().strip()
        return title, artist, art_url
    except subprocess.CalledProcessError:
        return None, None, None

def download_cover(url):
    if url.startswith("file://"):
        path = url.replace("file://", "")
        return Image.open(path).convert("RGBA")
    else:
        response = requests.get(url)
        return Image.open(BytesIO(response.content)).convert("RGBA")

def dominant_color(img, resize=150):
    img_small = img.resize((resize, resize))
    pixels = img_small.getdata()
    r = g = b = 0
    count = 0
    for p in pixels:
        if p[3] > 0:
            r += p[0]
            g += p[1]
            b += p[2]
            count += 1
    return (r//count, g//count, b//count) if count else (255,255,255)

def get_random_font(font_dir="fonts"):
    fonts = [os.path.join(font_dir, f) for f in os.listdir(font_dir) if f.endswith(".ttf")]
    if not fonts:
        return "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
    return random.choice(fonts)

def create_wallpaper(title, artist, cover_image, output_dir="wallpapers"):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    timestamp = int(time.time())
    filename = f"spotify_wallpaper_{timestamp}.png"
    output_path = os.path.join(output_dir, filename)

    width, height = 1920, 1080
    wallpaper = Image.new("RGBA", (width, height))

    bg = cover_image.resize((width, height))
    bg = bg.filter(ImageFilter.GaussianBlur(25))

    # Gradient overlay (cover dominant color)
    dom_r, dom_g, dom_b = dominant_color(cover_image)
    gradient = Image.new("RGBA", (width, height), (dom_r, dom_g, dom_b, 60))
    bg = Image.alpha_composite(bg, gradient)

    wallpaper.paste(bg, (0, 0))

    cover_resized = cover_image.resize((600, 600))
    shadow = Image.new("RGBA", cover_resized.size, (0,0,0,180))
    wallpaper.paste(shadow, (int((width-600)/2)+10, 110), shadow)
    wallpaper.paste(cover_resized, (int((width-600)/2), 100), cover_resized)

    draw = ImageDraw.Draw(wallpaper)

    r,g,b = dominant_color(cover_image)
    brightness = (r*299 + g*587 + b*114) / 1000
    font_color = (255,255,255) if brightness < 150 else (0,0,0)

    font_title = ImageFont.truetype(get_random_font(), 60)
    font_artist = ImageFont.truetype(get_random_font(), 40)

    shadow_color = (0,0,0,200)
    draw.text((width/2+2, 752), title, font=font_title, anchor="mm", fill=shadow_color)
    draw.text((width/2, 750), title, font=font_title, anchor="mm", fill=font_color)
    draw.text((width/2+1, 821), artist, font=font_artist, anchor="mm", fill=shadow_color)
    draw.text((width/2, 820), artist, font=font_artist, anchor="mm", fill=font_color)

    overlay = Image.new("RGBA", wallpaper.size, (0,0,0,40))
    wallpaper = Image.alpha_composite(wallpaper, overlay)

    wallpaper = wallpaper.convert("RGB")
    wallpaper.save(output_path)

    cleanup_old_wallpapers(output_dir)
    return os.path.abspath(output_path)

def cleanup_old_wallpapers(output_dir="wallpapers", keep_last=3):
    if not os.path.exists(output_dir):
        return
    files = sorted([os.path.join(output_dir, f) for f in os.listdir(output_dir) if f.endswith(".png")],
                   key=os.path.getmtime)
    while len(files) > keep_last:
        os.remove(files[0])
        files.pop(0)

def set_wallpaper_kde(path):
    script = f"""
var allDesktops = desktops();
for (i=0;i<allDesktops.length;i++) {{
    d = allDesktops[i];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
    d.writeConfig("Image", "file://{path}")
}}
"""
    subprocess.run([
        "qdbus",
        "org.kde.plasmashell",
        "/PlasmaShell",
        "org.kde.PlasmaShell.evaluateScript",
        script
    ])
    print("Wallpaper updated!")

last_title = None
last_artist = None
last_art_url = None

while True:
    title, artist, art_url = get_current_song()
    if title and artist and art_url:
        if title != last_title or artist != last_artist or art_url != last_art_url:
            try:
                cover = download_cover(art_url)
                wallpaper_path = create_wallpaper(title, artist, cover)
                set_wallpaper_kde(wallpaper_path)
                last_title = title
                last_artist = artist
                last_art_url = art_url
            except Exception as e:
                print(f"Error: {e}")
    else:
        print("No music playing.")
    time.sleep(3)
