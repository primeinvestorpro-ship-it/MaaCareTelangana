import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../core/models/medical_record_model.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appState.isTelugu ? 'వైద్య పరీక్షలు & రిపోర్టులు' : 'Medical Tests & Reports',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Clinical Safety Disclaimer (PRD 4.5 requirement)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFFB78103)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      appState.isTelugu
                          ? 'గమనిక: ఈ రికార్డులు కేవలం సమాచార పర్యవేక్షణ కోసం మాత్రమే. పరీక్ష ఫలితాల్లో ఏవైనా తేడాలుంటే అర్హత కలిగిన డాక్టర్‌ను సంప్రదించండి.'
                          : 'Safety Notice: These records are for personal tracking. Any abnormal test values must be reviewed directly with your clinician.',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF5D4037), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Diagnostic Reports List
            ...appState.medicalRecords.map((rec) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              appState.isTelugu ? rec.testNameTe : rec.testName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _buildStatusBadge(rec.reviewStatus, appState.isTelugu),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.black38),
                            onPressed: () {
                              appState.deleteMedicalRecord(rec.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Test record removed')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${rec.facility} • ${dateFormat.format(rec.testDate)}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const Divider(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.isTelugu ? 'పరీక్ష ఫలితం' : 'Recorded Result',
                                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rec.recordedValue,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.isTelugu ? 'సాధారణ పరిధి' : 'Normal Range',
                                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rec.normalRange,
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (rec.clinicalNotes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryLight.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.comment, size: 14, color: AppTheme.secondaryTeal),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  appState.isTelugu ? rec.clinicalNotesTe : rec.clinicalNotes,
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.secondaryTeal,
        foregroundColor: Colors.white,
        onPressed: () => _showAddRecordDialog(context, appState),
        icon: const Icon(Icons.add),
        label: Text(appState.isTelugu ? 'రిపోర్ట్ జోడించండి' : 'Add Test Result'),
      ),
    );
  }

  Widget _buildStatusBadge(TestReviewStatus status, bool isTelugu) {
    Color bg = AppTheme.secondaryLight;
    Color text = AppTheme.secondaryTeal;
    String label = isTelugu ? 'సాధారణం' : 'Normal';

    if (status == TestReviewStatus.borderline) {
      bg = const Color(0xFFFFF3E0);
      text = Colors.deepOrange;
      label = isTelugu ? 'సరిహద్దు' : 'Borderline';
    } else if (status == TestReviewStatus.requiresReview) {
      bg = const Color(0xFFFFEBEE);
      text = AppTheme.emergencyRed;
      label = isTelugu ? 'డాక్టర్ పరిశీలన' : 'Review Needed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  void _showAddRecordDialog(BuildContext context, AppState state) {
    final testNameController = TextEditingController();
    final valueController = TextEditingController();
    final facilityController = TextEditingController(text: 'Govt Maternity Hospital Diagnostic Lab');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state.isTelugu ? 'కొత్త వైద్య పరీక్ష రికార్డు' : 'Add Medical Test Record',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: testNameController,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'పరీక్ష పేరు (ఉదా: Hb, OGTT, స్కాన్)' : 'Test Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'ఫలితం (Result)' : 'Test Result / Value',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: facilityController,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'ల్యాబ్ / ఆసుపత్రి' : 'Testing Laboratory / Hospital',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (testNameController.text.trim().isEmpty) return;
                  state.addMedicalRecord(
                    MedicalRecordItem(
                      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
                      testName: testNameController.text.trim(),
                      testNameTe: testNameController.text.trim(),
                      category: 'Blood',
                      recordedValue: valueController.text.trim(),
                      normalRange: 'Reviewed by Clinician',
                      testDate: DateTime.now(),
                      facility: facilityController.text.trim(),
                      reviewStatus: TestReviewStatus.normal,
                      clinicalNotes: 'Self-recorded test record.',
                      clinicalNotesTe: 'స్వయంగా నమోదు చేసిన రికార్డు.',
                    ),
                  );
                  Navigator.of(ctx).pop();
                },
                child: Text(state.isTelugu ? 'సేవ్ చేయండి' : 'Save Record'),
              ),
            ],
          ),
        );
      },
    );
  }
}
