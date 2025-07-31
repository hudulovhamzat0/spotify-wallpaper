<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <title>Spotify Wallpaper for KDE Plasma</title>
  <style>
    body { font-family: sans-serif; line-height: 1.6; margin: 2rem; max-width: 900px; background: #fff; color: #222; }
    h1, h2, h3 { color: #333; }
    code { background: #f4f4f4; padding: 0.2em 0.4em; border-radius: 4px; }
    pre { background: #f4f4f4; padding: 1em; border-radius: 4px; overflow-x: auto; }
    table { border-collapse: collapse; width: 100%; margin: 1em 0; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    blockquote { color: #666; border-left: 4px solid #ccc; padding-left: 1em; margin-left: 0; }
  </style>
</head>
<body>

<h1>🎵 Spotify Wallpaper for KDE Plasma</h1>

<p><strong>Spotify Wallpaper</strong>, dinlemekte olduğunuz Spotify şarkısının albüm kapağını ve şarkı bilgisini KDE masaüstü arka planınız olarak otomatik şekilde ayarlayan bir Bash betiğidir.</p>

<img src="https://via.placeholder.com/1000x562.png?text=Preview+Placeholder" alt="Önizleme">

<blockquote>
  KDE kullanıyorsanız ve müziği sadece duymak değil, aynı zamanda yaşamak istiyorsanız, bu araç tam size göre.
</blockquote>

<h2>✨ Özellikler</h2>
<ul>
  <li>🎨 Spotify albüm kapağını indirir ve masaüstü arka planı yapar.</li>
  <li>🖋️ Albüm kapağının üzerine sanatçı ve şarkı adını otomatik olarak yazar.</li>
  <li>🔁 Yeni şarkıya geçildiğinde arka planı anında günceller.</li>
  <li>🧼 Eski arka plan dosyalarını otomatik siler.</li>
  <li>🐧 KDE Plasma ile tam uyumludur (qdbus üzerinden).</li>
</ul>

<h2>🖥️ Ekran Görüntüsü</h2>
<img src="https://via.placeholder.com/1000x562.png?text=Wallpaper+Example" alt="Wallpaper Örneği">

<h2>⚙️ Gereksinimler</h2>

<table>
  <thead>
    <tr><th>Paket</th><th>Görev</th></tr>
  </thead>
  <tbody>
    <tr><td><code>playerctl</code></td><td>Spotify'dan metadata almak</td></tr>
    <tr><td><code>wget</code></td><td>Kapak resmini indirmek</td></tr>
    <tr><td><code>imagemagick</code></td><td>Görsel düzenleme</td></tr>
    <tr><td><code>qdbus</code></td><td>KDE arka planı değiştirme</td></tr>
  </tbody>
</table>

<h2>🚀 Kurulum</h2>

<pre><code>git clone https://github.com/kullaniciadi/spotify-wallpaper.git
cd spotify-wallpaper
bash install.sh
</code></pre>

<p>Kurulum sonunda script <code>~/.local/bin/spotify-wallpaper.sh</code> altına kopyalanır.</p>

<h2>▶️ Kullanım</h2>

<p>Script’i başlatmak için terminalde:</p>

<pre><code>bash ~/.local/bin/spotify-wallpaper.sh</code></pre>

<p>Arka planda çalışır ve her 5 saniyede bir Spotify’da yeni bir şarkı çalıp çalmadığını kontrol eder.</p>

<blockquote>
  Uygulamayı başlangıçta otomatik çalıştırmak için KDE "Başlangıç Uygulamaları"na ekleyebilirsiniz.
</blockquote>

<h2>🛠️ Özelleştirme</h2>

<h3>🎚 Yazı Fontu</h3>
<p>Varsayılan font: <code>DejaVuSans-Bold</code>. Alternatif olarak <code>OpenSans-Bold</code> mevcutsa otomatik kullanılır.</p>

<h3>🖋️ Yazı Boyutu ve Stil</h3>
<p>Metin 40 punto büyüklüğünde, ortalanmış ve 40 karakterde satıra kırılmış biçimdedir.</p>

<pre><code>TEXT="$ARTIST - $TITLE"
FORMATTED_TEXT=$(echo "$TEXT" | fold -s -w 40)</code></pre>

<p>İsterseniz bu kısmı düzenleyerek daha farklı bir biçim elde edebilirsiniz.</p>

<h2>🐞 Hata Ayıklama</h2>

<p>Tüm loglar şuraya kaydedilir:</p>

<pre><code>/tmp/spotify_wallpaper_debug.log</code></pre>

<p>Bir hata yaşarsanız bu dosyayı kontrol ederek sebebini anlayabilirsiniz.</p>

<h2>💡 Gelecek Planlar</h2>
<ul>
  <li>[ ] Şarkı sözlerini eklemek (örneğin Genius API ile)</li>
  <li>[ ] Çözünürlük desteğini dinamik yapmak</li>
  <li>[ ] Plasma 6 uyumluluğunu test etmek</li>
  <li>[ ] Albüm rengine göre arka plan gradient'i</li>
</ul>

<h2>🤝 Katkıda Bulun</h2>

<p>Katkılarınızı memnuniyetle kabul ediyoruz! Forklayın, geliştirin, pull request gönderin.</p>
<p>Ayrıca <a href="https://github.com/kullaniciadi/spotify-wallpaper/issues">Issue</a> açarak önerilerinizi paylaşabilirsiniz.</p>

<h2>📄 Lisans</h2>

<p>Bu proje <a href="https://opensource.org/licenses/MIT">MIT Lisansı</a> ile lisanslanmıştır.</p>
<p>Dilediğiniz gibi kullanabilir, dağıtabilir ve değiştirebilirsiniz.</p>

<h2>🙏 Teşekkürler</h2>
<blockquote>
  Bu proje KDE kullanıcılarının müzik deneyimini görsel olarak daha keyifli hale getirmek amacıyla hazırlandı.
  <br><br>
  “Müzik, ruhun gıdasıysa, neden masaüstü de onunla beslenmesin?” 🎧
</blockquote>

</body>
</html>
