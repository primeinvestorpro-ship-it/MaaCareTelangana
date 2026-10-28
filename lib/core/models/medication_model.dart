class MedicationItem {
  final String id;
  final String name;
  final String nameTe;
  final String strength;
  final String dosageSchedule; // e.g., '1 Tablet Daily (Night)'
  final String dosageScheduleTe;
  final String foodInstructions; // e.g. 'Take after food with lemon water. Never with milk.'
  final String foodInstructionsTe;
  final String prescribedBy;
  final DateTime startDate;
  final DateTime? endDate;
  bool isTakenToday;
  DateTime? lastTakenTime;

  MedicationItem({
    required this.id,
    required this.name,
    required this.nameTe,
    required this.strength,
    required this.dosageSchedule,
    required this.dosageScheduleTe,
    required this.foodInstructions,
    required this.foodInstructionsTe,
    required this.prescribedBy,
    required this.startDate,
    this.endDate,
    this.isTakenToday = false,
    this.lastTakenTime,
  });
}
