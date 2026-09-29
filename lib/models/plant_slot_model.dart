import 'package:flutter/material.dart';

/// Model untuk data satu slot/modul tanaman hidroponik.
/// Umur tanaman dihitung otomatis berdasarkan tanggal tanam (plantingDate).
class PlantSlot {
  final String id;
  final String slotName;
  final String plantName;
  final DateTime plantingDate;
  final int harvestTargetDays;
  final String variety;
  final String notes;

  PlantSlot({
    required this.id,
    required this.slotName,
    required this.plantName,
    DateTime? plantingDate,
    int? initialAgeDays,
    required this.harvestTargetDays,
    this.variety = '',
    this.notes = '',
  }) : plantingDate = plantingDate ??
            DateTime.now().subtract(Duration(days: initialAgeDays ?? 0));

  /// Menghitung umur tanaman dalam hari berdasarkan selisih tanggal kalender dengan hari ini.
  /// Otomatis bertambah 1 hari setiap kali jam berganti melewati pukul 00:00 (hari baru).
  int get ageDays {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final planted = DateTime(plantingDate.year, plantingDate.month, plantingDate.day);
    final diff = today.difference(planted).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Tanggal perkiraan panen berdasarkan tanggal tanam + target hari panen
  DateTime get estimatedHarvestDate {
    return plantingDate.add(Duration(days: harvestTargetDays));
  }

  /// Format tanggal tanam (misal: "28 Agu 2026")
  String get formattedPlantingDate {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${plantingDate.day} ${months[plantingDate.month]} ${plantingDate.year}';
  }

  /// Format tanggal panen (misal: "10 Okt 2026")
  String get formattedHarvestDate {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final hDate = estimatedHarvestDate;
    return '${hDate.day} ${months[hDate.month]} ${hDate.year}';
  }

  PlantSlot copyWith({
    String? id,
    String? slotName,
    String? plantName,
    DateTime? plantingDate,
    int? ageDays,
    int? harvestTargetDays,
    String? variety,
    String? notes,
  }) {
    DateTime? resolvedPlantingDate = plantingDate;
    // Jika ageDays diberikan langsung saat edit, hitung mundur tanggal tanamnya
    if (resolvedPlantingDate == null && ageDays != null) {
      final now = DateTime.now();
      resolvedPlantingDate = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: ageDays));
    }

    return PlantSlot(
      id: id ?? this.id,
      slotName: slotName ?? this.slotName,
      plantName: plantName ?? this.plantName,
      plantingDate: resolvedPlantingDate ?? this.plantingDate,
      harvestTargetDays: harvestTargetDays ?? this.harvestTargetDays,
      variety: variety ?? this.variety,
      notes: notes ?? this.notes,
    );
  }

  /// Serialisasi ke Map JSON untuk disimpan ke SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slotName': slotName,
      'plantName': plantName,
      'plantingDate': plantingDate.toIso8601String(),
      'harvestTargetDays': harvestTargetDays,
      'variety': variety,
      'notes': notes,
    };
  }

  /// Deserialisasi dari Map JSON
  factory PlantSlot.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['plantingDate'] != null) {
      parsedDate = DateTime.tryParse(json['plantingDate'] as String) ?? DateTime.now();
    } else if (json['ageDays'] != null) {
      final days = json['ageDays'] as int;
      final now = DateTime.now();
      parsedDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
    } else {
      parsedDate = DateTime.now();
    }

    return PlantSlot(
      id: json['id'] as String? ?? 'slot_${DateTime.now().millisecondsSinceEpoch}',
      slotName: json['slotName'] as String? ?? 'Modul',
      plantName: json['plantName'] as String? ?? 'Tanaman',
      plantingDate: parsedDate,
      harvestTargetDays: json['harvestTargetDays'] as int? ?? 30,
      variety: json['variety'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Rasio progres umur menuju waktu panen (0.0 - 1.0)
  double get progress {
    if (harvestTargetDays <= 0) return 0.0;
    return (ageDays / harvestTargetDays).clamp(0.0, 1.0);
  }

  /// Sisa hari menuju perkiraan panen
  int get daysLeft {
    final diff = harvestTargetDays - ageDays;
    return diff > 0 ? diff : 0;
  }

  /// Apakah tanaman sudah mencapai atau melebihi target panen
  bool get isReadyToHarvest => ageDays >= harvestTargetDays;

  /// Kategori tahapan pertumbuhan tanaman berdasarkan umur
  String get growthStage {
    final p = progress;
    if (ageDays >= harvestTargetDays) return 'Siap Panen 🎉';
    if (p >= 0.85) return 'Menjelang Panen';
    if (p >= 0.50) return 'Vegetatif Akhir';
    if (p >= 0.25) return 'Vegetatif Awal';
    return 'Fase Semai / Bibit';
  }

  /// Warna status tahapan
  Color get stageColor {
    if (isReadyToHarvest) return const Color(0xFF2E7D32);
    final p = progress;
    if (p >= 0.85) return const Color(0xFFD97706);
    if (p >= 0.50) return const Color(0xFF0288D1);
    if (p >= 0.25) return const Color(0xFF2E7D32);
    return const Color(0xFF7CB342);
  }
}

/// Preset jenis tanaman hidroponik populer
class PlantPreset {
  final String name;
  final int defaultHarvestDays;
  final String variety;
  final IconData icon;
  final Color themeColor;

  const PlantPreset({
    required this.name,
    required this.defaultHarvestDays,
    required this.variety,
    required this.icon,
    required this.themeColor,
  });
}
