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

  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Sensor', 'Nutrisi', 'Peringatan'];

  final List<_HistoryLogItem> _logs = const [
    _HistoryLogItem(
      title: 'Dosing Nutrisi AB Mix',
      category: 'Nutrisi',
      time: 'Hari ini • 14:30 WIB',
      description:
          'Pompa nutrisi aktif otomatis 15 detik. Nilai TDS naik dari 530 ppm menjadi 615 ppm.',
      badgeText: 'Selesai',
      badgeColor: Color(0xFF2E7D32),
      icon: Icons.science_rounded,
      iconColor: kWarnAmber,
    ),
    _HistoryLogItem(
      title: 'Pengecekan Rutin Sensor',
      category: 'Sensor',
      time: 'Hari ini • 12:00 WIB',
      description:
          'Suhu air: 28.0°C | pH: 6.4 | TDS: 610 ppm | Volume Air: 78% (Optimal).',
      badgeText: 'Optimal',
      badgeColor: Color(0xFF237497),
      icon: Icons.sensors_rounded,
      iconColor: kWaterAccent,
    ),
    _HistoryLogItem(
      title: 'Peringatan Suhu Air Tinggi',
      category: 'Peringatan',
      time: 'Hari ini • 10:15 WIB',
      description:
          'Suhu air terdeteksi 29.6°C (Batas: 28.5°C). Kipas sirkulasi otomatis menyala 12 menit.',
      badgeText: 'Ditangani',
      badgeColor: Color(0xFFD97706),
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFD97706),
    ),
    _HistoryLogItem(
      title: 'Siklus Pompa Aerasi Pagi',
      category: 'Nutrisi',
      time: 'Hari ini • 07:00 WIB',
      description:
          'Siklus aerator berjalan 30 menit. Sirkulasi nutrisi NFT dan oksigen terlarut lancar.',
      badgeText: 'Selesai',
      badgeColor: Color(0xFF2E7D32),
      icon: Icons.water_rounded,
      iconColor: kWaterAccent,
    ),
    _HistoryLogItem(
      title: 'Kalibrasi Sensor pH Berhasil',
      category: 'Sensor',
      time: 'Kemarin • 17:40 WIB',
      description:
          'Kalibrasi sensor analog pH menggunakan larutan buffer standar 4.01 & 6.86.',
      badgeText: 'Sukses',
      badgeColor: Color(0xFF2E7D32),
      icon: Icons.tune_rounded,
      iconColor: Color(0xFF5BA8C4),
    ),
    _HistoryLogItem(
      title: 'Level Air Tangki Rendah',
      category: 'Peringatan',
      time: 'Kemarin • 08:20 WIB',
      description:
          'Sensor ultrasonic mendeteksi level air < 30%. Pengisian valve otomatis dibuka 3L.',
      badgeText: 'Teratasi',
      badgeColor: Color(0xFFD97706),
      icon: Icons.opacity_rounded,
      iconColor: Color(0xFFD97706),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final service = HydroponicService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final activeFilter = _filters[_selectedFilter];

        // Konversi log real-time dari API ke format tampilan _HistoryLogItem
        final realItems = service.realHistoryLogs.map((log) {
          final h = log.timestamp.hour.toString().padLeft(2, '0');
          final m = log.timestamp.minute.toString().padLeft(2, '0');
          return _HistoryLogItem(
            title: log.title,
            category: log.category,
            time: 'Hari ini • $h:$m WIB',
            description: log.description,
            badgeText: log.badgeText,
            badgeColor: service.isConnected
                ? const Color(0xFF2E7D32)
                : const Color(0xFFD97706),
            icon: Icons.sensors_rounded,
            iconColor: kWaterAccent,
          );
        }).toList();

        final allLogs = [...realItems, ..._logs];
        final filteredLogs = activeFilter == 'Semua'
            ? allLogs
            : allLogs.where((l) => l.category == activeFilter).toList();

        final bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 70, 0, 120),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Text(
                        'Riwayat Monitoring',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Log sensor & riwayat otomatisasi sistem hidroponik',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DarkGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.insights_rounded,
                                color: Colors.white.withOpacity(0.9),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rangkuman 24 Jam',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (service.isConnected
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFD97706))
                                  .withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (service.isConnected
                                        ? const Color(0xFF81C784)
                                        : const Color(0xFFFBBF24))
                                    .withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              service.isConnected ? 'Stabil' : 'Menunggu',
                              style: TextStyle(
                                color: service.isConnected
                                    ? const Color(0xFFA5D6A7)
                                    : const Color(0xFFFDE68A),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryColumn(
                            'Suhu Rata-rata',
                            service.hasData ? '${service.waterTemp}°C' : '27.8°C',
                            service.hasData
                                ? 'Min ${service.minTemp?.toStringAsFixed(1) ?? "24"}° / Max ${service.maxTemp?.toStringAsFixed(1) ?? "29"}°'
                                : 'Min 24° / Max 29°',
                          ),
                          _buildSummaryDivider(),
                          _buildSummaryColumn(
                            'pH Rata-rata',
                            service.hasData ? service.ph : '6.4',
                            'Ideal (6.0 - 6.8)',
                          ),
                          _buildSummaryDivider(),
                          _buildSummaryColumn(
                            'TDS Nutrisi',
                            service.hasData ? '${service.tds} ppm' : '615 ppm',
                            'Target Selada',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  for (int i = 0; i < _filters.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedFilter == i
                                ? Colors.white.withOpacity(0.95)
                                : const Color(0xFF1A3B47).withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedFilter == i
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: _selectedFilter == i
                                  ? kDarkText
                                  : Colors.white,
                              fontSize: 13,
                              fontWeight: _selectedFilter == i
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (filteredLogs.isEmpty)
              const LightCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Tidak ada catatan untuk kategori ini',
                      style: TextStyle(color: kMutedDark, fontSize: 14),
                    ),
                  ),
                ),
              )
            else
              for (final log in filteredLogs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: LightCard(
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
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: log.iconColor.withOpacity(0.14),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    log.icon,
                                    color: log.iconColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  log.title,
                                  style: const TextStyle(
                                    color: kDarkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: log.badgeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                log.badgeText,
                                style: TextStyle(
                                  color: log.badgeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          log.description,
                          style: TextStyle(
                            color: kDarkText.withOpacity(0.85),
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: kMutedDark.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              log.time,
                              style: const TextStyle(
                                color: kMutedDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ],
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
            colors: [Color(0xFF237497), Color(0xFFCEEFFE), Color(0xFFEDFAFF)],
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
              'Riwayat Monitoring',
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

  Widget _buildSummaryColumn(String title, String value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.18),
    );
  }
}

class _HistoryLogItem {
  const _HistoryLogItem({
    required this.title,
    required this.category,
    required this.time,
    required this.description,
    required this.badgeText,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String category;
  final String time;
  final String description;
  final String badgeText;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;
}
