import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/plant_slot_model.dart';
import '../services/plant_storage_service.dart';
import '../widgets/dark_glass_card.dart';
import '../widgets/light_card.dart';

class PlantAgeScreen extends StatefulWidget {
  const PlantAgeScreen({super.key, this.isStandalone = false});

  final bool isStandalone;

  @override
  State<PlantAgeScreen> createState() => _PlantAgeScreenState();
}

class _PlantAgeScreenState extends State<PlantAgeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Daftar preset tanaman hidroponik populer untuk pilihan cepat
  final List<PlantPreset> _presets = const [
    PlantPreset(
      name: 'Selada Butterhead',
      defaultHarvestDays: 42,
      variety: 'Lactuca sativa',
      icon: Icons.eco_rounded,
      themeColor: Color(0xFF2E7D32),
    ),
    PlantPreset(
      name: 'Pakcoy Hijau',
      defaultHarvestDays: 35,
      variety: 'Brassica rapa',
      icon: Icons.spa_rounded,
      themeColor: Color(0xFF388E3C),
    ),
    PlantPreset(
      name: 'Kangkung Hidroponik',
      defaultHarvestDays: 25,
      variety: 'Ipomoea aquatica',
      icon: Icons.grass_rounded,
      themeColor: Color(0xFF00897B),
    ),
    PlantPreset(
      name: 'Bayam Merah',
      defaultHarvestDays: 28,
      variety: 'Amaranthus tricolor',
      icon: Icons.local_florist_rounded,
      themeColor: Color(0xFFC2185B),
    ),
    PlantPreset(
      name: 'Sawi Caisim',
      defaultHarvestDays: 30,
      variety: 'Brassica juncea',
      icon: Icons.eco_rounded,
      themeColor: Color(0xFF43A047),
    ),
    PlantPreset(
      name: 'Daun Mint',
      defaultHarvestDays: 60,
      variety: 'Mentha spicata',
      icon: Icons.energy_savings_leaf_rounded,
      themeColor: Color(0xFF00ACC1),
    ),
    PlantPreset(
      name: 'Kemangi / Basil',
      defaultHarvestDays: 40,
      variety: 'Ocimum basilicum',
      icon: Icons.spa_rounded,
      themeColor: Color(0xFF7CB342),
    ),
    PlantPreset(
      name: 'Seledri Air',
      defaultHarvestDays: 65,
      variety: 'Apium graveolens',
      icon: Icons.grass_rounded,
      themeColor: Color(0xFF558B2F),
    ),
  ];

  // 4 Slot / Modul Tanaman Utama
  late List<PlantSlot> _plantSlots;

  @override
  void initState() {
    super.initState();
    _plantSlots = PlantStorageService.getDefaultSlots();
    _loadStoredSlots();
  }

  Future<void> _loadStoredSlots() async {
    final slots = await PlantStorageService.loadPlantSlots();
    if (mounted) {
      setState(() {
        _plantSlots = slots;
      });
    }
  }

  // Dialog / BottomSheet untuk mengedit tanaman, tanggal tanam, dan umurnya
  void _showEditPlantDialog(int index) {
    final slot = _plantSlots[index];

    final nameController = TextEditingController(text: slot.plantName);
    final varietyController = TextEditingController(text: slot.variety);
    final notesController = TextEditingController(text: slot.notes);

    DateTime currentPlantingDate = slot.plantingDate;
    int currentAge = slot.ageDays;
    int currentTarget = slot.harvestTargetDays;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String formatShortDate(DateTime d) {
              const months = [
                '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
              ];
              return '${d.day} ${months[d.month]} ${d.year}';
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A4B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kWaterAccent.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_calendar_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Edit Tanaman & Siklus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${slot.slotName} • Sinkron Kalender Otomatis',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Pilihan Cepat / Preset Tanaman
                    Text(
                      'Pilih Cepat Jenis Tanaman:',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _presets.map((preset) {
                          final isSelected =
                              nameController.text.trim().toLowerCase() ==
                              preset.name.toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () {
                                setModalState(() {
                                  nameController.text = preset.name;
                                  varietyController.text = preset.variety;
                                  currentTarget = preset.defaultHarvestDays;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? preset.themeColor
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      preset.icon,
                                      size: 14,
                                      color: isSelected
                                          ? preset.themeColor
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      preset.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? kDarkText
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nama Tanaman Input
                    _buildInputField(
                      label: 'Nama Tanaman',
                      controller: nameController,
                      hint: 'Contoh: Selada Butterhead',
                      icon: Icons.eco_rounded,
                    ),

                    const SizedBox(height: 12),

                    // Pengaturan Tanggal Mulai Tanam (Planting Date)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color(0xFF81C784),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Tanggal Mulai Tanam',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // Tombol Pilih Tanggal dari Kalender
                              InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: currentPlantingDate,
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 365),
                                    ),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.dark(
                                            primary: Color(0xFF2E7D32),
                                            onPrimary: Colors.white,
                                            surface: Color(0xFF1E3A4B),
                                            onSurface: Colors.white,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (picked != null) {
                                    setModalState(() {
                                      currentPlantingDate = picked;
                                      final now = DateTime.now();
                                      final today = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                      );
                                      final pDay = DateTime(
                                        picked.year,
                                        picked.month,
                                        picked.day,
                                      );
                                      final diff =
                                          today.difference(pDay).inDays;
                                      currentAge = diff < 0 ? 0 : diff;
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32)
                                        .withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF81C784)
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.edit_calendar_rounded,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Ubah Tanggal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatShortDate(currentPlantingDate),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // Tombol Cepat: Tanam Baru Hari Ini
                              InkWell(
                                onTap: () {
                                  setModalState(() {
                                    final now = DateTime.now();
                                    currentPlantingDate = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                    );
                                    currentAge = 0;
                                  });
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Tanam Hari Ini (Reset)',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Umur akan bertambah 1 hari otomatis setiap pukul 00:00',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Baris Pengaturan Umur & Target Panen
                    Row(
                      children: [
                        // Atur Umur Tanaman Sekarang
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Umur Sekarang',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildCircleButton(
                                      icon: Icons.remove,
                                      onTap: () {
                                        if (currentAge > 0) {
                                          setModalState(() {
                                            currentAge--;
                                            final now = DateTime.now();
                                            currentPlantingDate = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                            ).subtract(
                                              Duration(days: currentAge),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                      '$currentAge Hari',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    _buildCircleButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        setModalState(() {
                                          currentAge++;
                                          final now = DateTime.now();
                                          currentPlantingDate = DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                          ).subtract(
                                            Duration(days: currentAge),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Atur Target Panen
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Panen',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildCircleButton(
                                      icon: Icons.remove,
                                      onTap: () {
                                        if (currentTarget > 5) {
                                          setModalState(() => currentTarget--);
                                        }
                                      },
                                    ),
                                    Text(
                                      '$currentTarget Hari',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    _buildCircleButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        setModalState(() => currentTarget++);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Varietas Tanaman
                    _buildInputField(
                      label: 'Varietas / Jenis Bibit (Opsional)',
                      controller: varietyController,
                      hint: 'Contoh: Grand Rapids / F1',
                      icon: Icons.biotech_rounded,
                    ),

                    const SizedBox(height: 12),

                    // Catatan Perawatan
                    _buildInputField(
                      label: 'Catatan Perawatan / Kondisi',
                      controller: notesController,
                      hint: 'Contoh: Pertumbuhan daun subur dan sehat',
                      icon: Icons.notes_rounded,
                    ),

                    const SizedBox(height: 20),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final updatedName = nameController.text.trim().isEmpty
                              ? slot.plantName
                              : nameController.text.trim();

                          final updatedSlot = slot.copyWith(
                            plantName: updatedName,
                            plantingDate: currentPlantingDate,
                            harvestTargetDays: currentTarget,
                            variety: varietyController.text.trim(),
                            notes: notesController.text.trim(),
                          );

                          setState(() {
                            _plantSlots[index] = updatedSlot;
                          });

                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(ctx);

                          // Simpan ke SharedPreferences secara permanen
                          await PlantStorageService.savePlantSlots(_plantSlots);

                          navigator.pop();

                          messenger.showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E3A4B),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Text(
                                '${slot.slotName} berhasil disimpan: $updatedName (${updatedSlot.ageDays} Hari)',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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
          },
        );
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13.5),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            prefixIcon: Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.6),
              size: 18,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 12.5,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Hitung rata-rata umur seluruh modul
    final totalAge = _plantSlots.map((s) => s.ageDays).reduce((a, b) => a + b);
    final avgAge = (totalAge / _plantSlots.length).round();

    // Temukan modul yang paling cepat panen
    final minDaysLeft = _plantSlots
        .map((s) => s.daysLeft)
        .reduce((a, b) => a < b ? a : b);

    // Hitung berapa modul yang siap panen
    final readyCount = _plantSlots.where((s) => s.isReadyToHarvest).length;

    final bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 64, 18, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER PAGE =====
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Monitoring Umur Tanaman',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hitung otomatis harian & estimasi panen 4 modul',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== KARTU RINGKASAN SISTEM =====
              DarkGlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.sync_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Sinkron Kalender Harian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
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
                            color: const Color(0xFF2E7D32)
                                .withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2E7D32)
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            readyCount > 0
                                ? '$readyCount Siap Panen 🎉'
                                : '4 Modul Aktif',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryPill(
                            title: 'Rata-rata Umur',
                            value: '$avgAge Hari',
                            icon: Icons.timelapse_rounded,
                            iconColor: kWarnAmber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSummaryPill(
                            title: 'Panen Terdekat',
                            value: minDaysLeft == 0
                                ? 'Hari Ini!'
                                : '$minDaysLeft Hari Lagi',
                            icon: Icons.event_available_rounded,
                            iconColor: const Color(0xFF81C784),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== HEADER LIST 4 CARD =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar 4 Modul Tanaman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Ketuk kartu untuk ubah',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== 4 CARD TANAMAN (DAPAT DI-EDIT & TERHUBUNG TANGGAL) =====
              for (var i = 0; i < _plantSlots.length; i++)
                _buildPlantCard(slot: _plantSlots[i], index: i),
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
              'Umur Tanaman',
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

  // Widget Kartu Masing-masing Tanaman dari 4 Card
  Widget _buildPlantCard({required PlantSlot slot, required int index}) {
    final percentInt = (slot.progress * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEditPlantDialog(index),
        borderRadius: BorderRadius.circular(16),
        child: LightCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Atas: Nama Modul + Badge Fase Tumbuh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8FB),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE0EFF6)),
                        ),
                        child: Text(
                          slot.slotName,
                          style: TextStyle(
                            color: kMutedDark.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
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
                      color: slot.stageColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      slot.growthStage,
                      style: TextStyle(
                        color: slot.stageColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Baris Tengah: Icon Tanaman + Nama Tanaman + Umur Hari
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: slot.stageColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      color: slot.stageColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slot.plantName,
                          style: const TextStyle(
                            color: kDarkText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          slot.variety.isNotEmpty
                              ? 'Varietas: ${slot.variety}'
                              : 'Tanaman Hidroponik NFT',
                          style: TextStyle(
                            color: kMutedDark.withValues(alpha: 0.75),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Angka Umur Tanaman (Dihitung Otomatis dari plantingDate)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${slot.ageDays}',
                            style: TextStyle(
                              color: slot.stageColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Hari',
                            style: TextStyle(
                              color: kMutedDark.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Target: ${slot.harvestTargetDays} hari',
                        style: TextStyle(
                          color: kMutedDark.withValues(alpha: 0.65),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Detail Tanggal Tanam & Estimasi Panen
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FBFD),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5F1F6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tanam: ${slot.formattedPlantingDate}',
                          style: TextStyle(
                            color: kMutedDark.withValues(alpha: 0.85),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_available_rounded,
                          size: 13,
                          color: Color(0xFF0288D1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Panen: ${slot.formattedHarvestDate}',
                          style: TextStyle(
                            color: kMutedDark.withValues(alpha: 0.85),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Progress Bar Umur Menuju Panen
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Siklus Panen ($percentInt%)',
                        style: TextStyle(
                          color: kMutedDark.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        slot.isReadyToHarvest
                            ? 'Waktu panen telah tiba!'
                            : '${slot.daysLeft} hari lagi panen',
                        style: TextStyle(
                          color: slot.stageColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: slot.progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2EBF0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        slot.stageColor,
                      ),
                    ),
                  ),
                ],
              ),

              if (slot.notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  slot.notes,
                  style: TextStyle(
                    color: kDarkText.withValues(alpha: 0.75),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 10),
              Container(height: 1, color: const Color(0xFFE8F0F3)),
              const SizedBox(height: 8),

              // Tombol Aksi Edit Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Otomatis +1 hari/hari',
                        style: TextStyle(
                          color: kMutedDark.withValues(alpha: 0.6),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 16,
                        color: kWaterAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ubah Tanaman & Umur',
                        style: TextStyle(
                          color: kWaterAccent,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryPill({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
