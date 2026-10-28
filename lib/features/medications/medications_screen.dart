import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/models/medication_model.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t('medications_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Critical Medical Safety Guideline (PRD 4.7 requirement)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB74D)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Text(
                        appState.isTelugu ? 'ముఖ్యమైన ఔషధ నియమం' : 'Critical Medication Safety Rule',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loc.t('med_instructions_safety'),
                    style: const TextStyle(fontSize: 12, height: 1.3, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.t('missed_dose_warning'),
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Active Medications List
            ...appState.medications.map((med) {
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.isTelugu ? med.nameTe : med.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  med.strength,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: med.isTakenToday
                                  ? AppTheme.secondaryLight
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              med.isTakenToday ? loc.t('taken') : (appState.isTelugu ? 'మిగిలి ఉంది' : 'Due Today'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: med.isTakenToday ? AppTheme.secondaryTeal : Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.black45),
                            onPressed: () {
                              appState.deleteMedication(med.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Medication removed')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 14, color: AppTheme.primaryRose),
                                const SizedBox(width: 6),
                                Text(
                                  appState.isTelugu ? med.dosageScheduleTe : med.dosageSchedule,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: Colors.black54),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    appState.isTelugu ? med.foodInstructionsTe : med.foodInstructions,
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${appState.isTelugu ? 'సూచించిన డాక్టర్' : 'Prescribed By'}: ${med.prescribedBy}',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                med.isTakenToday ? Colors.grey.shade300 : AppTheme.secondaryTeal,
                            foregroundColor: med.isTakenToday ? Colors.black87 : Colors.white,
                          ),
                          onPressed: () => appState.toggleMedicationTaken(med.id),
                          icon: Icon(med.isTakenToday ? Icons.replay : Icons.check, size: 16),
                          label: Text(
                            med.isTakenToday
                                ? (appState.isTelugu ? 'రద్దు చేయండి' : 'Undo Taken')
                                : loc.t('mark_taken'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryRose,
        foregroundColor: Colors.white,
        onPressed: () => _showAddMedicationDialog(context, appState),
        icon: const Icon(Icons.add),
        label: Text(appState.isTelugu ? 'మందును చేర్చండి' : 'Add Medication'),
      ),
    );
  }

  void _showAddMedicationDialog(BuildContext context, AppState state) {
    final nameCtrl = TextEditingController();
    final doseCtrl = TextEditingController(text: '1 Tablet Daily');
    final strengthCtrl = TextEditingController(text: '500mg');
    final instructionCtrl = TextEditingController(text: 'Take after meals with water');
    final doctorCtrl = TextEditingController(text: 'Consultant Obstetrician');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state.isTelugu ? 'కొత్త ఔషధం నమోదు' : 'Add Prescribed Medicine',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'మందు పేరు' : 'Medicine Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: strengthCtrl,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'మోతాదు / సామర్థ్యం (Strength)' : 'Strength / Dose (e.g. 100mg)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: doseCtrl,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'ఎప్పుడు వేసుకోవాలి (Timing)' : 'Schedule (e.g. Once Daily after dinner)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: instructionCtrl,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'ఆహార నియమాలు' : 'Food Instructions',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: doctorCtrl,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'సూచించిన డాక్టర్' : 'Prescribed By',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRose),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  state.addMedication(
                    MedicationItem(
                      id: 'med_user_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      nameTe: nameCtrl.text.trim(),
                      strength: strengthCtrl.text.trim(),
                      dosageSchedule: doseCtrl.text.trim(),
                      dosageScheduleTe: doseCtrl.text.trim(),
                      foodInstructions: instructionCtrl.text.trim(),
                      foodInstructionsTe: instructionCtrl.text.trim(),
                      prescribedBy: doctorCtrl.text.trim(),
                      startDate: DateTime.now(),
                    ),
                  );
                  Navigator.of(ctx).pop();
                },
                child: Text(state.isTelugu ? 'సేవ్ చేయండి' : 'Save Medication', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
