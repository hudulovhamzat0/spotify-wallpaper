<h1>🎵 Spotify Wallpaper for KDE Plasma</h1>

<p><strong>Spotify Wallpaper</strong>, dinlemekte olduğunuz Spotify şarkısının albüm kapağını ve şarkı bilgisini KDE masaüstü arka planınız olarak otomatik şekilde ayarlayan bir Bash betiğidir.</p>

<img src="https://github.com/hudulovhamzat0/spotify-wallpaper/blob/main/wall.png" alt="Önizleme">

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
<img src="https://github.com/hudulovhamzat0/spotify-wallpaper/blob/main/wall.png" alt="Wallpaper Örneği">

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
  <li>[ ] Çözünürlük desteğini dinamik yapmak</li>
  <li>[ ] Albüm rengine göre arka plan gradient'i</li>
</ul>

<h2>🤝 Katkıda Bulun</h2>

<p>Katkılarınızı memnuniyetle kabul ediyoruz! Forklayın, geliştirin, pull request gönderin.</p>
<p>Ayrıca <a href="https://github.com/hudulovhamzat0/spotify-wallpaper/issues">Issue</a> açarak önerilerinizi paylaşabilirsiniz.</p>

<h2>📄 Lisans</h2>

<p>Bu proje <a href="https://opensource.org/licenses/MIT">MIT Lisansı</a> ile lisanslanmıştır.</p>
<p>Dilediğiniz gibi kullanabilir, dağıtabilir ve değiştirebilirsiniz.</p>

<h2>🙏 Teşekkürler</h2>
<blockquote>
  Bu proje KDE kullanıcılarının müzik deneyimini görsel olarak daha keyifli hale getirmek amacıyla hazırlandı.
  <br><br>
</blockquote>

</body>
</html>
