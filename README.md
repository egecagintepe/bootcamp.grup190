Takım İsmi
-
Laters

Ürün İle İlgili Bilgiler
-
Takım Elemanları
-
1. Serhat Yazıcı - Scrum Master
2. Ege Çağın Tepe - Product Owner
3. Furkan Akalp - Devoloper
4. Sena
5. Selahattin

Ürün İsmi
-
🧠 Medakai — Akıllı İlaç Rehberi ve Asistanı

Takım Logosu
-
![ChatGPT Image 5 Tem 2025 21_44_12](https://github.com/user-attachments/assets/bd2d9ca2-40e8-495b-90f8-ffcf327524e3)

🩺 Ürün Açıklaması
-
Medakai, ilaç kullanımı sırasında hastaların karşılaştığı kafa karışıklıklarını ve bilgi eksikliğini yapay zeka ile gideren bir sağlık teknolojisi çözümüdür. Kullanıcılara ilaçlarla ilgili yan etkiler, kullanım dozajları, kontrendikasyonlar ve etkileşimler hakkında özet bilgiler sunarken, ilaç saatlerini hatırlatma ve olası yan etkilerde önlem alma konusunda aktif destek sağlar.

İlaç prospektüslerinin genellikle okunmaması veya anlaşılamaması, yanlış doz kullanımı ve yan etki yönetiminde yetersizlik gibi ciddi sonuçlara yol açabilir. Medakai, kullanıcı dostu arayüzü ve yapay zeka destekli bilgi sistemi sayesinde bu sorunlara etkili çözümler sunar. Aynı zamanda kullanıcıların sağlıkla ilgili farkındalığını artırmayı hedefler.

________________________________________
📖 Uygulama Hikayesi
-
Yapılan saha araştırmalarında, hastaların ilaç kullanımı sırasında prospektüsleri çoğunlukla okumadığı, saatinde ilaç almayı unuttuğu ve yan etkilerle karşılaştığında nasıl tepki vereceğini bilemediği tespit edilmiştir.
Özellikle yaşlı bireyler, kronik hastalık takibi yapanlar ve çoklu ilaç kullananlar için bu durum hayati önem taşımaktadır.

Bu ihtiyaçtan yola çıkarak geliştirilen Medakai, sadece bir “ilaç bilgi kütüphanesi” değil, aynı zamanda kişisel bir ilaç asistanıdır. Kendi ilaç programını yöneten bireylerin, yapay zekaya soru sorarak yan etkiler konusunda bilgi alması, ilaç saatlerini takip etmesi ve dijital prospektüs özetlerine ulaşması amaçlanmıştır.

________________________________________
🔧 Ürün Özellikleri (MVP)
-
•	🔍 İlaç Bilgisi Sorgulama: Kullanıcı, ilaç ismini yazarak kullanım amacı, dozaj, yan etkiler ve etkileşimler hakkında özet bilgi alır.

•	🧠 Yan Etki Danışmanı (AI destekli): “Bu ilacı içtim, başım ağrıyor. Normal mi?” gibi sorulara LLM (Gemini) destekli cevap sistemiyle yanıt verir.

•	⏰ İlaç Hatırlatıcı: Günlük ilaç saatlerini belirleme ve uygulama üzerinden bildirim alma.

•	📄 Prospektüs Özeti: İlaçların uzun prospektüs metinlerini kısa ve sade paragraflar halinde sunar.

•	🛡️ Riskli Etkileşim Uyarıları (Geliştirilecek): Aynı anda kullanılan ilaçların etkileşim potansiyelini kullanıcıya sunar.

________________________________________
🎯 Hedef Kitle
-
•	Kronik hastalığı olan bireyler (ör. diyabet, hipertansiyon hastaları)

•	Yaşlı bireyler ve bakıma muhtaç hastalar

•	Çoklu ilaç kullanan kullanıcılar

•	Ebeveynler (çocuklarının ilaç takibini yapmak isteyenler)

•	Sağlık okuryazarlığı düşük olan bireyler

🧰 Kullanılan Teknolojiler (Sprint 1 Planı)
-
•	Frontend: Streamlit (hızlı prototipleme için)

•	AI Platformu: Gemini Pro API (LLM ile doğal dil yanıtları)

•	Veri Tabanı (ilerleyen sprintlerde): SQLite veya Firebase

•	Bildirim Sistemi: Local Time Alerts (Streamlit içinde)

•	Versiyonlama: GitHub + README + Sprint dökümanları

________________________________________

🪜 Sprint 1 Hedefleri
-

•	Proje vizyonunun netleştirilmesi

•	Kullanıcı senaryolarının yazılması

•	Prototip arayüz taslağı (Streamlit veya Figma)

•	Prompt sisteminin ve örnek veri girişlerinin hazırlanması

•	Ürün isim ve logo çalışmasının tamamlanması

•	GitHub repo oluşturulması ve temel klasör yapısı kurulumu

•	MVP kapsamının belirlenmesi ve backlog dosyasının oluşturulması

________________________________________

💡 Geliştirme Sonrası Planlar
-
•	Genişletilmiş ilaç veritabanı entegrasyonu (Türk İlaç ve Tıbbi Cihaz Kurumu verileriyle)

•	Mobil uygulama dönüşümü (.apk)

•	Sesli asistan entegrasyonu (Google STT)

•	Yan etki istatistikleri ve kullanıcı topluluğu oluşturma

•	Acil durum butonu ile sağlık danışmanına yönlendirme sistemi

________________________________________

📝 Jüriye Not

Bu ürün, yalnızca bir teknik uygulama değil, aynı zamanda kamu sağlığına katkı sağlayacak sosyal etkisi yüksek bir dijital çözümdür. Sprint 1 sonunda teknik prototipimiz kısıtlı fonksiyonlarla sunulsa da, Medakai’nin büyüme ve ölçeklenme potansiyeli yüksektir. Son sprintlerde canlı demo, LLM cevap motoru ve test veri entegrasyonları tamamlanacaktır.

📝 Sprint 1
-

Medakai projesi, ilaç kullanıcılarına yönelik yapay zeka destekli kişisel bir sağlık asistanı olarak planlandı. Bu sprintin temel amacı, ürünün vizyonunu netleştirmek, teknik çerçevesini çizmek ve sprint sürecini başlatacak planlamaları tamamlamaktı.

Sprint 1 kapsamında aşağıdaki adımlar gerçekleştirilmiştir:

1. Proje adı ve vizyonu netleştirildi.

2. Takım içi görev dağılımı yapıldı ve roller belirlendi.

3. Ürün fikrinin hedef kitlesi ve kullanım senaryoları belirlendi.

4. Minimum Viable Product (MVP) kapsamı çıkarıldı.

5. Proje dosya yapısı oluşturuldu, GitHub reposu açıldı.

7. Ürün logosu tasarlandı ve uygulamaya entegre edilmesi planlandı.

🎨 UI / UX Tasarımları
-
Bu sprintin bir diğer hedefi, ürünün temel arayüzünü oluşturmaktı. Kullanıcının ilaç adı girmesi ve sistemin ilgili bilgiyi ya da yan etki yorumunu göstermesi üzerine bir ekran akışı planlandı.

Sprint 1’de, koddan bağımsız şekilde hızlı prototipleme imkânı veren bir low-code tasarım aracı kullanılarak aşağıdaki ekranlar üretildi:

Hoş Geldin Ekranı

![Adsız tasarım](https://github.com/user-attachments/assets/528af4f7-63a7-4f2b-b125-a1a936c0e219)

Profil Kısmı

![Profile Screen](https://github.com/user-attachments/assets/608fbe04-1b25-4ef5-afa6-cc42c380b774)

Hızlı Erişim Ekranı

![Home Screen](https://github.com/user-attachments/assets/190ba0cb-3509-45b3-b5c7-ef74cce7d71f)

Olası Bir Sağlık Güncellemesi Kayıt Etme Ekranı

![Form](https://github.com/user-attachments/assets/7b763073-43cd-4fd6-a534-e2650d635379)

Arama Ekranı

![Search Results](https://github.com/user-attachments/assets/84864032-9a7b-4e3f-8f85-b32662d30674)

Seçilen İlaçla İlgili Detaylar Kısmı

![Medicine Details](https://github.com/user-attachments/assets/2973d51e-40bb-4184-a849-7bf09a7d8977)

Yapay Zeka İle Sohbet Kısmı 

![HealthBuddy Home](https://github.com/user-attachments/assets/3726e85b-a07e-4f7f-b82e-432d6652e6ed)

Yapay Zeka İle Sohbet

![HealthBuddy Chat](https://github.com/user-attachments/assets/d083dae3-2ed3-4888-b007-4daacab33e80)

Sık Kullanılan İlaçlarla İlgili Hatırlatıcı Kurma Ekranı

![Reminders](https://github.com/user-attachments/assets/f76f24ce-b2a7-41d2-9b1a-d34f1a88a9c7)

🛠️ Teknik Altyapı Planlaması
-
Geliştirme ortamı olarak PyCharm + Streamlit tercih edildi.

Kullanıcı arayüzü için Streamlit’in mobil uyumlu yapısından faydalanılacak.

Backend ihtiyaçları ilerleyen sprintlerde Gemini API ile desteklenecek.

Sonraki sprinte kadar gereken Python kütüphaneleri listelenecek ve requirements.txt dosyasına yazılacak.

🧠 AI Planlaması
-
LLM destekli “yan etki danışmanı” modülünün prompt yapısı belirlendi.

Örnek kullanıcı girişi ve model yanıtı aşağıda gösterilmiştir:

Kullanıcı: “Augmentin aldım ama midem bulandı, ne yapmalıyım?”
AI Prompt: “Kullanıcının ilaç ve semptom bilgisi üzerinden medikal uyarı ver. Gerekiyorsa doktora başvurmasını öner.”
Cevap: “Mide bulantısı Augmentin'in bilinen yan etkilerindendir. Eğer belirtiler şiddetlenirse doktorunuza başvurunuz.”

🧾 Sprint Review
-
Sprint 1 süresince takımda katılım eksikliği yaşanmıştır. Bu nedenle görevlerin büyük bölümü Product Owner ve Scrum Master tarafından yapılmıştır. Buna rağmen, ürün fikrinin netleştirilmesi, görsel tasarım, teknik planlama ve dokümantasyon başarıyla tamamlanmıştır.

🔁 Sprint Retrospective
-
Teknik altyapı Sprint 2’ye hazır hale getirildi.

Katılım göstermeyen üyelerin yeniden görevlendirilmesi ve bildirilmesi planlanıyor.

Sprintte ilk çalışan demo hedefleniyor (Streamlit tabanlı, temel AI cevabı).

Eğer katkı alınamazsa, dış mentorlardan destek istenerek proje sürdürülecek.

📌 Not
Bu sprint kod yazımı açısından sınırlı geçmiş olsa da, planlama ve strateji açısından güçlü temeller atılmıştır. Takım dinamiğinin güçlendirilmesi ile sonraki sprintlerde fonksiyonel çıktılar elde edilmesi hedeflenmektedir.

