# Spotify/Music Player Dynamic Wallpaper Generator

A Python script that automatically generates and sets desktop wallpapers based on the currently playing song in any MPRIS-compatible music player (Spotify, VLC, etc.). The wallpaper features album artwork with a blurred background, gradient overlay, and song information.

![ Screenshot](screenshot1.png)
![ Screenshot](screenshot2.png)
![ Screenshot](screenshot3.png)

## Features

- 🎵 **Automatic Detection**: Monitors currently playing music via `playerctl`
- 🎨 **Dynamic Wallpaper Generation**: Creates beautiful 1920x1080 wallpapers with:
  - Blurred album artwork background
  - Centered album cover with shadow effect
  - Song title and artist name
  - Gradient overlay based on dominant album colors
  - Smart text color selection (white/black based on background brightness)
- 🔄 **Real-time Updates**: Automatically updates wallpaper when song changes
- 🎲 **Random Fonts**: Uses random fonts from a `fonts/` directory for variety
- 🧹 **Auto Cleanup**: Keeps only the last 3 generated wallpapers
- 🖥️ **KDE Plasma Support**: Seamlessly integrates with KDE Plasma desktop

## Requirements

### System Dependencies
```bash
# Install playerctl (for media control detection)
sudo apt install playerctl      # Debian/Ubuntu
sudo pacman -S playerctl        # Arch Linux
sudo dnf install playerctl      # Fedora
```

### Python Dependencies
```bash
pip install pillow requests
```

## Installation

1. Clone or download this repository:
```bash
git clone <repository-url>
cd spotify-wallpaper-generator
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. (Optional) Add custom fonts:
```bash
mkdir fonts
# Copy your favorite .ttf font files to the fonts/ directory
```

## Usage

### Basic Usage
Simply run the script:
```bash
python spotify_wallpaper.py
```

The script will:
- Monitor your currently playing music every 3 seconds
- Generate a new wallpaper when the song changes
- Automatically set it as your KDE Plasma wallpaper
- Save wallpapers to the `wallpapers/` directory

### Running as a Background Service

To run automatically on startup, create a systemd user service:

1. Create service file: `~/.config/systemd/user/spotify-wallpaper.service`
```ini
[Unit]
Description=Spotify Dynamic Wallpaper Generator
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /path/to/spotify_wallpaper.py
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

2. Enable and start the service:
```bash
systemctl --user enable spotify-wallpaper.service
systemctl --user start spotify-wallpaper.service
```

## Configuration

### Output Directory
Change where wallpapers are saved:
```python
output_dir = "wallpapers"  # Default
```

### Wallpaper Resolution
Modify dimensions in the `create_wallpaper()` function:
```python
width, height = 1920, 1080  # Change to your screen resolution
```

### Cleanup Settings
Adjust how many wallpapers to keep:
```python
cleanup_old_wallpapers(output_dir, keep_last=3)  # Keep last 3 wallpapers
```

### Poll Interval
Change how often the script checks for song changes:
```python
time.sleep(3)  # Check every 3 seconds
```

## Compatibility

### Supported Music Players
Any MPRIS-compatible player works, including:
- Spotify
- VLC
- Rhythmbox
- Audacious
- Clementine
- And many more

### Desktop Environments
Currently supports:
- **KDE Plasma** (native support via `qdbus`)

For other desktop environments, you can modify the `set_wallpaper_kde()` function to use appropriate wallpaper-setting commands:
- **GNOME**: `gsettings set org.gnome.desktop.background picture-uri`
- **XFCE**: `xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s`
- **i3/sway**: Use `feh` or `swaybg`

## Troubleshooting

**No wallpaper updates?**
- Ensure a music player is running and playing
- Check `playerctl status` outputs "Playing"
- Verify KDE Plasma is running

**"No music playing" message?**
- Start playing music in a supported player
- Run `playerctl metadata` to verify detection

**Font errors?**
- The script falls back to DejaVu Sans Bold if no custom fonts found
- Add `.ttf` files to the `fonts/` directory for variety

**Permission errors?**
- Ensure the script has write permissions in its directory
- Check that `wallpapers/` directory can be created

## File Structure
```
.
├── spotify_wallpaper.py    # Main script
├── fonts/                  # Optional: Custom .ttf fonts
├── wallpapers/             # Generated wallpapers (auto-created)
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## License

MIT License - Feel free to modify and distribute!

## Credits

Created with ❤️ for music lovers who want their desktop to match their vibes.