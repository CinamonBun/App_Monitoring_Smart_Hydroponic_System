import 'package:flutter/material.dart';

/// Model untuk data satu slot/modul tanaman hidroponik
class PlantSlot {
  final String id;
  final String slotName;
  final String plantName;
  final int ageDays;
  final int harvestTargetDays;
  final String variety;
  final String notes;

  PlantSlot({
    required this.id,
    required this.slotName,
    required this.plantName,
    required this.ageDays,
    required this.harvestTargetDays,
    this.variety = '',
    this.notes = '',
  });

  PlantSlot copyWith({
    String? id,
    String? slotName,
    String? plantName,
    int? ageDays,
    int? harvestTargetDays,
    String? variety,
    String? notes,
  }) {
    return PlantSlot(
      id: id ?? this.id,
      slotName: slotName ?? this.slotName,
      plantName: plantName ?? this.plantName,
      ageDays: ageDays ?? this.ageDays,
      harvestTargetDays: harvestTargetDays ?? this.harvestTargetDays,
      variety: variety ?? this.variety,
      notes: notes ?? this.notes,
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
