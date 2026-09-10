import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/dark_glass_card.dart';
import '../widgets/light_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isStandalone = false});

  final bool isStandalone;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _autoDosing = true;
  bool _warningAlerts = true;
  bool _autoCirculation = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 120),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DarkGlassCard(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.18),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'C9monBun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nobody',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ESP32 Node-01 Online (v2.4)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LightCard(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '45 Hari',
                    'Masa Tanam',
                    Icons.calendar_today_rounded,
                  ),
                  _buildStatDivider(),
                  _buildStatItem('120 Pcs', 'Selada Hijau', Icons.eco_rounded),
                  _buildStatDivider(),
                  _buildStatItem(
                    '4 Sensor',
                    'Status Aktif',
                    Icons.sensors_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LightCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.smart_toy_rounded,
                        color: kMutedDark,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Kontrol Otomatisasi',
                        style: TextStyle(
                          color: kDarkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildSwitchTile(
                    title: 'Dosing Nutrisi Otomatis',
                    subtitle: 'Pompa aktif saat TDS < 550 ppm',
                    value: _autoDosing,
                    onChanged: (v) => setState(() => _autoDosing = v),
                  ),
                  const Divider(height: 20, color: Color(0x14237497)),
                  _buildSwitchTile(
                    title: 'Peringatan Anomali Sensor',
                    subtitle: 'Alarm notifikasi jika pH atau suhu kritis',
                    value: _warningAlerts,
                    onChanged: (v) => setState(() => _warningAlerts = v),
                  ),
                  const Divider(height: 20, color: Color(0x14237497)),
                  _buildSwitchTile(
                    title: 'Sirkulasi Aerator Berkala',
                    subtitle: 'Siklus hidup setiap 20 menit',
                    value: _autoCirculation,
                    onChanged: (v) => setState(() => _autoCirculation = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LightCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.settings_suggest_rounded,
                        color: kMutedDark,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pengaturan & Alat',
                        style: TextStyle(
                          color: kDarkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildActionTile(
                    icon: Icons.tune_rounded,
                    title: 'Kalibrasi Sensor (pH & TDS)',
                    subtitle: 'Atur offset nilai kalibrasi sensor analog',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Membuka menu kalibrasi sensor...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.wifi_rounded,
                    title: 'Konfigurasi Wi-Fi & MQTT',
                    subtitle: 'Broker: 192.168.1.100 (Port 1883)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Konfigurasi jaringan ESP32 dibuka'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Smart Hydroponic System v1.0.0',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('Smart Hydroponic System'),
                          content: const Text(
                            'Aplikasi monitoring dan otomatisasi hidroponik cerdas berbasis IoT untuk program MBKM.\n\nDikembangkan dengan Flutter & ESP32.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur keluar akun dipilih'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const LightCard(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                color: Color(0xFFFFF2F2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFD32F2F),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
              'Profil Pengguna',
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
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: kMutedDark, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: kDarkText,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: kMutedDark.withOpacity(0.85), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: const Color(0x14237497));
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kDarkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: kMutedDark.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF237497),
          activeTrackColor: const Color(0xFFCEEFFE),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x14237497),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: kMutedDark, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: kDarkText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: kMutedDark.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: kMutedDark.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
