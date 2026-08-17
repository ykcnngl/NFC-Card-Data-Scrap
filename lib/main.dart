import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İzmirim Kart Okuyucu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RealCardReaderScreen(),
    );
  }
}

class RealCardReaderScreen extends StatefulWidget {
  const RealCardReaderScreen({super.key});

  @override
  State<RealCardReaderScreen> createState() => _RealCardReaderScreenState();
}

class _RealCardReaderScreenState extends State<RealCardReaderScreen> {
  String _cardDataString = "NFC Dinleniyor...\nLütfen kartı telefonun arkasına yaklaştırın.";
  String _cardUid = "Bekleniyor...";

  @override
  void initState() {
    super.initState();
    _startNfcScan();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  void _startNfcScan() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        setState(() {
          _cardDataString = "HATA: Cihazınızda NFC donanımı bulunamadı veya kapalı.";
        });
        return;
      }

      NfcManager.instance.startSession(
        pollingOptions: NfcPollingOption.values.toSet(),
        onDiscovered: (NfcTag tag) async {
          try {
            Map<String, dynamic> tagData = Map<String, dynamic>.from(tag.data as Map);
            String extractedUid = "UID Bulunamadı";

            if (tagData.containsKey('nfca')) {
              List<int> uidBytes = List<int>.from(tagData['nfca']['identifier']);
              extractedUid = uidBytes.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(':');
            } else if (tagData.containsKey('isodep') && tagData['isodep'].containsKey('identifier')) {
              List<int> uidBytes = List<int>.from(tagData['isodep']['identifier']);
              extractedUid = uidBytes.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(':');
            } else if (tagData.containsKey('mifareclassic')) {
              List<int> uidBytes = List<int>.from(tagData['mifareclassic']['identifier']);
              extractedUid = uidBytes.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(':');
            }


            String formattedData = tagData.entries
                .map((entry) => "► ${entry.key.toUpperCase()}:\n${entry.value}")
                .join('\n\n');

            setState(() {
              _cardUid = extractedUid;
              _cardDataString = "KART BAŞARIYLA OKUNDU!\n\n------------------------\n\n$formattedData";
            });

          } catch (e) {
            setState(() {
              _cardDataString = "KART İŞLENİRKEN YAZILIMSAL HATA:\n$e";
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _cardDataString = "SİSTEM BAŞLATILAMADI:\n$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İzmirim Kart Test Modülü')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kart Seri Numarası (UID):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(_cardUid, style: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Sistem Logları:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300)
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _cardDataString,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}