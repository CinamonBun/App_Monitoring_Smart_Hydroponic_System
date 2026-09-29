import 'package:flutter_test/flutter_test.dart';
import 'package:app_monitoring_smart_hydroponic_system/models/plant_slot_model.dart';

void main() {
  group('PlantSlot Tests', () {
    test('ageDays computes correctly based on calendar difference', () {
      final now = DateTime.now();
      final tenDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 10));

      final slot = PlantSlot(
        id: 'slot_1',
        slotName: 'Modul 1',
        plantName: 'Selada',
        plantingDate: tenDaysAgo,
        harvestTargetDays: 30,
      );

      expect(slot.ageDays, 10);
      expect(slot.daysLeft, 20);
      expect(slot.isReadyToHarvest, false);
    });

    test('PlantSlot serialization toJson and fromJson preserves data', () {
      final now = DateTime.now();
      final slot = PlantSlot(
        id: 'slot_test',
        slotName: 'Modul Test',
        plantName: 'Pakcoy',
        plantingDate: now.subtract(const Duration(days: 15)),
        harvestTargetDays: 35,
        variety: 'Nauli F1',
        notes: 'Pertumbuhan optimal',
      );

      final json = slot.toJson();
      final reconstructed = PlantSlot.fromJson(json);

      expect(reconstructed.id, slot.id);
      expect(reconstructed.plantName, slot.plantName);
      expect(reconstructed.harvestTargetDays, slot.harvestTargetDays);
      expect(reconstructed.ageDays, 15);
      expect(reconstructed.variety, slot.variety);
      expect(reconstructed.notes, slot.notes);
    });

    test('copyWith updates plantingDate when ageDays is provided', () {
      final slot = PlantSlot(
        id: 'slot_1',
        slotName: 'Modul 1',
        plantName: 'Selada',
        initialAgeDays: 5,
        harvestTargetDays: 30,
      );

      expect(slot.ageDays, 5);

      final updated = slot.copyWith(ageDays: 12);
      expect(updated.ageDays, 12);
    });
  });
}
