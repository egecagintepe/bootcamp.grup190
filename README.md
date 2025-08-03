# Takım İsmi

Laters

## Ürün İle İlgili Bilgiler

### Takım Elemanları
1. Serhat Yazıcı - Scrum Master
2. Ege Çağın Tepe - Product Owner
3. Furkan Akalp - Developer

---

## Ürün İsmi
🧠 Medakai — Akıllı İlaç Rehberi ve Asistanı

### Takım Logosu
![ChatGPT Image 5 Tem 2025 21_44_12](https://github.com/user-attachments/assets/bd2d9ca2-40e8-495b-90f8-ffcf327524e3)

---

## 🩺 Ürün Açıklaması

Medakai, ilaç kullanımı sırasında hastaların karşılaştığı kafa karışıklıklarını ve bilgi eksikliğini yapay zeka ile gideren bir sağlık teknolojisi çözümüdür. Kullanıcılara ilaçlarla ilgili yan etkiler, kullanım dozajları, kontrendikasyonlar ve etkileşimler hakkında özet bilgiler sunarken, ilaç saatlerini hatırlatma ve olası yan etkilerde önlem alma konusunda aktif destek sağlar.

İlaç prospektüslerinin genellikle okunmaması veya anlaşılamaması, yanlış doz kullanımı ve yan etki yönetiminde yetersizlik gibi ciddi sonuçlara yol açabilir. Medakai, kullanıcı dostu arayüzü ve yapay zeka destekli bilgi sistemi sayesinde bu sorunlara etkili çözümler sunar. Aynı zamanda kullanıcıların sağlıkla ilgili farkındalığını artırmayı hedefler.

---

## 📖 Uygulama Hikayesi

Yapılan saha araştırmalarında, hastaların ilaç kullanımı sırasında prospektüsleri çoğunlukla okumadığı, saatinde ilaç almayı unuttuğu ve yan etkilerle karşılaştığında nasıl tepki vereceğini bilemediği tespit edilmiştir.
Özellikle yaşlı bireyler, kronik hastalık takibi yapanlar ve çoklu ilaç kullananlar için bu durum hayati önem taşımaktadır.

Bu ihtiyaçtan yola çıkarak geliştirilen Medakai, sadece bir “ilaç bilgi kütüphanesi” değil, aynı zamanda kişisel bir ilaç asistanıdır. Kendi ilaç programını yöneten bireylerin, yapay zekaya soru sorarak yan etkiler konusunda bilgi alması, ilaç saatlerini takip etmesi ve dijital prospektüs özetlerine ulaşması amaçlanmıştır.

---

## 🔧 Ürün Özellikleri (MVP)
- 🔍 İlaç Bilgisi Sorgulama: Kullanıcı, ilaç ismini yazarak kullanım amacı, dozaj, yan etkiler ve etkileşimler hakkında özet bilgi alır.
- 🧠 Yan Etki Danışmanı (AI destekli): “Bu ilacı içtim, başım ağrıyor. Normal mi?” gibi sorulara LLM (Gemini) destekli cevap sistemiyle yanıt verir.
- ⏰ İlaç Hatırlatıcı: Günlük ilaç saatlerini belirleme ve uygulama üzerinden bildirim alma.
- 📄 Prospektüs Özeti: İlaçların uzun prospektüs metinlerini kısa ve sade paragraflar halinde sunar.
- 🛡️ Riskli Etkileşim Uyarıları (Geliştirilecek): Aynı anda kullanılan ilaçların etkileşim potansiyelini kullanıcıya sunar.

---

## 🎯 Hedef Kitle
- Kronik hastalığı olan bireyler (ör. diyabet, hipertansiyon hastaları)
- Yaşlı bireyler ve bakıma muhtaç hastalar
- Çoklu ilaç kullanan kullanıcılar
- Ebeveynler (çocuklarının ilaç takibini yapmak isteyenler)
- Sağlık okuryazarlığı düşük olan bireyler

---

## 🧰 Kullanılan Teknolojiler (Sprint 1 Planı)
- Frontend: Streamlit (hızlı prototipleme için)
- AI Platformu: Gemini Pro API (LLM ile doğal dil yanıtları)
- Veri Tabanı (ilerleyen sprintlerde): SQLite veya Firebase
- Bildirim Sistemi: Local Time Alerts (Streamlit içinde)
- Versiyonlama: GitHub + README + Sprint dökümanları

---

## 🪜 Sprint 1 Hedefleri

• Proje vizyonunun netleştirilmesi  
• Kullanıcı senaryolarının yazılması  
• Prototip arayüz taslağı (Streamlit veya Figma)  
• Prompt sisteminin ve örnek veri girişlerinin hazırlanması  
• Ürün isim ve logo çalışmasının tamamlanması  
• GitHub repo oluşturulması ve temel klasör yapısı kurulumu  
• MVP kapsamının belirlenmesi ve backlog dosyasının oluşturulması  

---

Devamında uzun dökümanın tamamını aynı şekilde bırakabilirsin (yani baştan sona kendi yazdığın bölümler dursun, alttaki "A new Flutter project..." gibi kısım tamamen silinsin).

**Özetle:**  
- Sadece kendi detaylı dökümanını bırak, Flutter’ın otomatik açıklamasını sil.
- Kopyala-yapıştır yaptıktan sonra **kaydet**, sonra terminalde şunu yaz:

```bash
git add README.md
git rebase --continue