<h1 align="center" style="font-size: 2.5em;">🎵 Spotify Wallpaper for KDE Plasma + Photo</h1>

<p align="center"><strong>Spotify Wallpaper</strong> is a powerful and beautiful script that transforms your KDE Plasma desktop by blending music and aesthetics. It fetches the current Spotify song, extracts colors from its album cover, adds a vibrant gradient background — and overlays an Photo  based on the detected vibe. 💿🎨👧</p>

<blockquote style="color:#666; border-left:4px solid #ccc; padding-left:1em;">
If music feeds your soul, let your desktop feed on it too.
</blockquote>

---

<h2 style="font-size: 2em;">📸 What It Looks Like</h2>

<p align="center">
  <img src="https://github.com/hudulovhamzat0/spotify-wallpaper/blob/main/ss.png" alt="Wallpaper Example" style="width:100%; border:1px solid #ccc; border-radius:8px;">
</p>

---

<h2 style="font-size: 2em;">👧 Character Matching</h2>

<p>This script selects one of your provided Photo images based on the song's color palette. Each color triggers a different themed character:</p>


---

<h2 style="font-size: 2em;">✨ Features</h2>

<ul>
  <li>🎨 Extracts dominant and center colors from Spotify album covers</li>
  <li>🌈 Creates a smooth gradient background based on those colors</li>
  <li>📀 Centers the album art</li>
  <li>🖋️ Adds the track name & artist with smart line wrapping</li>
  <li>👧 Selects an Photo that matches the song’s mood</li>
  <li>🔁 Automatically updates on song change</li>
  <li>🧼 Cleans up old images to save space</li>
  <li>🐧 Built for KDE Plasma using <code>qdbus</code></li>
</ul>

---

<h2 style="font-size: 2em;">⚙️ Requirements</h2>

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
      <td style="border:1px solid #ddd; padding:8px;">Fetch current Spotify metadata</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>wget</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Download album cover</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>imagemagick</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Create final wallpaper image</td>
    </tr>
    <tr>
      <td style="border:1px solid #ddd; padding:8px;"><code>qdbus</code></td>
      <td style="border:1px solid #ddd; padding:8px;">Change KDE Plasma wallpaper</td>
    </tr>
  </tbody>
</table>

---

<h2 style="font-size: 2em;">🚀 Installation</h2>

<pre><code>git clone https://github.com/hudulovhamzat0/spotify-wallpaper.git
cd spotify-wallpaper
bash install.sh
</code></pre>

<p>Installer places the script in <code>~/.local/bin/spotify-wallpaper.sh</code> for easy use.</p>

---

<h2 style="font-size: 2em;">▶️ Usage</h2>

Run with your own character folder:

<pre><code>bash spotify-wallpaper.sh -p /path/to/your/photos</code></pre>

Or run a custom script instead:

<pre><code>bash spotify-wallpaper.sh -x script/my_script.sh</code></pre>

To stop the loop, use <code>Ctrl + C</code> or the included GUI.

---

<h2 style="font-size: 2em;">🖥️ Optional GUI</h2>

<p>Launch with:</p>

<pre><code>python3 gui.py</code></pre>

- Toggle "Include Photos"
- Select folder only if needed
- Start/Stop the main script easily

---

<h2 style="font-size: 2em;">🐞 Debugging</h2>

Logs are written to:

<pre><code>/tmp/spotify_wallpaper_debug.log</code></pre>

---

<h2 style="font-size: 2em;">📦 Releases</h2>

Download the latest version from  
👉 <a href="https://github.com/hudulovhamzat0/spotify-wallpaper/releases" target="_blank">GitHub Releases</a>

Includes:
- `spotify-wallpaper.sh`
- `install.sh`
- `README.md` and `README.html`

---

<h2 style="font-size: 2em;">📄 License</h2>

This project is licensed under the MIT License.  
Feel free to fork, modify, and contribute!

---

<h2 style="font-size: 2em;">🙏 Credits</h2>

Thanks to everyone who loves clean desktops and good music.  
Special thanks to the KDE and open source community. 💙

<blockquote style="color:#666; border-left:4px solid #ccc; padding-left:1em;">
“Your music. Your desktop. In sync.” 🎧
</blockquote>
