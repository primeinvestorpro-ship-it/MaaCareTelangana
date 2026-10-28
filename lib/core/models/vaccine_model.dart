enum VaccineTarget { mother, baby }

class VaccineItem {
  final String id;
  final String name;
  final String nameTe;
  final String targetGroup; // e.g., 'Maternal Td' or 'Baby Birth Dose'
  final String recommendedPeriod; // e.g., 'First trimester or early registration'
  final String recommendedPeriodTe;
  final VaccineTarget target;
  final bool isMandatory;
  bool isCompleted;
  DateTime? administrationDate;
  String? administeredFacility;
  String? batchNumber;

  VaccineItem({
    required this.id,
    required this.name,
    required this.nameTe,
    required this.targetGroup,
    required this.recommendedPeriod,
    required this.recommendedPeriodTe,
    required this.target,
    this.isMandatory = true,
    this.isCompleted = false,
    this.administrationDate,
    this.administeredFacility,
    this.batchNumber,
  });
}
