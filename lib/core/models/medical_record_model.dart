enum TestReviewStatus { normal, borderline, requiresReview }

class MedicalRecordItem {
  final String id;
  final String testName;
  final String testNameTe;
  final String category; // 'Blood', 'Urine', 'Ultrasound', 'Screening'
  final String recordedValue;
  final String normalRange;
  final DateTime testDate;
  final String facility;
  final TestReviewStatus reviewStatus;
  final String clinicalNotes;
  final String clinicalNotesTe;

  MedicalRecordItem({
    required this.id,
    required this.testName,
    required this.testNameTe,
    required this.category,
    required this.recordedValue,
    required this.normalRange,
    required this.testDate,
    required this.facility,
    required this.reviewStatus,
    this.clinicalNotes = '',
    this.clinicalNotesTe = '',
  });
}
