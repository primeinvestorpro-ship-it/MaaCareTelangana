import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../core/services/gemini_service.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import '../auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final profile = appState.profile;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t('nav_profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      profile.motherName.isNotEmpty ? profile.motherName[0] : 'M',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryRose,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile.motherName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '+91 ${profile.phoneNumber}',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Language Selector Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.language, color: AppTheme.primaryRose),
                title: Text(loc.t('language_switch')),
                subtitle: Text(
                  appState.isTelugu ? 'ప్రస్తుత భాష: తెలుగు' : 'Current Language: English',
                ),
                trailing: TextButton(
                  onPressed: () => appState.toggleLanguage(),
                  child: Text(
                    appState.isTelugu ? 'English' : 'తెలుగు',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryRose),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Real Data & Demo Data Mode Switch Card
            Card(
              color: const Color(0xFFF0FDF4),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storage, color: AppTheme.secondaryTeal, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          appState.isTelugu ? 'రియల్ డేటా నిర్వహణ' : 'Real Data & Demo Settings',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.secondaryTeal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appState.isTelugu
                          ? 'డెమో డేటాను తొలగించి మీ అసలైన గర్భధారణ వివరాలు, వైద్య రికార్డులు, మందులను సులభంగా నమోదు చేసుకోండి.'
                          : 'Clear mock data to enter your real pregnancy records, lab reports, and doctor prescriptions.',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryTeal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () => _showClearDataConfirmation(context, appState),
                            icon: const Icon(Icons.cleaning_services, size: 16),
                            label: Text(
                              appState.isTelugu ? 'డెమో డేటా తీసివేయండి' : 'Clear Demo Data',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            appState.resetToDemoData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Demo data restored')),
                            );
                          },
                          child: Text(appState.isTelugu ? 'డెమో పునరుద్ధరించు' : 'Restore Demo', style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Gemini AI Key Setting Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.auto_awesome, color: Colors.purple),
                title: const Text('Google Gemini AI Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(
                  GeminiService.apiKey.isNotEmpty ? 'API Key: Active (Live AI analysis enabled)' : 'Using built-in maternal reasoning engine',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: TextButton(
                  onPressed: () => _showApiKeyDialog(context),
                  child: const Text('Configure'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Pregnancy Record Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appState.isTelugu ? 'గర్భధారణ వివరాలు' : 'Pregnancy Summary',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextButton.icon(
                          onPressed: () => _showEditProfileDialog(context, appState),
                          icon: const Icon(Icons.edit, size: 16, color: AppTheme.primaryRose),
                          label: Text(appState.isTelugu ? 'సవరించండి' : 'Edit Real Data'),
                        ),
                      ],
                    ),
                    const Divider(height: 18),
                    _buildDetailRow(
                      appState.isTelugu ? 'చివరి ఋతుస్రావం (LMP)' : 'LMP Date',
                      dateFormat.format(profile.lmpDate),
                    ),
                    _buildDetailRow(
                      loc.t('estimated_edd'),
                      dateFormat.format(profile.estimatedDueDate),
                    ),
                    _buildDetailRow(
                      appState.isTelugu ? 'ప్రస్తుత దశ' : 'Current Stage',
                      '${loc.t('week')} ${profile.currentWeek}, ${loc.t('trimester')} ${profile.trimester}',
                    ),
                    _buildDetailRow(
                      appState.isTelugu ? 'బ్లడ్ గ్రూప్' : 'Blood Group',
                      profile.bloodGroup,
                    ),
                    _buildDetailRow(
                      appState.isTelugu ? 'ఎంచుకున్న ఆసుపత్రి' : 'Designated Hospital',
                      profile.preferredHospital,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Contacts Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.isTelugu ? 'ముఖ్యమైన కాంటాక్ట్‌లు' : 'Emergency & Health Contacts',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Divider(height: 18),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.secondaryLight,
                        child: Icon(Icons.support_agent, color: AppTheme.secondaryTeal),
                      ),
                      title: Text(profile.ashaWorkerName),
                      subtitle: Text('${loc.t('asha_worker_contact')}: ${profile.ashaWorkerPhone}'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFFEBEE),
                        child: Icon(Icons.emergency, color: AppTheme.emergencyRed),
                      ),
                      title: Text(loc.t('emergency_caregiver')),
                      subtitle: Text(profile.emergencyCaregiverPhone),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Clinical Disclaimer (Mandatory PRD Section 10.4)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        appState.isTelugu ? 'చట్టబద్ధమైన మరియు వైద్య నిరాకరణ' : 'Clinical Governance Disclaimer',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loc.t('clinical_disclaimer'),
                    style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Version: 1.0.0 (Telangana Public Health Edition) • Aligned with MoHFW & Telangana Health Guidelines.',
                    style: TextStyle(fontSize: 10, color: Colors.black45),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.emergencyRed,
                side: const BorderSide(color: AppTheme.emergencyRed),
              ),
              onPressed: () {
                appState.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: Text(appState.isTelugu ? 'లాగౌట్ అవ్వండి' : 'Log Out Securely'),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _showClearDataConfirmation(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(state.isTelugu ? 'డెమో డేటాను తొలగించాలా?' : 'Clear Demo Records?'),
        content: Text(
          state.isTelugu
              ? 'డెమో రికార్డులన్నీ తొలగించబడతాయి, మరియు మీ అసలైన వివరాలను నమోదు చేయడానికి ఖాళీ ప్రొఫైల్ ప్రారంభించబడుతుంది.'
              : 'All mock demonstration records will be cleared so you can enter your real pregnancy records from scratch.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emergencyRed),
            onPressed: () {
              state.clearDemoData();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.isTelugu ? 'డెమో డేటా తొలగించబడింది! మీ అసలైన వివరాలను నమోదు చేయండి.' : 'Demo data cleared! You can now enter your real details.'),
                  backgroundColor: AppTheme.secondaryTeal,
                ),
              );
            },
            child: Text(state.isTelugu ? 'తొలగించు' : 'Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AppState state) {
    final nameCtrl = TextEditingController(text: state.profile.motherName);
    final phoneCtrl = TextEditingController(text: state.profile.phoneNumber);
    final hospitalCtrl = TextEditingController(text: state.profile.preferredHospital);
    final bloodCtrl = TextEditingController(text: state.profile.bloodGroup);
    final ashaCtrl = TextEditingController(text: state.profile.ashaWorkerPhone);
    final emergencyCtrl = TextEditingController(text: state.profile.emergencyCaregiverPhone);
    bool isHighRisk = state.profile.isHighRisk;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
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
                  state.isTelugu ? 'అసలైన వివరాలను సవరించండి' : 'Edit Real Pregnancy Details',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'తల్లి పూర్తి పేరు' : 'Mother\'s Name',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'మొబైల్ నంబర్' : 'Mobile Number',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hospitalCtrl,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'ప్రభుత్వ ఆసుపత్రి / PHC' : 'Hospital / PHC',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bloodCtrl,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'బ్లడ్ గ్రూప్ (ఉదా: B+, O+)' : 'Blood Group (e.g. B+, O+)',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ashaCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'ఆశా వర్కర్ ఫోన్' : 'ASHA Worker Phone',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emergencyCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: state.isTelugu ? 'కుటుంబ అత్యవసర ఫోన్' : 'Emergency Contact Phone',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(state.isTelugu ? 'హై-రిస్క్ గర్భధారణ?' : 'High Risk Status?'),
                  value: isHighRisk,
                  onChanged: (val) => setModalState(() => isHighRisk = val),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRose),
                  onPressed: () {
                    state.updateProfile(
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      hospital: hospitalCtrl.text.trim(),
                      bloodGroup: bloodCtrl.text.trim(),
                      ashaPhone: ashaCtrl.text.trim(),
                      emergencyCaregiverPhone: emergencyCtrl.text.trim(),
                      isHighRisk: isHighRisk,
                    );
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.isTelugu ? 'వివరాలు నవీకరించబడ్డాయి!' : 'Profile updated successfully!')),
                    );
                  },
                  child: Text(state.isTelugu ? 'సేవ్ చేయండి' : 'Save Details', style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: GeminiService.apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Google Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your Google Gemini API Key to enable live multimodal scanning and AI generation. Leave empty to use built-in clinical intelligence.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              GeminiService.setApiKey(controller.text.trim());
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gemini API Key configured!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
