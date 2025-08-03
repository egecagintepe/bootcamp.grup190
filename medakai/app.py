import streamlit as st
import json
import requests
from datetime import datetime, time, timedelta
from dotenv import load_dotenv
import os
from googletrans import Translator
import re
from twilio.rest import Client
from twilio.base.exceptions import TwilioRestException

# Streamlit sayfa yapılandırması (ilk Streamlit komutu)
st.set_page_config(page_title="Medakai", page_icon="💊")

# Çevre değişkenlerini yükle
load_dotenv()
API_KEY = os.getenv("OPENFDA_API_KEY")
TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_PHONE_NUMBER = os.getenv("TWILIO_PHONE_NUMBER")

if not API_KEY:
    st.error("OPENFDA_API_KEY çevresel değişkeni bulunamadı. Lütfen .env dosyasına ekleyin.")
if not all([TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER]):
    st.warning(
        "Twilio kimlik bilgileri eksik. SMS bildirimleri çalışmayacak. Lütfen .env dosyasına TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN ve TWILIO_PHONE_NUMBER ekleyin.")


# Çeviri fonksiyonu
def translate_to_turkish(text):
    """
    Metni İngilizce'den Türkçeye çevirir.

    Args:
        text: Çevrilecek metin (str, bytes, bytearray veya None)

    Returns:
        Çevrilmiş metin veya hata durumunda varsayılan mesaj
    """
    if text is None or not isinstance(text, (str, bytes, bytearray)):
        return "Bilgi mevcut değil"
    try:
        translator = Translator()
        translated = translator.translate(text, dest="tr").text
        return translated
    except Exception as e:
        st.warning(f"Çeviri hatası: {str(e)}. Orijinal metin gösteriliyor.")
        return text if isinstance(text, str) else "Bilgi mevcut değil"


# Dozaj bilgisinden sıklık çıkarma
def extract_frequency(dosage_text):
    """
    Dozaj metninden hatırlatma sıklığını çıkarır.

    Args:
        dosage_text: Dozaj bilgisi (str)

    Returns:
        Sıklık (str) veya None
    """
    dosage_text = dosage_text.lower()
    if "günde 3 kez" in dosage_text or "her 8 saatte" in dosage_text:
        return "Her 8 saatte bir"
    elif "günde 2 kez" in dosage_text or "her 12 saatte" in dosage_text:
        return "Her 12 saatte bir"
    elif "günde 1 kez" in dosage_text or "günlük" in dosage_text:
        return "Günlük"
    elif "her 4-6 saatte" in dosage_text or re.search(r"every 4-6 hour", dosage_text):
        return "Her 6 saatte bir"
    return "Tek seferlik"


# Telefon numarası doğrulama
def validate_phone_number(phone_number):
    """
    Telefon numarasının geçerli olup olmadığını kontrol eder.

    Args:
        phone_number: Telefon numarası (str)

    Returns:
        Geçerliyse True, değilse False
    """
    pattern = r"^\+\d{10,12}$"
    return bool(re.match(pattern, phone_number))


# SMS gönderme fonksiyonu
def send_sms(drug_name, reminder_time, phone_number):
    """
    Hatırlatma için SMS gönderir.

    Args:
        drug_name: İlaç adı
        reminder_time: Hatırlatma saati (str)
        phone_number: Hedef telefon numarası
    """
    if not all([TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER, phone_number]):
        st.error("SMS gönderimi için Twilio kimlik bilgileri veya telefon numarası eksik.")
        return
    if not validate_phone_number(phone_number):
        st.error("Geçersiz telefon numarası. Lütfen uluslararası formatta girin (örneğin, +905551234567).")
        return
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        message = client.messages.create(
            body=f"🔔 {drug_name.capitalize()} ilacınızı alma zamanı! Saat: {reminder_time}",
            from_=TWILIO_PHONE_NUMBER,
            to=phone_number
        )
        st.success(f"SMS gönderildi: {drug_name.capitalize()} için {reminder_time} ({phone_number})")
    except TwilioRestException as e:
        st.error(f"SMS gönderim hatası: {str(e)}")


# JSON veri yükle (ilaç bilgileri)
try:
    with open("data/drug_data.json", "r", encoding="utf-8") as file:
        drug_data = json.load(file)
except FileNotFoundError:
    drug_data = {}
    st.error("Yerel veri dosyası (drug_data.json) bulunamadı.")


