import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final profile = appState.profile;

    final dangerSigns = [
      {
        'title': 'Vaginal Bleeding',
        'titleTe': 'యోని నుండి రక్తస్రావం కావడం',
        'desc': 'Any fresh bright red bleeding or spotting in pregnancy requires emergency assessment.',
        'descTe': 'గర్భధారణ సమయంలో ఏ విధమైన రక్తస్రావం జరిగినా వెంటనే వైద్య సహాయం అవసరం.',
      },
      {
        'title': 'Water Bag Breakage (Leakage of Fluid)',
        'titleTe': 'ఉమ్మనీరు లీకేజ్ లేదా కారడం',
        'desc': 'Sudden gush or continuous clear trickle of watery fluid from the vagina.',
        'descTe': 'ఉమ్మనీరు లీక్ అయితే ఇన్ఫెక్షన్ సోకే ప్రమాదం ఉన్నందున తక్షణమే ఆసుపత్రికి వెళ్ళాలి.',
      },
      {
        'title': 'Severe Continuous Abdominal Pain',
        'titleTe': 'తీవ్రమైన, ఆగని కడుపు నొప్పి',
        'desc': 'Sharp or constant severe pain in lower abdomen, different from routine mild stretching.',
        'descTe': 'సాధారణ తేలికపాటి నొప్పి కాకుండా విపరీతమైన నొప్పి ఉండటం.',
      },
      {
        'title': 'Severe Headache, Blurring Vision or Facial Swelling',
        'titleTe': 'తీవ్రమైన తలనొప్పి, కళ్ళు తిరగడం లేదా ముఖంలో వాపు',
        'desc': 'Warning signs of dangerous high blood pressure (Pre-eclampsia / Eclampsia).',
        'descTe': 'అధిక రక్తపోటు (బీపీ) కారణంగా ఫిట్స్ వచ్చే ప్రమాద సూచన.',
      },
      {
        'title': 'Markedly Reduced or Absent Baby Movements',
        'titleTe': 'శిశువు కదలికలు బాగా తగ్గడం లేదా ఆగడం',
        'desc': 'Noticeable decrease in baby kicks after week 24 requires immediate fetal monitoring.',
        'descTe': '24వ వారం దాటిన తర్వాత కడుపులో శిశువు కదలికలు మందగిస్తే ఆలస్యం చేయకండి.',
      },
      {
        'title': 'Convulsions or Loss of Consciousness',
        'titleTe': 'మూర్ఛ (ఫిట్స్) రావడం లేదా స్పృహ తప్పడం',
        'desc': 'Critical obstetrical emergency. Lay mother on her left side and call 108 instantly.',
        'descTe': 'అత్యంత ప్రమాదకరం. తల్లిని ఎడమవైపునకు పడుకోబెట్టి వెంటనే 108 కు కాల్ చేయండి.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F5),
      appBar: AppBar(
        backgroundColor: AppTheme.emergencyRed,
        foregroundColor: Colors.white,
        title: Text(
          loc.t('emergency_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Massive 108 Ambulance Call Button
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.emergencyRed.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: AppTheme.emergencyRed.withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emergency_share, size: 48, color: AppTheme.emergencyRed),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('call_108'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.emergencyRed,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appState.isTelugu
                        ? 'తెలంగాణ ఉచిత 24x7 ఎమర్జెన్సీ అంబులెన్స్ సేవ'
                        : 'Telangana Free 24x7 Emergency Ambulance',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed,
                        foregroundColor: Colors.white,
                        elevation: 3,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calling Telangana 108 Emergency Ambulance...'),
                            backgroundColor: AppTheme.emergencyRed,
                          ),
                        );
                      },
                      icon: const Icon(Icons.call, size: 24),
                      label: const Text(
                        'CALL 108 NOW',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Secondary: Amma Vodi 102
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.secondaryTeal,
                        side: const BorderSide(color: AppTheme.secondaryTeal, width: 1.5),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calling Amma Vodi 102 Maternal Transport...'),
                            backgroundColor: AppTheme.secondaryTeal,
                          ),
                        );
                      },
                      icon: const Icon(Icons.airport_shuttle),
                      label: Text(
                        loc.t('call_102'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Urgent Instructions Checklist
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appState.isTelugu
                        ? 'వైద్య బృందానికి చెప్పవలసిన ముఖ్యమైన వివరాలు:'
                        : 'Information to tell the 108 Medical Team:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• ${appState.isTelugu ? 'తల్లి పేరు' : 'Mother Name'}: ${profile.motherName} (Ph: ${profile.phoneNumber})\n'
                    '• ${appState.isTelugu ? 'గర్భధారణ వారం' : 'Gestational Age'}: Week ${profile.currentWeek} (${loc.t('trimester')} ${profile.trimester})\n'
                    '• ${appState.isTelugu ? 'రక్త వర్గం' : 'Blood Group'}: ${profile.bloodGroup}\n'
                    '• ${appState.isTelugu ? 'ఆసుపత్రి' : 'Designated Hospital'}: ${profile.preferredHospital}\n'
                    '• ${appState.isTelugu ? 'ముఖ్యమైనది' : 'Important'}: Carry your physical MCP Card and Aadhaar card immediately!',
                    style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Danger Signs Section
            Text(
              appState.isTelugu ? 'ప్రమాదకర లక్షణాలు (వెంటనే గమనించండి)' : 'Danger Warning Signs to Watch',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...dangerSigns.map((sign) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning, color: AppTheme.emergencyRed, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.isTelugu ? sign['titleTe']! : sign['title']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.emergencyRed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appState.isTelugu ? sign['descTe']! : sign['desc']!,
                              style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
