import 'package:flutter/material.dart';

/// Model untuk data sensor harian di dalam 1 paket laporan mingguan (7 hari)
class DailySensorReport {
  final String dayName; // 'Senin', 'Selasa', dst.
  final String dateStr; // '21 Sep'
  final double temp; // Suhu Air (°C)
  final double ph; // Nilai pH
  final int tds; // Nilai TDS (ppm)
  final int waterLevel; // Level Air (%)
  final String condition; // 'Optimal', 'Stabil', 'Perlu Nutrisi', dll.
  final Color statusColor;
  final String note;
  final bool isLive;

  const DailySensorReport({
    required this.dayName,
    required this.dateStr,
    required this.temp,
    required this.ph,
    required this.tds,
    required this.waterLevel,
    required this.condition,
    required this.statusColor,
    required this.note,
    this.isLive = false,
  });

  DailySensorReport copyWith({
    String? dayName,
    String? dateStr,
    double? temp,
    double? ph,
    int? tds,
    int? waterLevel,
    String? condition,
    Color? statusColor,
    String? note,
    bool? isLive,
  }) {
    return DailySensorReport(
      dayName: dayName ?? this.dayName,
      dateStr: dateStr ?? this.dateStr,
      temp: temp ?? this.temp,
      ph: ph ?? this.ph,
      tds: tds ?? this.tds,
      waterLevel: waterLevel ?? this.waterLevel,
      condition: condition ?? this.condition,
      statusColor: statusColor ?? this.statusColor,
      note: note ?? this.note,
      isLive: isLive ?? this.isLive,
    );
  }
}

/// Model untuk laporan mingguan yang mencakup 7 hari sensor sekaligus
class WeeklySensorReport {
  final String id;
  final String weekLabel;
  final String dateRange;
  final String statusBadge;
  final Color badgeColor;
  final bool isCurrentWeek;
  final List<DailySensorReport> dailyReports; // Tepat 7 hari

  const WeeklySensorReport({
    required this.id,
    required this.weekLabel,
    required this.dateRange,
    required this.statusBadge,
    required this.badgeColor,
    required this.isCurrentWeek,
    required this.dailyReports,
  });

  double get avgTemp {
    if (dailyReports.isEmpty) return 0.0;
    final total = dailyReports.map((d) => d.temp).reduce((a, b) => a + b);
    return total / dailyReports.length;
  }

  double get avgPh {
    if (dailyReports.isEmpty) return 0.0;
    final total = dailyReports.map((d) => d.ph).reduce((a, b) => a + b);
    return total / dailyReports.length;
  }

  int get avgTds {
    if (dailyReports.isEmpty) return 0;
    final total = dailyReports.map((d) => d.tds).reduce((a, b) => a + b);
    return (total / dailyReports.length).round();
  }

  int get avgWaterLevel {
    if (dailyReports.isEmpty) return 0;
    final total = dailyReports.map((d) => d.waterLevel).reduce((a, b) => a + b);
    return (total / dailyReports.length).round();
  }

  double get minTemp {
    if (dailyReports.isEmpty) return 0.0;
    return dailyReports.map((d) => d.temp).reduce((a, b) => a < b ? a : b);
  }

  double get maxTemp {
    if (dailyReports.isEmpty) return 0.0;
    return dailyReports.map((d) => d.temp).reduce((a, b) => a > b ? a : b);
  }

  double get minPh {
    if (dailyReports.isEmpty) return 0.0;
    return dailyReports.map((d) => d.ph).reduce((a, b) => a < b ? a : b);
  }

  double get maxPh {
    if (dailyReports.isEmpty) return 0.0;
    return dailyReports.map((d) => d.ph).reduce((a, b) => a > b ? a : b);
  }

  int get minTds {
    if (dailyReports.isEmpty) return 0;
    return dailyReports.map((d) => d.tds).reduce((a, b) => a < b ? a : b);
  }

  int get maxTds {
    if (dailyReports.isEmpty) return 0;
    return dailyReports.map((d) => d.tds).reduce((a, b) => a > b ? a : b);
  }
}
