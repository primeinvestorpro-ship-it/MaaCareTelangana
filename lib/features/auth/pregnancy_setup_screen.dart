import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import '../dashboard/main_navigation_shell.dart';

class PregnancySetupScreen extends StatefulWidget {
  const PregnancySetupScreen({super.key});

  @override
  State<PregnancySetupScreen> createState() => _PregnancySetupScreenState();
}

class _PregnancySetupScreenState extends State<PregnancySetupScreen> {
  late DateTime _selectedLmp;
  late DateTime _calculatedEdd;
  bool _isHighRisk = false;
  String _selectedHospital = 'Modern Govt Maternity Hospital, Petlaburj';
  final _nameController = TextEditingController(text: 'Anitha Reddy');
  final _ashaPhoneController = TextEditingController(text: '9440567890');
  final _emergencyCaregiverController = TextEditingController(text: '9848123456');

  final List<String> _telanganaHospitals = [
    'Modern Govt Maternity Hospital, Petlaburj',
    'Niloufer Hospital for Women & Children, Hyderabad',
    'Govt Maternity Hospital, Sultan Bazaar (Koti)',
    'Gandhi Hospital (MCH Block), Secunderabad',
    'Area Hospital, Malakpet, Hyderabad',
    'MGM Hospital & MCH Center, Warangal',
    'District Hospital, Karimnagar',
    'CHC Shadnagar, Rangareddy',
  ];

  @override
  void initState() {
    super.initState();
    // Default mock: ~24 weeks pregnancy
    _selectedLmp = DateTime.now().subtract(const Duration(days: 165));
    _calculateEdd();
  }

  void _calculateEdd() {
    // Naegele's rule: LMP + 280 days (40 weeks)
    _calculatedEdd = _selectedLmp.add(const Duration(days: 280));
  }

  int get _weeks {
    final diff = DateTime.now().difference(_selectedLmp).inDays;
    return (diff / 7).floor() + 1;
  }

  int get _daysOfWeek {
    final diff = DateTime.now().difference(_selectedLmp).inDays;
    return (diff % 7) + 1;
  }

  int get _trimester {
    if (_weeks <= 12) return 1;
    if (_weeks <= 27) return 2;
    return 3;
  }

  Future<void> _pickLmpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedLmp,
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryRose,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedLmp = picked;
        _calculateEdd();
      });
    }
  }

  void _completeSetup() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updatePregnancyLmp(_selectedLmp);
    appState.updateProfile(
      name: _nameController.text.trim(),
      hospital: _selectedHospital,
      isHighRisk: _isHighRisk,
      ashaPhone: _ashaPhoneController.text.trim(),
      emergencyCaregiverPhone: _emergencyCaregiverController.text.trim(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appState.isTelugu ? 'గర్భధారణ వివరాల నమోదు' : 'Pregnancy Registration',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryRose.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryRose),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      appState.isTelugu
                          ? 'మీ చివరి ఋతుస్రావం మొదటి రోజు (LMP) నమోదు చేయడం ద్వారా ఖచ్చితమైన ప్రసవ తేదీని లెక్కిస్తాము.'
                          : 'Enter your Last Menstrual Period (LMP) to calculate your weekly milestones and estimated delivery date.',
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mother Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: appState.isTelugu ? 'తల్లి పూర్తి పేరు' : 'Mother\'s Full Name',
                prefixIcon: const Icon(Icons.person, color: AppTheme.primaryRose),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 18),

            // LMP Picker Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.isTelugu
                          ? 'చివరి ఋతుస్రావం తేదీ (LMP Date)'
                          : 'Last Menstrual Period (LMP Date)',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormat.format(_selectedLmp),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryRose,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pickLmpDate,
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(appState.isTelugu ? 'మార్చండి' : 'Change'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Calculated Output Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.secondaryTeal.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.t('estimated_edd'),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(_calculatedEdd),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryTeal,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${loc.t('trimester')} $_trimester',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            loc.t('week'),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            '$_weeks',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.black12),
                      Column(
                        children: [
                          Text(
                            loc.t('day'),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            '$_daysOfWeek',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.black12),
                      Column(
                        children: [
                          Text(
                            appState.isTelugu ? 'మిగిలిన రోజులు' : 'Days to EDD',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            '${_calculatedEdd.difference(DateTime.now()).inDays.clamp(0, 300)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryRose,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Preferred Telangana Delivery Hospital
            DropdownButtonFormField<String>(
              value: _selectedHospital,
              decoration: InputDecoration(
                labelText: appState.isTelugu
                    ? 'ప్రసవం కోసం ప్రాధాన్యత గల ప్రభుత్వ ఆసుపత్రి'
                    : 'Designated Government Delivery Facility',
                prefixIcon: const Icon(Icons.local_hospital, color: AppTheme.primaryRose),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              isExpanded: true,
              items: _telanganaHospitals.map((hosp) {
                return DropdownMenuItem(
                  value: hosp,
                  child: Text(hosp, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedHospital = val!),
            ),

            const SizedBox(height: 16),

            // High Risk Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                appState.isTelugu
                    ? 'వైద్యులు నిర్ధారించిన హై-రిస్క్ గర్భధారణ?'
                    : 'Clinician Documented High-Risk Status?',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                appState.isTelugu
                    ? 'బీపీ, షుగర్ లేదా మునుపటి సమస్యల వివరాలు'
                    : 'e.g. Hypertension, Gestational Diabetes, Multiple Pregnancy',
                style: const TextStyle(fontSize: 12),
              ),
              activeColor: AppTheme.emergencyRed,
              value: _isHighRisk,
              onChanged: (val) => setState(() => _isHighRisk = val),
            ),

            const SizedBox(height: 12),

            // Emergency Contacts
            TextField(
              controller: _ashaPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: appState.isTelugu ? 'ఆశా వర్కర్ ఫోన్ నంబర్' : 'Assigned ASHA Worker Phone',
                prefixIcon: const Icon(Icons.support_agent, color: AppTheme.secondaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _emergencyCaregiverController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: appState.isTelugu ? 'కుటుంబ అత్యవసర ఫోన్' : 'Emergency Family Caregiver Phone',
                prefixIcon: const Icon(Icons.phone_in_talk, color: AppTheme.emergencyRed),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _completeSetup,
                child: Text(
                  appState.isTelugu ? 'ప్రయాణాన్ని ప్రారంభించండి' : 'Save & Enter MaaCare',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
