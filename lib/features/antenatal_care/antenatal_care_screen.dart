import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../core/models/appointment_model.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import '../medical_records/medical_records_screen.dart';
import '../vaccinations/vaccinations_screen.dart';
import '../medications/medications_screen.dart';

class AntenatalCareScreen extends StatelessWidget {
  const AntenatalCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            loc.t('anc_schedule'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryRose,
            labelColor: AppTheme.primaryRose,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: loc.t('upcoming_visits')),
              Tab(text: loc.t('completed_visits')),
            ],
          ),
        ),
        body: Column(
          children: [
            // Care Sub-navigation Row (Records, Vaccines, Medications)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  _buildSubTabChip(
                    context: context,
                    icon: Icons.medication,
                    label: appState.isTelugu ? 'మందులు' : 'Medications',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MedicationsScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSubTabChip(
                    context: context,
                    icon: Icons.vaccines,
                    label: appState.isTelugu ? 'టీకాలు' : 'Vaccines',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VaccinationsScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSubTabChip(
                    context: context,
                    icon: Icons.file_present,
                    label: appState.isTelugu ? 'రిపోర్టులు' : 'Lab Reports',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MedicalRecordsScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Main Tab View
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Upcoming ANC visits
                  _buildUpcomingList(context, appState, loc, dateFormat),

                  // Tab 2: Completed ANC records
                  _buildCompletedList(context, appState, loc, dateFormat),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primaryRose,
          foregroundColor: Colors.white,
          onPressed: () => _showAddAppointmentDialog(context, appState),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSubTabChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.secondaryLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: AppTheme.secondaryTeal),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryTeal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingList(
      BuildContext context, AppState state, AppLocalizations loc, DateFormat df) {
    final upcoming = state.appointments
        .where((a) => a.status == AppointmentStatus.upcoming)
        .toList();

    if (upcoming.isEmpty) {
      return Center(
        child: Text(loc.t('all_caught_up')),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcoming.length,
      itemBuilder: (context, index) {
        final appt = upcoming[index];
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ANC Visit #${appt.visitNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryRose,
                        ),
                      ),
                    ),
                    Text(
                      df.format(appt.scheduledDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  state.isTelugu ? appt.titleTe : appt.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  appt.facilityName,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  appt.doctorOrWorker,
                  style: const TextStyle(fontSize: 13, color: AppTheme.secondaryTeal),
                ),
                const SizedBox(height: 10),
                Text(
                  state.isTelugu ? appt.notesTe : appt.notes,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
                ),
                const Divider(height: 20),
                // Checklist requirements
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (appt.requiresMcpCard)
                      _buildRequirementBadge(
                        state.isTelugu ? 'MCP కార్డ్ తీసుకెళ్లండి' : 'Carry MCP Card',
                        Icons.credit_card,
                      ),
                    if (appt.requiresUltrasound)
                      _buildRequirementBadge(
                        state.isTelugu ? 'అల్ట్రాసౌండ్ స్కాన్' : 'Ultrasound Scan',
                        Icons.document_scanner,
                      ),
                    if (appt.requiresFastingBlood)
                      _buildRequirementBadge(
                        state.isTelugu ? 'పరగడుపున పరీక్ష (Fasting)' : 'Fasting Blood Sugar',
                        Icons.bloodtype,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.black45, size: 20),
                      onPressed: () {
                        state.deleteAppointment(appt.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Appointment removed')),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryTeal,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        state.markAppointmentCompleted(appt.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.isTelugu
                                ? 'వైద్య పరీక్ష పూర్తయినట్లు నమోదు చేయబడింది'
                                : 'Visit recorded as completed!'),
                            backgroundColor: AppTheme.secondaryTeal,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        state.isTelugu ? 'పూర్తయింది' : 'Mark Completed',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedList(
      BuildContext context, AppState state, AppLocalizations loc, DateFormat df) {
    final completed = state.appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completed.length,
      itemBuilder: (context, index) {
        final appt = completed[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.secondaryLight,
              child: Icon(Icons.done_all, color: AppTheme.secondaryTeal),
            ),
            title: Text(
              state.isTelugu ? appt.titleTe : appt.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appt.facilityName, style: const TextStyle(fontSize: 12)),
                Text('${df.format(appt.scheduledDate)} • ${appt.doctorOrWorker}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
            trailing: const Icon(Icons.check_circle, color: AppTheme.secondaryTeal),
          ),
        );
      },
    );
  }

  Widget _buildRequirementBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryDark),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context, AppState state) {
    final titleController = TextEditingController();
    final facilityController = TextEditingController(text: 'Modern Govt Maternity Hospital, Petlaburj');
    DateTime selectedDate = DateTime.now().add(const Duration(days: 14));

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
                state.isTelugu ? 'కొత్త ANC పరీక్ష నమోదు చేయండి' : 'Schedule New Antenatal Visit',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'పరీక్ష రకం (ఉదా: 3వ తనిఖీ)' : 'Visit Purpose',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: facilityController,
                decoration: InputDecoration(
                  labelText: state.isTelugu ? 'ఆసుపత్రి / PHC' : 'Healthcare Facility',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;
                  state.addAppointment(
                    ANCAppointment(
                      id: 'anc_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      titleTe: titleController.text.trim(),
                      visitNumber: state.appointments.length + 1,
                      scheduledDate: selectedDate,
                      facilityName: facilityController.text.trim(),
                      doctorOrWorker: 'Medical Officer / Obstetrician',
                      notes: 'Scheduled by mother / ASHA reminder.',
                      notesTe: 'షెడ్యూల్ చేయబడిన తనిఖీ.',
                    ),
                  );
                  Navigator.of(ctx).pop();
                },
                child: Text(state.isTelugu ? 'సేవ్ చేయండి' : 'Schedule Appointment'),
              ),
            ],
          ),
        );
      },
    );
  }
}
