# İzmirim Kart NFC Test Modülü

Bu proje, Flutter kullanılarak geliştirilmiş bir NFC (Near Field Communication) donanım test uygulamasıdır. Özellikle "İzmirim Kart" gibi MIFARE DESFire mimarisine sahip yüksek güvenlikli ulaşım kartlarının donanımsal kimliklerini (UID) ve iletişim protokollerini okumak amacıyla tasarlanmıştır.

## 🚀 Özellikler

*   **Gerçek Zamanlı Dinleme:** Cihazın NFC donanımını kullanarak sürekli okuma modunda bekler.
*   **UID Ayıklama:** Kartların 4 veya 7 byte uzunluğundaki fabrikasyon kimliğini yakalayarak standart Hexadecimal (`04:5E:31:D2...`) formatına dönüştürür.
*   **Protokol Analizi:** Kartın desteklediği teknoloji katmanlarını (NfcA, IsoDep, MifareClassic vb.) ve `atqa`, `sak`, `maxTransceiveLength` gibi düşük seviyeli donanım metadatalarını ekrana basar.
*   **İşletim Sistemi Çatışması Önleme:** Android işletim sisteminin (veya Google Wallet gibi uygulamaların) NFC verisini yutmasını engelleyen özel `Intent Filter` yapılandırması içerir.

## ⚠️ Sınırlamalar (Güvenlik Uyarısı)

Bu uygulama kartın yalnızca herkese açık donanımsal metadatasını (Public Data) okuyabilir. İzmirim Kart'ın içerisindeki:
*   Mevcut TL Bakiyesi
*   Son biniş yapılan istasyon/araç
*   Kart sahibi bilgileri (Öğrenci, Tam vb.)
**OKUNAMAZ.** Bu veriler 128-bit AES şifreleme anahtarları (Key) ile kilitli olan özel sektörlerde tutulmaktadır.

## 🛠️ Kurulum ve Gereksinimler

**Önemli Not:** `nfc_manager` paketinin Pigeon altyapısına geçişi sırasındaki veri dönüştürme (TagPigeon) hatalarından kaçınmak için paket sürümü **3.3.0** olarak sabitlenmiştir.

1.  Repoyu bilgisayarınıza klonlayın.
2.  `pubspec.yaml` dosyasında paketin şu şekilde sabitlendiğinden emin olun:
    ```yaml
    dependencies:
      nfc_manager: 3.3.0 
    ```
3.  Terminal üzerinden gerekli paketleri çekin:
    ```bash
    flutter pub get
    ```
4.  Uygulamayı derleyin:
    ```bash
    flutter run
    ```
*(Not: NFC donanımı emülatörlerde çalışmaz. Uygulamayı fiziksel bir Android cihaza yüklemeniz gerekmektedir.)*

## 📱 Android Manifest Yapılandırması

Uygulamanın çalışabilmesi için `android/app/src/main/AndroidManifest.xml` dosyasında donanım izinleri ve intent filtreleri ayarlanmıştır.
