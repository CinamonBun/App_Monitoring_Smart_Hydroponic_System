import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Snapshot data sensor pada satu titik waktu (real data dari API)
class SensorSnapshot {
  final DateTime timestamp;
  final double temp;
  final double ph;
  final int tds;
  final int waterLevel;

  const SensorSnapshot({
    required this.timestamp,
    required this.temp,
    required this.ph,
    required this.tds,
    required this.waterLevel,
  });

  /// Status kondisi berdasarkan nilai sensor
  String get condition {
    if (ph < 5.5 || ph > 7.0 || temp > 30 || temp < 18) return 'Waspada';
    if (waterLevel <= 25) return 'Kritis';
    return 'Optimal';
  }

  Color get statusColor {
    switch (condition) {
      case 'Kritis':
        return const Color(0xFFE53935);
      case 'Waspada':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  /// Format waktu singkat (jam:menit)
  String get timeLabel {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  /// Format tanggal pendek (misal "22 Sep")
  String get dateLabel {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${timestamp.day} ${months[timestamp.month]}';
  }
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
  int? minTds;
  int? maxTds;

  /// Riwayat snapshot sensor real (terbaru di index 0), maks 200 entri
  final List<SensorSnapshot> sensorHistory = [];

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

          final int? tdsInt = int.tryParse(tds);
          if (tdsInt != null) {
            minTds = (minTds == null || tdsInt < minTds!) ? tdsInt : minTds;
            maxTds = (maxTds == null || tdsInt > maxTds!) ? tdsInt : maxTds;
          }

          hasData = true;
          isConnected = true;
          errorMessage = null;

          // Rekam snapshot sensor ke histori
          _recordSnapshot();
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

  void _recordSnapshot() {
    final tVal = double.tryParse(waterTemp) ?? 0.0;
    final pVal = double.tryParse(ph) ?? 0.0;
    final tdsVal = int.tryParse(tds) ?? 0;
    final levelVal = int.tryParse(levelAir) ?? 0;

    // Cegah duplikat: skip jika nilai identik dan baru direkam kurang dari 1 menit
    if (sensorHistory.isNotEmpty) {
      final last = sensorHistory.first;
      final isIdentical = last.temp == tVal &&
          last.ph == pVal &&
          last.tds == tdsVal &&
          last.waterLevel == levelVal;
      final isRecent =
          DateTime.now().difference(last.timestamp) < const Duration(minutes: 1);
      if (isIdentical && isRecent) {
        return;
      }
    }

    final snapshot = SensorSnapshot(
      timestamp: DateTime.now(),
      temp: tVal,
      ph: pVal,
      tds: tdsVal,
      waterLevel: levelVal,
    );

    sensorHistory.insert(0, snapshot);
    if (sensorHistory.length > 200) {
      sensorHistory.removeLast();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
