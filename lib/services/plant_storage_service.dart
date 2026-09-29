import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant_slot_model.dart';

/// Layanan untuk menyimpan dan memuat data modul tanaman hidroponik ke penyimpanan lokal (SharedPreferences).
/// Dengan sistem ini, tanggal tanam (plantingDate) tersimpan permanen dan umur tanaman
/// akan bertambah secara otomatis setiap hari mengikuti tanggal kalender perangkat.
class PlantStorageService {
  static const String _kPlantSlotsKey = 'smart_hydroponic_plant_slots';

  /// Memuat daftar slot tanaman dari SharedPreferences.
  /// Jika belum ada data tersimpan, buat data default dan simpan otomatis.
  static Future<List<PlantSlot>> loadPlantSlots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_kPlantSlotsKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        return decoded
            .map((item) => PlantSlot.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback ke default jika terjadi error saat parse
    }

    // Default 4 modul utama jika pertama kali buka aplikasi
    final defaultSlots = getDefaultSlots();
    await savePlantSlots(defaultSlots);
    return defaultSlots;
  }

  /// Menyimpan seluruh slot tanaman ke SharedPreferences.
  static Future<void> savePlantSlots(List<PlantSlot> slots) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(slots.map((s) => s.toJson()).toList());
      await prefs.setString(_kPlantSlotsKey, jsonString);
    } catch (_) {
      // Ignore write errors
    }
  }

  /// Data default awal 4 modul hidroponik
  static List<PlantSlot> getDefaultSlots() {
    final now = DateTime.now();

    return [
      PlantSlot(
        id: 'slot_1',
        slotName: 'Modul 1 • Talang A',
        plantName: 'Selada Butterhead',
        plantingDate: now.subtract(const Duration(days: 30)),
        harvestTargetDays: 42,
        variety: 'Grand Rapids',
        notes: 'Pertumbuhan daun sangat rimbun, nutrisi 620 ppm stabil.',
      ),
      PlantSlot(
        id: 'slot_2',
        slotName: 'Modul 2 • Talang B',
        plantName: 'Pakcoy Hijau',
        plantingDate: now.subtract(const Duration(days: 24)),
        harvestTargetDays: 35,
        variety: 'Nauli F1',
        notes: 'Batang mulai menebal dan warna daun hijau segar merata.',
      ),
      PlantSlot(
        id: 'slot_3',
        slotName: 'Modul 3 • Talang C',
        plantName: 'Kangkung Hidroponik',
        plantingDate: now.subtract(const Duration(days: 18)),
        harvestTargetDays: 25,
        variety: 'Bangkok LP-1',
        notes: 'Laju penyerapan air tinggi, sirkulasi aerasi optimal.',
      ),
      PlantSlot(
        id: 'slot_4',
        slotName: 'Modul 4 • Talang D',
        plantName: 'Bayam Merah',
        plantingDate: now.subtract(const Duration(days: 14)),
        harvestTargetDays: 28,
        variety: 'Mira Red',
        notes: 'Fase vegetatif awal, paparan sinar matahari greenhouse cukup.',
      ),
    ];
  }
}
