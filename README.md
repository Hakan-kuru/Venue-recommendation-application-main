# 📍 Mekan Öneri Uygulaması

Bu mobil uygulama, kullanıcıların çevrelerindeki en iyi mekanları kolayca keşfetmesini sağlayan bir öneri ve keşif platformudur. Kullanıcı dostu arayüzü ve akıllı filtreleme sistemi sayesinde, ihtiyacınıza en uygun yeri bulmak artık çok kolay!

---

## 🎯 Amaç

Uygulamanın temel amacı; kullanıcıların **bulunduğu konuma, tercihlerine veya ihtiyaçlarına göre** mekan araması yapabilmesini sağlamak ve bu aramaya uygun mekanları önererek zaman kazandırmaktır.

---

## 🧠 Uygulama Mantığı

- Kullanıcı uygulamaya Google hesabı ile giriş yapar.
- Ana ekranda arama yaparak belirli bir kategori, isim veya bölgeye göre mekanları filtreleyebilir.
- Elde edilen sonuçlar sade ve kullanıcı odaklı bir liste halinde sunulur.
- Kullanıcı dilerse bu mekanları **favorilerine** ekleyebilir.
- Daha sonra favori mekanlarına kolayca erişebilir ve düzenleyebilir.
- Uygulama içerisinde kullanıcıya yardımcı olacak animasyonlar ve etkileşimli geri bildirimler bulunur.

---

## 👤 Kimler İçin?

- Yeni bir şehirde nereye gideceğini bilemeyen gezginler
- Kahve dükkanı, restoran, müze gibi öneriler arayan kullanıcılar
- Sık sık dışarıda vakit geçiren sosyal kullanıcılar
- Beğendiği mekanları düzenli takip etmek isteyen kişiler

---

## 🧭 Kullanım Senaryosu (Örnek)

> Ali, yeni taşındığı şehirde kahve içilecek güzel bir yer arıyor.  
> Uygulamaya Google hesabı ile giriş yapıyor ve "kahve" kelimesiyle arama yapıyor.  
> Uygulama ona konumuna göre önerilen en iyi kahvecileri listeliyor.  
> Ali, beğendiği birkaç tanesini favorilerine ekliyor.  
> Ertesi gün favori listesine gidip o kahvecilerden birine gitmeye karar veriyor.

---

## 🧪 Kullanılan Teknolojiler ve Deneyim

| Teknoloji / Kütüphane      | Açıklama & Deneyim Durumu                              |
|----------------------------|---------------------------------------------------------|
| **Flutter**                | Uygulama tamamen Flutter ile geliştirildi. Responsive yapı kuruldu. |
| **Dart**                   | Tüm iş mantığı Dart ile yazıldı. Null safety ve async yapılar aktif kullanıldı. |
| **MongoDB**                | `mongo_dart` paketi ile NoSQL veritabanı bağlantısı kuruldu. Temel CRUD işlemleri başarıyla gerçekleştirildi. |
| **Google Sign-In**         | Google hesabıyla oturum açma başarılı şekilde entegre edildi. |
| **Rive Animations**        | Giriş ekranı ve etkileşimli UI alanlarında kullanıldı. Deneyim kazanıldı. |
| **fluttertoast**           | Kullanıcıya hızlı geri bildirim sağlamak için kullanıldı. |
| **mailer**                 | Geri bildirim e-postası göndermek için entegre edildi. |
| **google_fonts**           | Özel font yönetimi sağlandı (Inter ve Poppins). |
| **flutter_svg**            | Yüksek kaliteli vektörel ikonlar için kullanıldı. |
| **url_launcher**           | Harici bağlantı açma ihtiyacında kullanıldı. |

---

## 💼 Geliştirici Deneyimi

Bu proje kapsamında:

- **Flutter ile uçtan uca uygulama geliştirme** pratiği yapıldı.
- **MongoDB bağlantısı ve veri modeli kurma** deneyimi kazanıldı.
- **Google ile kimlik doğrulama (Auth)** entegre edildi.
- Responsive arayüz, animasyon, mail gönderimi gibi tamamlayıcı özellikler başarıyla eklendi.
- Arayüz sadeliği, kullanıcı dostu navigasyon ve hata yönetimi uygulandı.

Bu proje hem teknik bilgiyi pekiştirmek hem de portföye değerli bir örnek kazandırmak amacıyla geliştirilmiştir.

---
## 🚀 Hedef

Mekan Öneri Uygulaması, sadece bir yer arama aracı değil, **kişisel bir keşif asistanı** olmayı hedefliyor. Kullanıcının zamanını verimli kullanmasını sağlar, aradığı deneyimi hızla ve doğru şekilde sunar.

---

## 📌 Not

Bu dokümantasyon, uygulamanın çalışma mantığını özetler. Teknik kurulum ve geliştirme detayları için `README.dev.md` dosyasına göz atabilirsiniz.

