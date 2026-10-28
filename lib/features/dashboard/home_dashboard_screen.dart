import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../core/data/mock_data.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import '../hospitals/hospitals_screen.dart';
import '../medications/medications_screen.dart';
import '../medical_records/medical_records_screen.dart';
import '../vaccinations/vaccinations_screen.dart';
import '../delivery_postnatal/delivery_postnatal_screen.dart';
import '../gemini_ai/gemini_assistant_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final profile = appState.profile;
    final dateFormat = DateFormat('dd MMM yyyy');
    final weeklyInfo = MockDataRepository.getWeeklyMilestones()[profile.currentWeek] ??
        MockDataRepository.getWeeklyMilestones()[24]!;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.t('app_name'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              '${loc.t('greeting_morning')}, ${profile.motherName}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          // Language switcher button
          TextButton.icon(
            onPressed: () => appState.toggleLanguage(),
            icon: const Icon(Icons.translate, size: 18, color: AppTheme.primaryRose),
            label: Text(
              appState.isTelugu ? 'English' : 'తెలుగు',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryRose),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Mock refresh
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 0. Active Popup Reminders (Fluids & Medicines)
              if (!appState.hasDismissedFluidReminder && appState.waterGlassesToday < 8)
                _buildFluidReminderCard(context, appState),

              if (!appState.hasDismissedMedReminder && appState.pendingMedicationsToday.isNotEmpty)
                _buildMedicationReminderCard(context, appState),

              // Gemini AI Quick Assistant Banner
              _buildGeminiAiBanner(context, appState),

              const SizedBox(height: 12),

              // 1. Pregnancy Hero Banner
              _buildPregnancyHeroCard(context, appState, loc, dateFormat),

              const SizedBox(height: 14),

              // 2. Baby Growth & Metaphor Card
              _buildBabySnapshotCard(context, appState, loc, weeklyInfo),

              const SizedBox(height: 14),

              // 3. Next Antenatal Appointment Card
              _buildNextAppointmentCard(context, appState, loc, dateFormat),

              const SizedBox(height: 14),

              // 4. Prescribed Medicines Today
              _buildTodayMedicationsCard(context, appState, loc),

              const SizedBox(height: 14),

              // 5. Telangana Nutrition & Hydration Snapshot
              _buildNutritionHydrationCard(context, appState, loc),

              const SizedBox(height: 14),

              // 6. Quick Action Navigation Grid
              _buildQuickActionsGrid(context, appState, loc),

              const SizedBox(height: 16),

              // 7. Telangana Health Emergency & Schemes Info Footer
              _buildGovernmentBanner(context, appState, loc),

              const SizedBox(height: 60), // Spacing for FAB
            ],
          ),
        ),
      ),
    );
  }

  // --- Subcomponents ---

  Widget _buildFluidReminderCard(BuildContext context, AppState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isTelugu ? '💧 మంచినీరు త్రాగాల్సిన సమయం!' : '💧 Hydration Reminder!',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent),
                ),
                Text(
                  state.isTelugu
                      ? 'ఉమ్మనీరు సరిపడా ఉండటానికి, అలసట తగ్గడానికి ఒక గ్లాస్ నీరు త్రాగండి.'
                      : 'Drink a glass of water now to maintain amniotic fluid and prevent cramps.',
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 0,
            ),
            onPressed: () {
              state.incrementWater();
              state.dismissFluidReminder();
            },
            child: Text(state.isTelugu ? '+1 గ్లాస్' : '+1 Glass', style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.black45),
            onPressed: () => state.dismissFluidReminder(),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationReminderCard(BuildContext context, AppState state) {
    final pending = state.pendingMedicationsToday;
    final first = pending.first;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm, color: Colors.deepOrange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isTelugu ? '💊 మందులు వేసుకోవాల్సిన సమయం!' : '💊 Medicine Dose Reminder!',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepOrange),
                ),
                Text(
                  state.isTelugu
                      ? '${first.nameTe} (${first.dosageScheduleTe}) మిగిలి ఉంది.'
                      : '${first.name} (${first.dosageSchedule}) is due today.',
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 0,
            ),
            onPressed: () {
              state.toggleMedicationTaken(first.id);
              state.dismissMedReminder();
            },
            child: Text(state.isTelugu ? 'వేసుకున్నాను' : 'Taken', style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.black45),
            onPressed: () => state.dismissMedReminder(),
          ),
        ],
      ),
    );
  }

  Widget _buildGeminiAiBanner(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFD81B60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state.isTelugu ? 'MaaCare జెమిని AI మాతృత్వ సలహాదారు' : 'MaaCare Gemini AI Maternal Advisor',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            state.isTelugu
                ? 'రిపోర్టుల విశ్లేషణ, ప్రిస్క్రిప్షన్ ఫోటో స్కాన్, గర్భస్రావం నివారణ, ప్రయాణ జాగ్రత్తలు, తినకూడని ఆహారాలు, మరియు పాతకాలపు అమ్మమ్మల చిట్కాలు.'
                : 'Analyze reports, scan prescription photos, avoid miscarriage, travel rules, foods to avoid, and Granny\'s ancient remedies.',
            style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6A1B9A),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GeminiAssistantScreen()),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: Text(
                    state.isTelugu ? 'జెమిని AI ని అడగండి' : 'Ask Gemini AI',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GeminiAssistantScreen(
                        initialTopic: 'Natural remedies and courage followed by grandmothers in olden days for pregnancy',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.elderly_woman, size: 16),
                label: Text(
                  state.isTelugu ? 'అమ్మమ్మ మాట' : 'Granny\'s Wisdom',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyHeroCard(
      BuildContext context, AppState state, AppLocalizations loc, DateFormat df) {
    final profile = state.profile;
    final progress = (profile.gestationalDays / 280).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryRose, Color(0xFFC2185B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRose.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${loc.t('trimester')} ${profile.trimester}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              if (profile.isHighRisk)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade800,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        state.isTelugu ? 'హై-రిస్క్ గర్భధారణ' : 'High-Risk Care',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${loc.t('week')} ${profile.currentWeek}, ${loc.t('day')} ${profile.currentDayOfWeek}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${loc.t('estimated_edd')}: ${df.format(profile.estimatedDueDate)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.daysUntilEdd} ${loc.t('days_to_go')}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Circular progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBabySnapshotCard(
      BuildContext context, AppState state, AppLocalizations loc, Map<String, dynamic> info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.spa, color: AppTheme.secondaryTeal, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.t('baby_development'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        state.isTelugu ? info['babySizeMetaphorTe'] : info['babySizeMetaphor'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.secondaryTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '~${info['weightG']} g',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      '${info['lengthCm']} cm',
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              state.isTelugu ? info['fetalDevelopmentTe'] : info['fetalDevelopment'],
              style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextAppointmentCard(
      BuildContext context, AppState state, AppLocalizations loc, DateFormat df) {
    final next = state.nextUpcomingAppointment;
    if (next == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppTheme.secondaryTeal),
              const SizedBox(width: 12),
              Expanded(child: Text(loc.t('all_caught_up'))),
            ],
          ),
        ),
      );
    }

    final daysRemaining = next.scheduledDate.difference(DateTime.now()).inDays;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month, color: AppTheme.primaryRose, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.t('next_appointment'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    daysRemaining <= 0
                        ? (state.isTelugu ? 'ఈ రోజు' : 'Today')
                        : (state.isTelugu ? '$daysRemaining రోజుల్లో' : 'In $daysRemaining days'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryRose,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              state.isTelugu ? next.titleTe : next.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    next.facilityName,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  df.format(next.scheduledDate),
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
            const Divider(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.assignment, size: 16, color: Color(0xFFB78103)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      loc.t('mcp_card_reminder'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMedicationsCard(BuildContext context, AppState state, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medication, color: AppTheme.secondaryTeal, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loc.t('medicines_today'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MedicationsScreen()),
                    );
                  },
                  child: Text(
                    state.isTelugu ? 'అన్నీ చూడండి' : 'View All',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            ...state.medications.map((med) {
              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: med.isTakenToday
                      ? AppTheme.secondaryLight.withOpacity(0.5)
                      : const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: med.isTakenToday ? AppTheme.secondaryTeal : Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.isTelugu ? med.nameTe : med.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              decoration:
                                  med.isTakenToday ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          Text(
                            med.strength,
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            state.isTelugu ? med.dosageScheduleTe : med.dosageSchedule,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: med.isTakenToday ? Colors.grey.shade400 : AppTheme.secondaryTeal,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 0,
                      ),
                      onPressed: () => state.toggleMedicationTaken(med.id),
                      child: Text(
                        med.isTakenToday ? loc.t('taken') : loc.t('mark_taken'),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionHydrationCard(BuildContext context, AppState state, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.t('hydration_tracker'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.waterGlassesToday} / ${state.waterTargetGlasses} ${loc.t('water_glasses')}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (state.waterGlassesToday / state.waterTargetGlasses).clamp(0.0, 1.0),
                        backgroundColor: Colors.blue.shade50,
                        color: Colors.blueAccent,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                IconButton.filledTonal(
                  onPressed: () => state.decrementWater(),
                  icon: const Icon(Icons.remove, size: 18),
                ),
                IconButton.filled(
                  onPressed: () => state.incrementWater(),
                  icon: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, AppState state, AppLocalizations loc) {
    final actions = [
      {
        'title': state.isTelugu ? 'ఆసుపత్రులు' : 'Hospitals',
        'icon': Icons.local_hospital,
        'color': AppTheme.primaryRose,
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HospitalsScreen()),
            ),
      },
      {
        'title': state.isTelugu ? 'వైద్య రికార్డులు' : 'Lab Reports',
        'icon': Icons.description,
        'color': AppTheme.secondaryTeal,
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MedicalRecordsScreen()),
            ),
      },
      {
        'title': state.isTelugu ? 'టీకాల వివరాలు' : 'Vaccinations',
        'icon': Icons.vaccines,
        'color': Colors.indigo,
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VaccinationsScreen()),
            ),
      },
      {
        'title': state.isTelugu ? 'ప్రసవ సంచి' : 'Hospital Bag',
        'icon': Icons.luggage,
        'color': Colors.deepOrange,
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DeliveryPostnatalScreen()),
            ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.t('quick_actions'),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final a = actions[index];
            return InkWell(
              onTap: a['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (a['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        a['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGovernmentBanner(BuildContext context, AppState state, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppTheme.secondaryTeal, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.isTelugu
                      ? 'తెలంగాణ ప్రభుత్వ ఉచిత మాతృత్వ సేవలు'
                      : 'Telangana Public Maternal Healthcare Services',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            state.isTelugu
                ? '• అన్ని ప్రభుత్వ ఆసుపత్రులలో ఉచిత కాన్పు, మందులు మరియు పోషకాహారం.\n• ప్రసవం తర్వాత అమ్మ ఒడి (102) వాహనంలో ఉచితంగా ఇంటికి చేరవేస్తారు.'
                : '• Free delivery, medicines and diagnostic ultrasound in all Government Hospitals.\n• Amma Vodi (102) provides free pickup and drop back home after delivery.',
            style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
