import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HydroponicLogEntry {
  final DateTime timestamp;
  final String title;
  final String description;
  final String category;
  final String badgeText;

  HydroponicLogEntry({
    required this.timestamp,
    required this.title,
    required this.description,
    required this.category,
    required this.badgeText,
  });
}

class HydroponicService extends ChangeNotifier {
  // Singleton pattern
  static final HydroponicService instance = HydroponicService._internal();
  HydroponicService._internal();

  // Variabel untuk menyimpan data dari API sesuai kode pengguna
  String waktuUpdate = "Belum ada data";
  String ph = "0.0";
  String tds = "0";
  String waterTemp = "0.0";
  String levelAir = "0";
  bool isLoading = false;
  String? errorMessage;
  bool isConnected = false;
  bool hasData = false;

  // URL API (default emulator Android, dapat diubah sesuai device/kebutuhan)
  // kalau run menggunakan hp
  // String apiUrl = "http://10.0.2.2:5000/api/hidroponik";

  // kalau run menggunakan web
  String apiUrl = "http://127.0.0.1:5000/api/hidroponik";

  // Nilai Min / Max terukur dari sensor
  double? minTemp;
  double? maxTemp;
  double? minPh;
  double? maxPh;

  // Log riwayat data nyata yang masuk
  final List<HydroponicLogEntry> realHistoryLogs = [];

  Timer? _timer;

  // Getter nilai numerik yang aman untuk widget & progress bar
  double get phValue => double.tryParse(ph) ?? 0.0;
  int get tdsValue => int.tryParse(tds) ?? 0;
  double get waterTempValue => double.tryParse(waterTemp) ?? 0.0;
  int get levelAirValue => int.tryParse(levelAir) ?? 0;

  // Memulai auto-refresh berkala (setiap 5 detik)
  void startAutoFetch({Duration duration = const Duration(seconds: 5)}) {
    _timer?.cancel();
    fetchSensorData();
    _timer = Timer.periodic(duration, (_) {
      fetchSensorData(silent: true);
    });
  }

  void stopAutoFetch() {
    _timer?.cancel();
    _timer = null;
  }

  void setApiUrl(String newUrl) {
    if (apiUrl != newUrl) {
      apiUrl = newUrl.trim();
      notifyListeners();
      fetchSensorData();
    }
  }

  // Fungsi untuk mengambil data dari Flask
  Future<void> fetchSensorData({bool silent = false}) async {
    if (!silent) {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    }

    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Memeriksa apakah data_sensor tidak null
        if (responseData['data_sensor'] != null) {
          final sensor = responseData['data_sensor'];

          waktuUpdate =
              responseData['waktu_update']?.toString() ??
              DateTime.now().toIso8601String();
          ph = sensor['ph_air']?.toString() ?? "0.0";
          tds = sensor['tds']?.toString() ?? "0";
          waterTemp = sensor['water_temp']?.toString() ?? "0.0";
          levelAir = sensor['level_air_persen']?.toString() ?? "0";

          final double? tVal = double.tryParse(waterTemp);
          if (tVal != null) {
            minTemp = (minTemp == null || tVal < minTemp!) ? tVal : minTemp;
            maxTemp = (maxTemp == null || tVal > maxTemp!) ? tVal : maxTemp;
          }

          final double? pVal = double.tryParse(ph);
          if (pVal != null) {
            minPh = (minPh == null || pVal < minPh!) ? pVal : minPh;
            maxPh = (maxPh == null || pVal > maxPh!) ? pVal : maxPh;
          }

          hasData = true;
          isConnected = true;
          errorMessage = null;

          // Catat ke daftar riwayat real data
          _recordHistoryLog();
        } else {
          errorMessage = "Format data_sensor tidak ditemukan dalam respons";
        }
      } else {
        errorMessage =
            "Gagal mengambil data. Status Code: ${response.statusCode}";
        isConnected = false;
        if (kDebugMode) {
          print("Gagal mengambil data. Status Code: ${response.statusCode}");
        }
      }
    } catch (e) {
      errorMessage = "Koneksi gagal: $e";
      isConnected = false;
      if (kDebugMode) {
        print("Terjadi kesalahan: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _recordHistoryLog() {
    // Tambahkan catatan sensor ke log riwayat
    final newEntry = HydroponicLogEntry(
      timestamp: DateTime.now(),
      title: 'Sinkronisasi Sensor Realtime',
      category: 'Sensor',
      description:
          'Suhu: $waterTemp°C | pH: $ph | TDS: $tds ppm | Level Air: $levelAir%',
      badgeText: isConnected ? 'Online' : 'Offline',
    );

    // Batasi maksimum 50 item riwayat
    realHistoryLogs.insert(0, newEntry);
    if (realHistoryLogs.length > 50) {
      realHistoryLogs.removeLast();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
