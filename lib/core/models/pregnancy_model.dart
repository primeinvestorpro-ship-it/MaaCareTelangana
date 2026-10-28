class PregnancyProfile {
  final String id;
  final String motherName;
  final String phoneNumber;
  final DateTime lmpDate;
  final DateTime estimatedDueDate;
  final String eddSource; // 'LMP_CALCULATION' or 'CLINICIAN_USG'
  final int gravida;
  final int parity;
  final bool isHighRisk;
  final String? highRiskReason;
  final String preferredHospital;
  final String bloodGroup;
  final String ashaWorkerName;
  final String ashaWorkerPhone;
  final String emergencyCaregiverPhone;

  PregnancyProfile({
    required this.id,
    required this.motherName,
    required this.phoneNumber,
    required this.lmpDate,
    required this.estimatedDueDate,
    this.eddSource = 'LMP_CALCULATION',
    this.gravida = 1,
    this.parity = 0,
    this.isHighRisk = false,
    this.highRiskReason,
    this.preferredHospital = 'Govt Maternity Hospital, Petlaburj',
    this.bloodGroup = 'B Positive',
    this.ashaWorkerName = 'Laxmi Devi (ASHA)',
    this.ashaWorkerPhone = '9440123456',
    this.emergencyCaregiverPhone = '9849012345',
  });

  // Calculate gestational age in days
  int get gestationalDays {
    final now = DateTime.now();
    return now.difference(lmpDate).inDays.clamp(0, 300);
  }

  // Gestational weeks (e.g. 24 weeks)
  int get currentWeek => (gestationalDays / 7).floor() + 1;

  // Day of the week (e.g. Day 3)
  int get currentDayOfWeek => (gestationalDays % 7) + 1;

  // Trimester: 1 (Weeks 1-12), 2 (Weeks 13-27), 3 (Weeks 28-40+)
  int get trimester {
    if (currentWeek <= 12) return 1;
    if (currentWeek <= 27) return 2;
    return 3;
  }

  // Days remaining till EDD
  int get daysUntilEdd {
    final now = DateTime.now();
    final diff = estimatedDueDate.difference(now).inDays;
    return diff > 0 ? diff : 0;
  }

  // Copy with updated fields
  PregnancyProfile copyWith({
    String? motherName,
    String? phoneNumber,
    DateTime? lmpDate,
    DateTime? estimatedDueDate,
    String? eddSource,
    int? gravida,
    int? parity,
    bool? isHighRisk,
    String? highRiskReason,
    String? preferredHospital,
    String? bloodGroup,
    String? ashaWorkerName,
    String? ashaWorkerPhone,
    String? emergencyCaregiverPhone,
  }) {
    return PregnancyProfile(
      id: id,
      motherName: motherName ?? this.motherName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lmpDate: lmpDate ?? this.lmpDate,
      estimatedDueDate: estimatedDueDate ?? this.estimatedDueDate,
      eddSource: eddSource ?? this.eddSource,
      gravida: gravida ?? this.gravida,
      parity: parity ?? this.parity,
      isHighRisk: isHighRisk ?? this.isHighRisk,
      highRiskReason: highRiskReason ?? this.highRiskReason,
      preferredHospital: preferredHospital ?? this.preferredHospital,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      ashaWorkerName: ashaWorkerName ?? this.ashaWorkerName,
      ashaWorkerPhone: ashaWorkerPhone ?? this.ashaWorkerPhone,
      emergencyCaregiverPhone: emergencyCaregiverPhone ?? this.emergencyCaregiverPhone,
    );
  }
}
