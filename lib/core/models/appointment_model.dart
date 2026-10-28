enum AppointmentStatus { upcoming, completed, missed, rescheduled }

class ANCAppointment {
  final String id;
  final String title;
  final String titleTe;
  final int visitNumber; // ANC 1, 2, 3, 4, etc.
  final DateTime scheduledDate;
  final String facilityName;
  final String doctorOrWorker;
  final String notes;
  final String notesTe;
  final bool requiresMcpCard;
  final bool requiresUltrasound;
  final bool requiresFastingBlood;
  AppointmentStatus status;

  ANCAppointment({
    required this.id,
    required this.title,
    required this.titleTe,
    required this.visitNumber,
    required this.scheduledDate,
    required this.facilityName,
    required this.doctorOrWorker,
    this.notes = '',
    this.notesTe = '',
    this.requiresMcpCard = true,
    this.requiresUltrasound = false,
    this.requiresFastingBlood = false,
    this.status = AppointmentStatus.upcoming,
  });
}