# Hatırlatıcıları yükle
def load_reminders():
    try:
        with open("data/reminders.json", "r", encoding="utf-8") as file:
            return json.load(file)
    except FileNotFoundError:
        return []


# Hatırlatıcıları kaydet
def save_reminders(reminders):
    try:
        with open("data/reminders.json", "w", encoding="utf-8") as file:
            json.dump(reminders, file, ensure_ascii=False, indent=4)
    except Exception as e:
        st.error(f"Hatırlatıcıları kaydederken hata: {str(e)}")


# OpenFDA API'den veri çekme fonksiyonu
def get_drug_info_from_openfda(drug_name: str, api_key: str) -> dict:
    """
    OpenFDA API'den ilaç bilgisi çeker.

    Args:
        drug_name: Aranacak ilaç adı
        api_key: OpenFDA API anahtarı (zorunlu)

    Returns:
        API'den dönen ilaç bilgileri veya None
    """
    base_url = "https://api.fda.gov/drug/label.json"
    params = {
        "search": f'openfda.brand_name:"{drug_name}" OR openfda.generic_name:"{drug_name}"',
        "limit": 1,
        "api_key": api_key
    }
    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        data = response.json()
        return data.get("results", [])
    except requests.exceptions.HTTPError as e:
        st.error(f"HTTP Hatası: {str(e)} - URL: {response.url}")
        if response.text:
            st.error(f"Sunucu Yanıtı: {response.text}")
        return None
    except requests.exceptions.RequestException as e:
        st.error(f"OpenFDA API hatası: {str(e)} - URL: {response.url}")
        return None


# Uygulama başlığı
st.title("💊 Medakai – Kişisel İlaç Asistanı")

# Telefon numarası girişi
st.header("📱 SMS Bildirim Ayarları")
if 'phone_number' not in st.session_state:
    st.session_state.phone_number = ""
phone_number = st.text_input("SMS bildirimleri için telefon numaranızı girin (örn: +905551234567)",
                             value=st.session_state.phone_number)
if phone_number:
    if validate_phone_number(phone_number):
        st.session_state.phone_number = phone_number
        st.success(f"Telefon numarası kaydedildi: {phone_number}")
    else:
        st.error("Geçersiz telefon numarası. Lütfen uluslararası formatta girin (örneğin, +905551234567).")

# Sorgulanabilir ilaçlar listesi
st.header("📋 Sorgulanabilir İlaçlar")
if drug_data:
    st.write("Yerel veritabanında bulunan ilaçlar:")
    st.write(", ".join([drug.capitalize() for drug in drug_data.keys()]))
else:
    st.warning("Yerel veritabanında ilaç bulunamadı.")

# Tüm ilaç listesini indirme butonu
st.subheader("Tüm İlaç Listesini İndir")
try:
    with open("available_drugs.txt", "r", encoding="utf-8") as f:
        drug_list = f.read()
    st.download_button(
        label="Tüm İlaç Listesini TXT Olarak İndir",
        data=drug_list,
        file_name="available_drugs.txt",
        mime="text/plain"
    )
except FileNotFoundError:
    st.warning("İlaç listesi dosyası (available_drugs.txt) bulunamadı. Lütfen önce fetch_drugs.py betiğini çalıştırın.")

# İlaç seçimi
st.header("🔍 İlaç Bilgisi Sorgulama")
drug_name = st.text_input("İlaç adı giriniz (örn: parol, augmentin)").lower()

if drug_name:
    # Yerel JSON dosyasını kontrol et
    if drug_name in drug_data:
        info = drug_data[drug_name]
        st.success(f"{drug_name.capitalize()} için özet bilgi (Yerel Veritabanı):")
        st.write("**Kullanım:**", info["kullanim"])
        st.write("**Dozaj:**", info["dozaj"])
        st.write("**Yan Etkiler:**", info["yan_etikiler"])
        st.write("**Etkileşim Uyarısı:**", ", ".join(info["etkilesimler"]))
    else:
        # OpenFDA'dan veri çek
        if API_KEY:
            results = get_drug_info_from_openfda(drug_name, API_KEY)
            if results:
                drug_info = results[0]
                st.success(f"{drug_name.capitalize()} için özet bilgi (OpenFDA):")
                st.write("**Kullanım:**",
                         translate_to_turkish(drug_info.get("indications_and_usage", ["Bilgi mevcut değil"])[0]))
                st.write("**Dozaj:**",
                         translate_to_turkish(drug_info.get("dosage_and_administration", ["Bilgi mevcut değil"])[0]))
                st.write("**Yan Etkiler:**",
                         translate_to_turkish(drug_info.get("adverse_reactions", ["Bilgi mevcut değil"])[0]))
                st.write("**Etkileşim Uyarısı:**",
                         translate_to_turkish(drug_info.get("drug_interactions", ["Bilgi mevcut değil"])[0]))
            else:
                st.warning("İlaç veritabanında veya OpenFDA'da bulunamadı.")
        else:
            st.error("API anahtarı eksik. Lütfen .env dosyasına OPENFDA_API_KEY ekleyin.")

