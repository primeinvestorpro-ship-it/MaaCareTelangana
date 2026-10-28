import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/data/mock_data.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import '../emergency/emergency_screen.dart';

class PregnancyTrackerScreen extends StatelessWidget {
  const PregnancyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final selectedWeek = appState.selectedTrackerWeek;
    final weeklyData = MockDataRepository.getWeeklyMilestones()[selectedWeek] ??
        MockDataRepository.getWeeklyMilestones()[24]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appState.isTelugu ? 'గర్భధారణ వారాల ప్రయాణం' : 'Week-by-Week Journey',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Week selector horizontal strip
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 40,
              itemBuilder: (context, index) {
                final week = index + 1;
                final isSelected = week == selectedWeek;
                final isCurrent = week == appState.profile.currentWeek;

                return GestureDetector(
                  onTap: () => appState.setSelectedTrackerWeek(week),
                  child: Container(
                    width: 58,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryRose
                          : (isCurrent ? AppTheme.primaryLight : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryRose
                            : (isCurrent ? AppTheme.primaryRose : Colors.transparent),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.t('week'),
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        Text(
                          '$week',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isCurrent ? AppTheme.primaryRose : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Scrollable Weekly content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Card for Selected Week
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.child_friendly,
                                size: 36,
                                color: AppTheme.primaryRose,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${loc.t('week')} $selectedWeek',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                  Text(
                                    appState.isTelugu
                                        ? weeklyData['babySizeMetaphorTe']
                                        : weeklyData['babySizeMetaphor'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.secondaryTeal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMetricChip(
                              icon: Icons.straighten,
                              label: appState.isTelugu ? 'పొడవు' : 'Est. Length',
                              val: '${weeklyData['lengthCm']} cm',
                            ),
                            Container(width: 1, height: 30, color: Colors.grey.shade300),
                            _buildMetricChip(
                              icon: Icons.scale,
                              label: appState.isTelugu ? 'బరువు' : 'Est. Weight',
                              val: '~${weeklyData['weightG']} g',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 1. Baby Development Card
                  _buildSectionCard(
                    icon: Icons.baby_changing_station,
                    iconColor: AppTheme.primaryRose,
                    title: appState.isTelugu ? 'శిశువు ఎదుగుదల' : 'Baby\'s Development',
                    content: appState.isTelugu
                        ? weeklyData['fetalDevelopmentTe']
                        : weeklyData['fetalDevelopment'],
                  ),

                  const SizedBox(height: 12),

                  // 2. Maternal Changes & Symptoms
                  _buildSectionCard(
                    icon: Icons.favorite,
                    iconColor: Colors.deepOrange,
                    title: appState.isTelugu ? 'తల్లి శరీరంలో మార్పులు' : 'Changes in Mother\'s Body',
                    content: appState.isTelugu
                        ? weeklyData['maternalChangesTe']
                        : weeklyData['maternalChanges'],
                  ),

                  const SizedBox(height: 12),

                  // 3. Recommended Clinical Action
                  _buildSectionCard(
                    icon: Icons.check_circle,
                    iconColor: AppTheme.secondaryTeal,
                    title: appState.isTelugu ? 'వైద్య సూచనలు & చేయవలసినవి' : 'Recommended Care Action',
                    content: appState.isTelugu
                        ? weeklyData['recommendedActionTe']
                        : weeklyData['recommendedAction'],
                  ),

                  const SizedBox(height: 12),

                  // 4. Warning signs to report
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.emergencyRed.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.emergencyRed.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppTheme.emergencyRed),
                            const SizedBox(width: 8),
                            Text(
                              appState.isTelugu ? 'ఈ లక్షణాలుంటే జాగ్రత్త!' : 'Danger Warning Signs',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.emergencyRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appState.isTelugu
                              ? weeklyData['urgentWarningSignsTe']
                              : weeklyData['urgentWarningSigns'],
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.emergencyRed,
                            side: const BorderSide(color: AppTheme.emergencyRed),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                            );
                          },
                          icon: const Icon(Icons.emergency, size: 18),
                          label: Text(loc.t('emergency_title')),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Medical Governance Review Footnote
                  Center(
                    child: Text(
                      '${appState.isTelugu ? 'వైద్య సమీక్ష' : 'Clinical Content Review'}: ${weeklyData['lastReviewedBy']}',
                      style: const TextStyle(fontSize: 11, color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip({required IconData icon, required String label, required String val}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.secondaryTeal),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
