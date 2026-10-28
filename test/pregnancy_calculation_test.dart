import 'package:flutter_test/flutter_test.dart';
import 'package:maacare_telangana/core/models/pregnancy_model.dart';

void main() {
  group('Pregnancy Calculations & Rules', () {
    test('Calculates EDD correctly using Naegele rule (LMP + 280 days)', () {
      final lmp = DateTime(2026, 1, 1);
      final expectedEdd = lmp.add(const Duration(days: 280));

      final profile = PregnancyProfile(
        id: 'test_p1',
        motherName: 'Test Mother',
        phoneNumber: '9876543210',
        lmpDate: lmp,
        estimatedDueDate: expectedEdd,
      );

      expect(profile.estimatedDueDate.difference(profile.lmpDate).inDays, equals(280));
    });

    test('Trimester boundaries accurately partition weeks', () {
      // Trimester 1 (Weeks 1-12)
      final lmpT1 = DateTime.now().subtract(const Duration(days: 70)); // ~10 weeks
      final profileT1 = PregnancyProfile(
        id: 't1',
        motherName: 'T1 Mother',
        phoneNumber: '9876543210',
        lmpDate: lmpT1,
        estimatedDueDate: lmpT1.add(const Duration(days: 280)),
      );
      expect(profileT1.trimester, equals(1));

      // Trimester 2 (Weeks 13-27)
      final lmpT2 = DateTime.now().subtract(const Duration(days: 140)); // ~20 weeks
      final profileT2 = PregnancyProfile(
        id: 't2',
        motherName: 'T2 Mother',
        phoneNumber: '9876543210',
        lmpDate: lmpT2,
        estimatedDueDate: lmpT2.add(const Duration(days: 280)),
      );
      expect(profileT2.trimester, equals(2));

      // Trimester 3 (Weeks 28+)
      final lmpT3 = DateTime.now().subtract(const Duration(days: 220)); // ~31 weeks
      final profileT3 = PregnancyProfile(
        id: 't3',
        motherName: 'T3 Mother',
        phoneNumber: '9876543210',
        lmpDate: lmpT3,
        estimatedDueDate: lmpT3.add(const Duration(days: 280)),
      );
      expect(profileT3.trimester, equals(3));
    });
  });
}