# AI danışmanı
st.header("🧠 Yan Etki Danışmanı (Simülasyon)")
question = st.text_input("Yan etkiler hakkında soru yazın:")
if question:
    st.info("AI Cevabı (Simülasyon):")
    st.write("Bu belirti sık görülmeyebilir. Şiddetliyse doktorunuza danışınız.")

# Hatırlatıcı
st.header("⏰ İlaç Hatırlatıcı")
if 'reminders' not in st.session_state:
    st.session_state.reminders = load_reminders()

# Yeni hatırlatıcı ekleme
st.subheader("Yeni Hatırlatıcı Ekle")
reminder_drug = st.text_input("Hatırlatıcı için ilaç adı girin:")
reminder_time = st.time_input("Hatırlatma saatini seçin", value=time(9, 0))

# Dozaj bilgisinden sıklık öner
suggested_frequency = "Tek seferlik"
if reminder_drug:
    if reminder_drug in drug_data:
        suggested_frequency = extract_frequency(drug_data[reminder_drug]["dozaj"])
    else:
        if API_KEY:
            results = get_drug_info_from_openfda(reminder_drug, API_KEY)
            if results:
                dosage_text = translate_to_turkish(results[0].get("dosage_and_administration", [""])[0])
                suggested_frequency = extract_frequency(dosage_text)

reminder_frequency = st.selectbox("Hatırlatma sıklığı",
                                  ["Tek seferlik", "Her 6 saatte bir", "Her 8 saatte bir", "Her 12 saatte bir",
                                   "Günlük"],
                                  index=["Tek seferlik", "Her 6 saatte bir", "Her 8 saatte bir", "Her 12 saatte bir",
                                         "Günlük"].index(suggested_frequency))

if st.button("Hatırlatıcı Ekle"):
    if reminder_drug and reminder_time:
        if not st.session_state.phone_number:
            st.error("Lütfen önce telefon numaranızı girin.")
        elif not validate_phone_number(st.session_state.phone_number):
            st.error("Geçersiz telefon numarası. Lütfen uluslararası formatta girin (örneğin, +905551234567).")
        else:
            new_reminder = {
                "drug": reminder_drug.lower(),
                "time": reminder_time.strftime("%H:%M"),
                "frequency": reminder_frequency
            }
            st.session_state.reminders.append(new_reminder)
            save_reminders(st.session_state.reminders)
            st.success(
                f"{reminder_drug.capitalize()} için hatırlatıcı eklendi: {reminder_time.strftime('%H:%M')} ({reminder_frequency})")

# Mevcut hatırlatıcıları göster
st.subheader("Mevcut Hatırlatıcılar")
if st.session_state.reminders:
    for i, reminder in enumerate(st.session_state.reminders):
        st.write(f"{reminder['drug'].capitalize()}: {reminder['time']} ({reminder['frequency']})")
        if st.button(f"Sil: {reminder['drug'].capitalize()}", key=f"delete_{i}"):
            st.session_state.reminders.pop(i)
            save_reminders(st.session_state.reminders)
            st.experimental_rerun()
else:
    st.write("Henüz hatırlatıcı eklenmedi.")

