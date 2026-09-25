import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/hydroponic_service.dart';
import '../widgets/dark_glass_card.dart';
import '../widgets/light_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.isStandalone = false});

  final bool isStandalone;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _showWaterLevelAlert = false;
  int _displayLimit = 15;

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Color(0xFFEF5350), size: 24),
            SizedBox(width: 8),
            Text(
              'Hapus Riwayat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin mengosongkan seluruh riwayat pembacaan sensor dari memori?',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              HydroponicService.instance.clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Riwayat pembacaan sensor berhasil dibersihkan'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Ambang batas dan peringatan water level (25%, 50%, 75%, 100%)
  final List<_WaterLevelThresholdInfo> _waterLevelAlerts = const [
    _WaterLevelThresholdInfo(
      thresholdPercent: 25,
      title: 'Peringatan Air Kritis (≤ 25%)',
      description:
          'Volume air bak hampir habis. Pompa berisiko rusak (dry-running) dan akar selada kekurangan nutrisi.',
      recommendation:
          'Segera isi tandon dengan air baku dan tambahkan larutan nutrisi AB Mix.',
      icon: Icons.warning_amber_rounded,
      primaryColor: Color(0xFFE53935),
    ),
    _WaterLevelThresholdInfo(
      thresholdPercent: 50,
      title: 'Peringatan Air Menipis (50%)',
      description:
          'Volume air tersisa separuh (50%). Penguapan siang hari mempercepat penurunan air.',
      recommendation:
          'Siapkan air cadangan dan pantau nilai PPM nutrisi agar tidak terlalu pekat.',
      icon: Icons.report_problem_rounded,
      primaryColor: Color(0xFFE65100),
    ),
    _WaterLevelThresholdInfo(
      thresholdPercent: 75,
      title: 'Status Air Optimal (75%)',
      description:
          'Ketinggian air ideal. Aliran nutrisi dan kadar oksigen terlarut sangat baik.',
      recommendation:
          'Kondisi optimal. Pertahankan sirkulasi rutin dan pemantauan berkala.',
      icon: Icons.water_drop_rounded,
      primaryColor: Color(0xFF0288D1),
    ),
    _WaterLevelThresholdInfo(
      thresholdPercent: 100,
      title: 'Status Air Penuh (100%)',
      description:
          'Bak penampungan terisi penuh (100%). Menambah air berisiko menyebabkan luapan.',
      recommendation:
          'Hentikan pengisian air segera dan pastikan pipa pembuangan (overflow) aman.',
      icon: Icons.check_circle_outline_rounded,
      primaryColor: Color(0xFF2E7D32),
    ),
  ];

  _WaterLevelThresholdInfo _getAlertForWaterLevel(int level) {
    if (level <= 25) return _waterLevelAlerts[0];
    if (level <= 50) return _waterLevelAlerts[1];
    if (level <= 75) return _waterLevelAlerts[2];
    return _waterLevelAlerts[3];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final service = HydroponicService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final history = service.sensorHistory;

        // Statistik rata-rata dari seluruh histori data sensor real
        final double avgTemp = history.isEmpty
            ? 0
            : history.map((e) => e.temp).reduce((a, b) => a + b) /
                history.length;
        final double avgPh = history.isEmpty
            ? 0
            : history.map((e) => e.ph).reduce((a, b) => a + b) /
                history.length;
        final double avgTds = history.isEmpty
            ? 0
            : history.map((e) => e.tds.toDouble()).reduce((a, b) => a + b) /
                history.length;
        final double avgWaterLevel = history.isEmpty
            ? 0
            : history
                    .map((e) => e.waterLevel.toDouble())
                    .reduce((a, b) => a + b) /
                history.length;

        final int activeWaterLevel =
            service.hasData ? service.levelAirValue : avgWaterLevel.round();

        final bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 64, 18, 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Rekap Sensor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          service.hasData
                              ? '${history.length} pembacaan sensor tercatat'
                              : 'Menunggu koneksi sensor...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // KARTU DATA SENSOR SEKARANG (REAL-TIME)
                  DarkGlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: service.isConnected
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  service.isConnected
                                      ? 'Sensor Aktif'
                                      : 'Sensor Offline',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              history.isNotEmpty
                                  ? history.first.timeLabel
                                  : (service.hasData
                                      ? service.waktuUpdate
                                      : '--:-- WIB'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Data Sensor Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nilai terbaru yang diterima dari sensor',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 16),
                        if (!service.hasData) ...[
                          _buildNoDataCard(),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildFriendlyStat(
                                  icon: Icons.thermostat_rounded,
                                  iconColor: kWarnAmber,
                                  title: 'Suhu Air',
                                  value:
                                      '${service.waterTempValue.toStringAsFixed(1)}°C',
                                  statusText: _tempStatus(
                                    service.waterTempValue,
                                  ),
                                  statusColor: _tempStatusColor(
                                    service.waterTempValue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildFriendlyStat(
                                  icon: Icons.science_rounded,
                                  iconColor: const Color(0xFF81C784),
                                  title: 'Kadar Asam (pH)',
                                  value: service.phValue.toStringAsFixed(1),
                                  statusText: _phStatus(service.phValue),
                                  statusColor: _phStatusColor(
                                    service.phValue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFriendlyStat(
                                  icon: Icons.grain_rounded,
                                  iconColor: const Color(0xFFCEEFFE),
                                  title: 'Nutrisi (TDS)',
                                  value: '${service.tdsValue} ppm',
                                  statusText: _tdsStatus(service.tdsValue),
                                  statusColor: _tdsStatusColor(
                                    service.tdsValue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildFriendlyStat(
                                  icon: Icons.water_drop_rounded,
                                  iconColor: kWaterAccent,
                                  title: 'Air di Bak',
                                  value: '${service.levelAirValue}%',
                                  statusText: _waterStatus(
                                    service.levelAirValue,
                                  ),
                                  statusColor: _waterStatusColor(
                                    service.levelAirValue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // KARTU RATA-RATA SESI INI (hanya tampil jika ada >= 2 data)
                  if (history.length >= 2) ...[
                    DarkGlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Rata-rata Sesi Ini',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${history.length} data tercatat',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dihitung otomatis dari seluruh pembacaan sensor real',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildAvgStat(
                                  icon: Icons.thermostat_rounded,
                                  iconColor: kWarnAmber,
                                  label: 'Suhu',
                                  value: '${avgTemp.toStringAsFixed(1)}°C',
                                ),
                              ),
                              Expanded(
                                child: _buildAvgStat(
                                  icon: Icons.science_rounded,
                                  iconColor: const Color(0xFF81C784),
                                  label: 'pH',
                                  value: avgPh.toStringAsFixed(1),
                                ),
                              ),
                              Expanded(
                                child: _buildAvgStat(
                                  icon: Icons.grain_rounded,
                                  iconColor: const Color(0xFFCEEFFE),
                                  label: 'TDS',
                                  value: '${avgTds.round()} ppm',
                                ),
                              ),
                              Expanded(
                                child: _buildAvgStat(
                                  icon: Icons.water_drop_rounded,
                                  iconColor: kWaterAccent,
                                  label: 'Air',
                                  value: '${avgWaterLevel.round()}%',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],

                  // DROPDOWN NOTIFIKASI WATER LEVEL
                  _buildWaterLevelDropdown(
                    activeWaterLevel: activeWaterLevel,
                  ),

                  const SizedBox(height: 22),

                  // RIWAYAT PEMBACAAN SENSOR REAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Riwayat Pembacaan Sensor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (history.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              '${history.length < _displayLimit ? history.length : _displayLimit} dari ${history.length} entri',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_sweep_outlined,
                                color: Colors.white70,
                                size: 20,
                              ),
                              tooltip: 'Bersihkan Riwayat',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _confirmClearHistory(context),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (history.isEmpty)
                    _buildEmptyHistory()
                  else ...[
                    for (final snap in history.take(_displayLimit))
                      _buildSnapshotCard(snap),
                    if (history.length > _displayLimit)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Center(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.expand_more_rounded, size: 18),
                            label: Text(
                              'Tampilkan Lebih Banyak (+15) • Sisa ${history.length - _displayLimit}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () {
                              setState(() {
                                _displayLimit += 15;
                              });
                            },
                          ),
                        ),
                      ),
                    if (_displayLimit > 15 && history.length > 15)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _displayLimit = 15;
                            });
                          },
                          child: Text(
                            'Ciutkan ke 15 data terbaru',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );

        if (widget.isStandalone) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.3, 1.0, 2.0],
                colors: [
                  Color(0xFF237497),
                  Color(0xFFCEEFFE),
                  Color(0xFFEDFAFF),
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  'Rekap Sensor',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: bodyContent,
            ),
          );
        }

        return bodyContent;
      },
    );
  }

  Widget _buildSnapshotCard(SensorSnapshot snap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LightCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      snap.timeLabel,
                      style: const TextStyle(
                        color: kDarkText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      snap.dateLabel,
                      style: TextStyle(
                        color: kMutedDark.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: snap.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    snap.condition,
                    style: TextStyle(
                      color: snap.statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDaySensorPill(
                  'Suhu',
                  '${snap.temp.toStringAsFixed(1)}°C',
                ),
                _buildDaySensorPill('pH', snap.ph.toStringAsFixed(1)),
                _buildDaySensorPill('TDS', '${snap.tds} ppm'),
                _buildDaySensorPill('Air', '${snap.waterLevel}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sensors_off_rounded,
              size: 36,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Sensor belum terhubung',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pastikan server backend / ESP32 aktif\ndan URL endpoint sesuai.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return LightCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 36,
              color: Color(0xFFB0C4D8),
            ),
            const SizedBox(height: 10),
            const Text(
              'Belum ada riwayat real',
              style: TextStyle(
                color: kDarkText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Riwayat pembacaan sensor akan\nmuncul otomatis setelah data sensor masuk.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMutedDark.withValues(alpha: 0.7),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySensorPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0EFF6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: kMutedDark.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: kDarkText,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendlyStat({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvgStat({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }

  String _tempStatus(double v) {
    if (v < 18) return 'Terlalu Dingin';
    if (v > 30) return 'Terlalu Panas';
    return 'Pas & Sejuk';
  }

  Color _tempStatusColor(double v) {
    if (v < 18 || v > 30) return const Color(0xFFE57373);
    return const Color(0xFFA5D6A7);
  }

  String _phStatus(double v) {
    if (v < 5.5) return 'Terlalu Asam';
    if (v > 7.0) return 'Terlalu Basa';
    return 'Ideal';
  }

  Color _phStatusColor(double v) {
    if (v < 5.5 || v > 7.0) return const Color(0xFFE57373);
    return const Color(0xFFA5D6A7);
  }

  String _tdsStatus(int v) {
    if (v < 500) return 'Nutrisi Kurang';
    if (v > 2000) return 'Terlalu Pekat';
    return 'Subur';
  }

  Color _tdsStatusColor(int v) {
    if (v < 500 || v > 2000) return const Color(0xFFE57373);
    return const Color(0xFFA5D6A7);
  }

  String _waterStatus(int v) {
    if (v <= 25) return 'Kritis!';
    if (v <= 50) return 'Menipis';
    if (v <= 75) return 'Cukup';
    return 'Penuh';
  }

  Color _waterStatusColor(int v) {
    if (v <= 25) return const Color(0xFFE53935);
    if (v <= 50) return const Color(0xFFD97706);
    return const Color(0xFFA5D6A7);
  }

  Widget _buildWaterLevelDropdown({required int activeWaterLevel}) {
    final alert = _getAlertForWaterLevel(activeWaterLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() => _showWaterLevelAlert = !_showWaterLevelAlert);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showWaterLevelAlert
                      ? 'Sembunyikan Notifikasi Water Level'
                      : 'Lihat Notifikasi Water Level ($activeWaterLevel%)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _showWaterLevelAlert
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_showWaterLevelAlert) ...[
          const SizedBox(height: 10),
          LightCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alert.primaryColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert.icon,
                    color: alert.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              alert.title,
                              style: const TextStyle(
                                color: kDarkText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  alert.primaryColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$activeWaterLevel%',
                              style: TextStyle(
                                color: alert.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.description,
                        style: TextStyle(
                          color: kDarkText.withValues(alpha: 0.8),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert.recommendation,
                        style: TextStyle(
                          color: alert.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _WaterLevelThresholdInfo {
  final int thresholdPercent;
  final String title;
  final String description;
  final String recommendation;
  final IconData icon;
  final Color primaryColor;

  const _WaterLevelThresholdInfo({
    required this.thresholdPercent,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.icon,
    required this.primaryColor,
  });
}
