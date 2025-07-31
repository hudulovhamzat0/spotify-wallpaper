<h1 style="color:#333;">🎵 Spotify Wallpaper for KDE Plasma</h1>

<p><strong>Spotify Wallpaper</strong> is a lightweight Bash script that dynamically sets your desktop wallpaper to the currently playing Spotify track’s album cover, with artist and song info — now featuring a beautiful gradient background that matches the album art.</p>

<blockquote style="color:#666; border-left:4px solid #ccc; padding-left:1em;">
If you love music and want your desktop to reflect your current vibe, this tool is for you.
</blockquote>

<h2 style="color:#333;">📦 Releases</h2>
<p>You can download the latest stable version from the <a href="https://github.com/hudulovhamzat0/spotify-wallpaper/releases" target="_blank">GitHub Releases page</a>.</p>
<p>Each release includes the latest version of:</p>
<ul>
  <li><code>spotify-wallpaper.sh</code> (the main script)</li>
  <li><code>install.sh</code> (the installer)</li>
  <li><code>README.md</code> and <code>README.html</code></li>
</ul>



<h2 style="color:#333;">✨ Features</h2>
<ul>
  <li>🎨 Extracts dominant colors from the album cover and creates a smooth gradient background</li>
  <li>📀 Overlays the Spotify album cover, centered and neatly resized</li>
  <li>🖋️ Displays the artist and song title under the cover with automatic text wrapping</li>
  <li>🔁 Updates your wallpaper automatically when the song changes</li>
  <li>🧼 Deletes old wallpaper images to keep your system clean</li>
  <li>🐧 Designed specifically for KDE Plasma using <code>qdbus</code></li>
</ul>

<h2 style="color:#333;">🖥️ Screenshot</h2>
<img src="https://github.com/hudulovhamzat0/spotify-wallpaper/blob/main/ss.png" alt="Wallpaper Example" style="width:100%; border:1px solid #ccc; border-radius:8px;">

<h2 style="color:#333;">⚙️ Requirements</h2>
<table style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr>
      <th style="border:1px solid #ddd; padding:8px;">Package</th>
      <th style="border:1px solid #ddd; padding:8px;">Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>playerctl</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Get metadata from Spotify</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>wget</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Download the album cover</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>imagemagick</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Generate gradient and compose final wallpaper</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>qdbus</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Change KDE wallpaper</td>
    </tr>
  </tbody>
</table>

<h2 style="color:#333;">🚀 Installation</h2>
<pre style="background:#f4f4f4; padding:1em; border-radius:4px;"><code>git clone https://github.com/hudulovhamzat0/spotify-wallpaper.git
cd spotify-wallpaper
bash install.sh
</code></pre>

<p>The script will be copied to <code>~/.local/bin/spotify-wallpaper.sh</code> for easy access.</p>

<h2 style="color:#333;">▶️ Usage</h2>
<p>To start the script, run:</p>
<pre style="background:#f4f4f4; padding:1em; border-radius:4px;"><code>bash ~/.local/bin/spotify-wallpaper.sh</code></pre>

<p>It checks every 5 seconds for a new song and updates your KDE wallpaper accordingly.</p>

<blockquote style="color:#666; border-left:4px solid #ccc; padding-left:1em;">
To launch it automatically on login, add it to KDE's Startup Applications.
</blockquote>


<h2 style="color:#333;">🛠️ Customization</h2>

<h3 style="color:#444;">🎚 Font</h3>
<p>The default font is <code>DejaVuSans-Bold</code>. If <code>OpenSans-Bold</code> is available, it will be used instead.</p>

<h3 style="color:#444;">🖋️ Text Wrapping</h3>
<p>Text is word-wrapped to 40 characters to ensure clean layout below the album art.</p>

<pre style="background:#f4f4f4; padding:1em; border-radius:4px;"><code>TEXT="$ARTIST - $TITLE"
FORMATTED_TEXT=$(echo "$TEXT" | fold -s -w 40)</code></pre>

<h3 style="color:#444;">🎨 Gradient Colors</h3>
<p>The gradient background is automatically generated using the top and bottom dominant pixels of the album cover image.</p>

<pre style="background:#f4f4f4; padding:1em; border-radius:4px;"><code>COLORS=($(convert cover.jpg -resize 1x2\! -format "%[pixel:u.p{0,0}] %[pixel:u.p{0,1}]" info:-))
convert -size 1920x1080 gradient:"${COLORS[0]}"-"${COLORS[1]}" bg.jpg</code></pre>

<h2 style="color:#333;">🐞 Debugging</h2>
<p>All logs are written to:</p>
<pre style="background:#f4f4f4; padding:1em; border-radius:4px;"><code>/tmp/spotify_wallpaper_debug.log</code></pre>

<h2 style="color:#333;">🗺️ Roadmap</h2>
<ul>
  <li>[x] Auto background gradient from album art 🎉</li>
  <li>[ ] Dynamic resolution detection</li>
  <li>[ ] KDE Plasma 6 compatibility testing</li>
</ul>

<h2 style="color:#333;">🤝 Contributing</h2>
<p>Feel free to fork, improve, and submit pull requests. Suggestions and bug reports are welcome on the <a href="https://github.com/hudulovhamzat0/spotify-wallpaper/issues">Issue Tracker</a>.</p>

<h2 style="color:#333;">📄 License</h2>
<p>This project is licensed under the <a href="https://opensource.org/licenses/MIT">MIT License</a>.</p>

<h2 style="color:#333;">🙏 Thanks</h2>
<blockquote style="color:#666; border-left:4px solid #ccc; padding-left:1em;">
Built to visually match your music and vibe in real time on your KDE desktop.<br><br>
“If music feeds the soul, let your desktop feed on it too.” 🎧
</blockquote>
