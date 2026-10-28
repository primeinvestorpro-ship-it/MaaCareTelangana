class MealRecommendation {
  final String mealType; // 'Breakfast', 'Lunch', 'Snack', 'Dinner'
  final String mealTypeTe;
  final String title;
  final String titleTe;
  final List<String> foods;
  final List<String> foodsTe;
  final String keyNutrient; // 'Iron & Folate', 'Calcium & Protein', etc.
  final String telanganaTip;
  final String telanganaTipTe;

  MealRecommendation({
    required this.mealType,
    required this.mealTypeTe,
    required this.title,
    required this.titleTe,
    required this.foods,
    required this.foodsTe,
    required this.keyNutrient,
    required this.telanganaTip,
    required this.telanganaTipTe,
  });
}
