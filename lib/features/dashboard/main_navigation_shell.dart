import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import 'home_dashboard_screen.dart';
import '../pregnancy_tracker/pregnancy_tracker_screen.dart';
import '../antenatal_care/antenatal_care_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../profile/profile_screen.dart';
import '../emergency/emergency_screen.dart';
import '../gemini_ai/gemini_assistant_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    PregnancyTrackerScreen(),
    AntenatalCareScreen(),
    NutritionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppTheme.primaryRose),
            label: loc.t('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.child_care_outlined),
            selectedIcon: const Icon(Icons.child_care, color: AppTheme.primaryRose),
            label: loc.t('nav_tracker'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.medical_services_outlined),
            selectedIcon: const Icon(Icons.medical_services, color: AppTheme.primaryRose),
            label: loc.t('nav_care'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_outlined),
            selectedIcon: const Icon(Icons.restaurant, color: AppTheme.primaryRose),
            label: loc.t('nav_nutrition'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppTheme.primaryRose),
            label: loc.t('nav_profile'),
          ),
        ],
      ),
      // Dual Floating Actions: Gemini AI & Emergency 108
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'fab_gemini',
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GeminiAssistantScreen()),
              );
            },
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text(
              appState.isTelugu ? 'జెమిని AI' : 'Gemini AI',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.extended(
            heroTag: 'fab_emergency',
            backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyScreen()),
              );
            },
            icon: const Icon(Icons.emergency),
            label: Text(
              appState.isTelugu ? '108' : '108 Emergency',
              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