# Hatırlatma kontrolü ve SMS gönderimi
now = datetime.now()
for reminder in st.session_state.reminders:
    reminder_time = datetime.strptime(reminder["time"], "%H:%M").time()
    reminder_datetime = datetime.combine(now.date(), reminder_time)
    time_diff = abs((now - reminder_datetime).total_seconds() / 60)
    if time_diff <= 1:
        st.success(f"🔔 {reminder['drug'].capitalize()} ilacınızı alma zamanı! ({reminder['time']})")
        if st.session_state.phone_number:
            send_sms(reminder["drug"], reminder["time"], st.session_state.phone_number)
    # Tekrarlayan hatırlatmalar
    if reminder["frequency"] == "Her 6 saatte bir":
        for offset in [6, 12, 18]:
            offset_time = (reminder_datetime + timedelta(hours=offset)).time()
            offset_datetime = datetime.combine(now.date(), offset_time)
            time_diff = abs((now - offset_datetime).total_seconds() / 60)
            if time_diff <= 1:
                st.success(
                    f"🔔 {reminder['drug'].capitalize()} ilacınızı alma zamanı! ({offset_time.strftime('%H:%M')})")
                if st.session_state.phone_number:
                    send_sms(reminder["drug"], offset_time.strftime("%H:%M"), st.session_state.phone_number)
    elif reminder["frequency"] == "Her 8 saatte bir":
        for offset in [8, 16]:
            offset_time = (reminder_datetime + timedelta(hours=offset)).time()
            offset_datetime = datetime.combine(now.date(), offset_time)
            time_diff = abs((now - offset_datetime).total_seconds() / 60)
            if time_diff <= 1:
                st.success(
                    f"🔔 {reminder['drug'].capitalize()} ilacınızı alma zamanı! ({offset_time.strftime('%H:%M')})")
                if st.session_state.phone_number:
                    send_sms(reminder["drug"], offset_time.strftime("%H:%M"), st.session_state.phone_number)
    elif reminder["frequency"] == "Her 12 saatte bir":
        offset_time = (reminder_datetime + timedelta(hours=12)).time()
        offset_datetime = datetime.combine(now.date(), offset_time)
        time_diff = abs((now - offset_datetime).total_seconds() / 60)
        if time_diff <= 1:
            st.success(f"🔔 {reminder['drug'].capitalize()} ilacınızı alma zamanı! ({offset_time.strftime('%H:%M')})")
            if st.session_state.phone_number:
                send_sms(reminder["drug"], offset_time.strftime("%H:%M"), st.session_state.phone_number)

# Prospektüs özeti
st.header("📄 Prospektüs Özeti")
if drug_name:
    if drug_name in drug_data:
        st.write(f"📘 **{drug_name.capitalize()} Prospektüs Özeti (Yerel Veritabanı):**")
        st.markdown("""
        - Kullanıcılar tarafından en çok sorulan sorulara göre sadeleştirilmiştir.
        - Bu ilaç genellikle güvenlidir, ancak doktor onayı dışında doz artırımı yapılmamalıdır.
        """)
    else:
        if API_KEY:
            results = get_drug_info_from_openfda(drug_name, API_KEY)
            if results:
                drug_info = results[0]
                st.write(f"📘 **{drug_name.capitalize()} Prospektüs Özeti (OpenFDA):**")
                st.markdown(f"""
                - **Özet:** {translate_to_turkish(drug_info.get("description", ["Bilgi mevcut değil"])[0])}
                - **Uyarılar:** {translate_to_turkish(drug_info.get("warnings", ["Bilgi mevcut değil"])[0])}
                """)
            else:
                st.warning("Prospektüs özeti bulunamadı.")
        else:
            st.error("API anahtarı eksik. Lütfen .env dosyasına OPENFDA_API_KEY ekleyin.")

# Etkileşim kontrolü
st.header("🛡️ Etkileşim Kontrolü")
user_drugs = st.text_input("Kullandığınız diğer ilaçları virgülle yazın (örn: parol, alkol)")
if user_drugs:
    input_list = [d.strip().lower() for d in user_drugs.split(",")]
    conflicts = set()

    # Yerel JSON'dan kontrol
    if drug_name in drug_data:
        conflicts = set(input_list).intersection(set(drug_data[drug_name]["etkilesimler"]))

    # OpenFDA'dan etkileşim kontrolü
    if not conflicts and drug_name and API_KEY:
        results = get_drug_info_from_openfda(drug_name, API_KEY)
        if results:
            drug_interactions = translate_to_turkish(results[0].get("drug_interactions", [""])[0]).lower()
            for input_drug in input_list:
                if input_drug in drug_interactions:
                    conflicts.add(input_drug)

    if conflicts:
        st.error(f"⚠️ Bu ilaç şunlarla etkileşebilir: {', '.join(conflicts)}")
    else:
        st.success("✅ Bilinen bir etkileşim bulunamadı.")