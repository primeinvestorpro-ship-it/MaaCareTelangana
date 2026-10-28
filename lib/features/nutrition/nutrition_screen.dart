import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t('nutrition_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Hydration Counter Card
            _buildHydrationCard(context, appState, loc),

            const SizedBox(height: 16),

            // Telangana Nutrition Header
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: AppTheme.primaryRose),
                const SizedBox(width: 8),
                Text(
                  loc.t('traditional_foods'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Meal Plans List (Breakfast, Lunch, Snack, Dinner)
            ...appState.dailyMeals.map((meal) {
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
                          Text(
                            appState.isTelugu ? meal.mealTypeTe : meal.mealType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRose,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              meal.keyNutrient,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        appState.isTelugu ? meal.titleTe : meal.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      // Suggested Foods
                      ...(appState.isTelugu ? meal.foodsTe : meal.foods).map((food) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  food,
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      // Telangana Local Tip
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FBF9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.secondaryTeal.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.secondaryTeal),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                appState.isTelugu ? meal.telanganaTipTe : meal.telanganaTip,
                                style: const TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 10),

            // Food Safety & Hygiene Guidelines Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sanitizer, color: AppTheme.primaryDark),
                      const SizedBox(width: 8),
                      Text(
                        loc.t('food_safety_tips'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appState.isTelugu
                        ? '1. కూరగాయలు మరియు ఆకుకూరలను ఉపయోగించే ముందు మంచినీటితో శుభ్రంగా కడగాలి.\n2. కాచిన పాలు లేదా పాశ్చరైజ్డ్ పాల ఉత్పత్తులనే వాడండి.\n3. గుడ్లు, చేపలు లేదా మాంసాహారాన్ని పచ్చిగా కాకుండా బాగా ఉడికించి మాత్రమే తినాలి.\n4. గర్భధారణ సమయంలో ఆల్కహాల్, పొగాకు మరియు అధిక కెఫిన్ పదార్థాలకు దూరంగా ఉండండి.'
                        : '1. Wash all fruits, vegetables, and leafy greens thoroughly with safe running water.\n2. Consume only pasteurized or properly boiled milk and dairy products.\n3. Ensure eggs, poultry, and fish are thoroughly and hygienically cooked.\n4. Strictly avoid alcohol, tobacco, and limit excess caffeinated beverages.',
                    style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHydrationCard(BuildContext context, AppState state, AppLocalizations loc) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.t('hydration_tracker'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${state.waterGlassesToday} / ${state.waterTargetGlasses} ${loc.t('water_glasses')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => state.decrementWater(),
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () => state.incrementWater(),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (state.waterGlassesToday / state.waterTargetGlasses).clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.blue.shade50,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 8),
            Text(
              state.isTelugu
                  ? 'రోజుకు 8-10 గ్లాసుల కాచి చల్లార్చిన నీరు త్రాగడం వల్ల మూత్రనాళ ఇన్ఫెక్షన్లు మరియు అలసట తగ్గుతాయి.'
                  : 'Drinking 8-10 glasses of safe water daily prevents dehydration, constipation, and UTIs.',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
