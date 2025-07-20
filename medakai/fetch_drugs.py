import requests
import json
import os
from dotenv import load_dotenv
import time

# Çevre değişkenlerini yükle
load_dotenv()
API_KEY = os.getenv("OPENFDA_API_KEY")

if not API_KEY:
    print("Hata: OPENFDA_API_KEY çevresel değişkeni bulunamadı. Lütfen .env dosyasına ekleyin.")
    exit(1)


def get_all_drugs(api_key):
    """
    OpenFDA API'den ilaç adlarını çeker.

    Args:
        api_key: OpenFDA API anahtarı

    Returns:
        İlaç adlarının alfabetik sırayla listesi
    """
    base_url = "https://api.fda.gov/drug/label.json"
    drugs = []
    skip = 0
    limit = 100
    while True:
        params = {"api_key": api_key, "limit": limit, "skip": skip}
        try:
            response = requests.get(base_url, params=params)
            if response.status_code != 200:
                print(f"Hata: {response.status_code} - {response.text}")
                break
            data = response.json()
            results = data.get("results", [])
            if not results:
                print("API'den daha fazla veri alınamadı.")
                break
            for drug in results:
                brand_name = drug.get("openfda", {}).get("brand_name", [""])[0]
                generic_name = drug.get("openfda", {}).get("generic_name", [""])[0]
                if brand_name and brand_name.strip():
                    drugs.append(brand_name.lower())
                if generic_name and generic_name.strip() and generic_name != brand_name:
                    drugs.append(generic_name.lower())
            skip += limit
            print(f"{skip} ilaç işlendi...")
            time.sleep(0.25)  # Kota sınırı için bekleme
        except requests.exceptions.RequestException as e:
            print(f"API hatası: {str(e)}")
            break
    if not drugs:
        print("Uyarı: OpenFDA'dan hiç ilaç çekilemedi. API anahtarını veya bağlantıyı kontrol edin.")
    return sorted(list(set(drugs)))


def load_local_drugs():
    """
    Yerel drug_data.json'dan ilaç adlarını çeker.

    Returns:
        Yerel ilaç adlarının listesi
    """
    try:
        with open("data/drug_data.json", "r", encoding="utf-8") as file:
            drug_data = json.load(file)
        local_drugs = [drug.lower() for drug in drug_data.keys() if drug.strip()]
        print(f"Yerel drug_data.json'dan {len(local_drugs)} ilaç yüklendi.")
        return local_drugs
    except FileNotFoundError:
        print("Yerel drug_data.json bulunamadı.")
        return []


def save_drug_list(drugs, local_drugs, filename="available_drugs.txt"):
    """
    İlaç adlarını dosyaya satır satır kaydeder.

    Args:
        drugs: OpenFDA'dan çekilen ilaçlar
        local_drugs: Yerel ilaçlar
        filename: Kaydedilecek dosya adı
    """
    combined_drugs = sorted(list(set(drugs + local_drugs)))
    if not combined_drugs:
        print("Uyarı: Kaydedilecek ilaç listesi boş.")
        combined_drugs = []
    try:
        with open(filename, "w", encoding="utf-8") as f:
            for drug in combined_drugs:
                f.write(f"{drug}\n")
        print(f"İlaç listesi {filename} dosyasına kaydedildi. Toplam {len(combined_drugs)} ilaç.")
    except Exception as e:
        print(f"Dosyaya yazma hatası: {str(e)}")


if __name__ == "__main__":
    # OpenFDA'dan ilaçları çek
    openfda_drugs = get_all_drugs(API_KEY)
    # Yerel ilaçları yükle
    local_drugs = load_local_drugs()
    # Listeyi kaydet
    save_drug_list(openfda_drugs, local_drugs)