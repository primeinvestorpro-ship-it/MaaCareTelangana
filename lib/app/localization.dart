import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      // App Branding
      'app_name': 'MaaCare Telangana',
      'app_tagline': 'Pregnancy & Maternal Health Companion',
      'gov_initiative': 'Aligned with Telangana Health & Family Welfare Services',

      // Navigation
      'nav_home': 'Home',
      'nav_tracker': 'Journey',
      'nav_care': 'Care',
      'nav_nutrition': 'Nutrition',
      'nav_profile': 'Profile',

      // Emergency
      'emergency_title': 'Emergency & Danger Signs',
      'call_108': 'Call 108 Emergency Ambulance',
      'call_102': 'Amma Vodi (102) Transport',
      'danger_warning': 'If you experience severe pain, heavy bleeding, or difficulty breathing, call 108 immediately.',
      'emergency_action': 'Emergency 108',

      // Dashboard
      'greeting_morning': 'Good Morning',
      'greeting_afternoon': 'Good Afternoon',
      'greeting_evening': 'Good Evening',
      'week': 'Week',
      'day': 'Day',
      'trimester': 'Trimester',
      'days_to_go': 'days to delivery',
      'estimated_edd': 'Estimated Due Date (EDD)',
      'baby_development': 'Baby Development This Week',
      'next_appointment': 'Next Antenatal Checkup',
      'medicines_today': 'Prescribed Medicines Today',
      'nutrition_tip_today': 'Daily Nutrition Guidance',
      'hydration_tracker': 'Daily Hydration Tracker',
      'quick_actions': 'Quick Actions',
      'all_caught_up': 'You are completely caught up for today!',

      // Care & Appointments
      'anc_schedule': 'Antenatal Care Schedule',
      'upcoming_visits': 'Upcoming Visits',
      'completed_visits': 'Past Records',
      'mcp_card_reminder': 'Remember to carry your MCP (Mother & Child Protection) Card!',
      'doctor_notes': 'Doctor / ANM Notes',
      'facility': 'Healthcare Facility',
      'schedule_appointment': 'Schedule ANC Visit',

      // Medications
      'medications_title': 'Medications & Supplements',
      'med_ifa': 'Iron & Folic Acid (IFA)',
      'med_calcium': 'Calcium + Vitamin D3',
      'med_instructions_safety': 'Never take Iron and Calcium tablets together. Keep at least 2 hours gap.',
      'mark_taken': 'Mark as Taken',
      'taken': 'Taken',
      'missed_dose_warning': 'If you missed a dose, do not take a double dose. Consult your doctor or ANM.',

      // Vaccinations
      'vaccination_title': 'Vaccination & Immunisation',
      'maternal_vaccines': 'Maternal Vaccines (Td)',
      'baby_immunisation': 'Baby Immunisation Schedule',
      'completed': 'Completed',
      'due_soon': 'Due Soon',

      // Nutrition
      'nutrition_title': 'Telangana Nutrition & Diet',
      'traditional_foods': 'Traditional & Nutritious Telangana Foods',
      'water_glasses': 'Glasses of Safe Water Today',
      'food_safety_tips': 'Food Safety & Hygiene',

      // Hospitals
      'hospitals_title': 'Government Hospitals & UPHCs',
      'search_hospitals': 'Search PHCs, UPHCs, Area & District Hospitals...',
      'all_districts': 'All Districts',
      'delivery_available': '24/7 Delivery Available',
      'c_section_available': 'C-Section OT Available',
      'special_maternal_care': 'SNCU / High Risk Referral',

      // Profile & Settings
      'language_switch': 'Language / భాష',
      'current_language': 'English',
      'change_to_telugu': 'తెలుగులోకి మార్చండి (Telugu)',
      'asha_worker_contact': 'ASHA / ANM Worker Contact',
      'emergency_caregiver': 'Family Emergency Contact',
      'privacy_policy': 'Data Privacy & Clinical Governance',
      'clinical_disclaimer': 'Clinical Disclaimer: MaaCare Telangana is an educational and tracking companion. It does not replace medical advice, diagnosis or treatment from a qualified healthcare provider.',
    },
    'te': {
      // App Branding
      'app_name': 'మాకేర్ తెలంగాణ',
      'app_tagline': 'గర్భధారణ & మాతృత్వ ఆరోగ్య సహచరి',
      'gov_initiative': 'తెలంగాణ వైద్య మరియు కుటుంబ సంక్షేమ శాఖకు అనుబంధం',

      // Navigation
      'nav_home': 'హోమ్',
      'nav_tracker': 'ప్రయాణం',
      'nav_care': 'వైద్య సంరక్షణ',
      'nav_nutrition': 'పోషకాహారం',
      'nav_profile': 'ప్రొఫైల్',

      // Emergency
      'emergency_title': 'అత్యవసర హెచ్చరికలు & ప్రమాద సూచనలు',
      'call_108': '108 అత్యవసర అంబులెన్స్ కాల్ చేయండి',
      'call_102': 'అమ్మ ఒడి (102) వాహన సేవలు',
      'danger_warning': 'తీవ్రమైన కడుపు నొప్పి, రక్తస్రావం లేదా శ్వాస తీసుకోవడంలో ఇబ్బంది ఉంటే వెంటనే 108 కు కాల్ చేయండి.',
      'emergency_action': 'అత్యవసరం 108',

      // Dashboard
      'greeting_morning': 'శుభోదయం',
      'greeting_afternoon': 'శుభ మధ్యాహ్నం',
      'greeting_evening': 'శుభ సాయంత్రం',
      'week': 'వారం',
      'day': 'రోజు',
      'trimester': 'త్రైమాసికం',
      'days_to_go': 'ప్రసవానికి మిగిలిన రోజులు',
      'estimated_edd': 'అంచనా వేసిన ప్రసవ తేదీ (EDD)',
      'baby_development': 'ఈ వారం శిశువు ఎదుగుదల',
      'next_appointment': 'తదుపరి వైద్య పరీక్ష (ANC)',
      'medicines_today': 'ఈ రోజు వేసుకోవలసిన మందులు',
      'nutrition_tip_today': 'రోజువారీ పోషకాహార సూచన',
      'hydration_tracker': 'త్రాగునీటి లెక్కింపు',
      'quick_actions': 'త్వరిత సేవలు',
      'all_caught_up': 'ఈ రోజుకు అన్ని పనులు పూర్తయ్యాయి!',

      // Care & Appointments
      'anc_schedule': 'గర్భిణీ వైద్య పరీక్షల షెడ్యూల్',
      'upcoming_visits': 'రాబోయే వైద్య పరీక్షలు',
      'completed_visits': 'గత రికార్డులు',
      'mcp_card_reminder': 'ఆసుపత్రికి వెళ్ళేటప్పుడు తప్పనిసరిగా మీ MCP కార్డ్ (తల్లి మరియు పిల్లల కార్డు) తీసుకెళ్లండి!',
      'doctor_notes': 'డాక్టర్ / ANM సూచనలు',
      'facility': 'ఆసుపత్రి కేంద్రం',
      'schedule_appointment': 'వైద్య పరీక్ష నమోదు చేయండి',

      // Medications
      'medications_title': 'మందులు & అనుబంధ పోషకాలు',
      'med_ifa': 'ఐరన్ & ఫోలిక్ యాసిడ్ (IFA)',
      'med_calcium': 'కాల్షియం + విటమిన్ D3',
      'med_instructions_safety': 'ఐరన్ మరియు కాల్షియం మాత్రలను ఒకేసారి వేసుకోకూడదు. కనీసం 2 గంటల వ్యవధి ఉండాలి.',
      'mark_taken': 'వేసుకున్నాను',
      'taken': 'పూర్తయింది',
      'missed_dose_warning': 'మందు వేసుకోవడం మర్చిపోతే, తర్వాతి సారి ఒకేసారి రెండు మాత్రలు వేసుకోకండి. డాక్టర్‌ని సంప్రదించండి.',

      // Vaccinations
      'vaccination_title': 'టీకాలు & రోగనిరోధక రికార్డులు',
      'maternal_vaccines': 'తల్లి టీకాలు (Td టెటానస్)',
      'baby_immunisation': 'శిశువు రోగనిరోధక టీకాల షెడ్యూల్',
      'completed': 'పూర్తయింది',
      'due_soon': 'త్వరలో తీసుకోవాలి',

      // Nutrition
      'nutrition_title': 'తెలంగాణ పోషకాహార మార్గదర్శి',
      'traditional_foods': 'సాంప్రదాయ బలవర్థకమైన తెలంగాణ ఆహారాలు',
      'water_glasses': 'ఈ రోజు త్రాగిన గ్లాసుల నీరు',
      'food_safety_tips': 'ఆహార శుభ్రత & రక్షణ సూచనలు',

      // Hospitals
      'hospitals_title': 'ప్రభుత్వ ఆసుపత్రులు & UPHCలు',
      'search_hospitals': 'PHC, UPHC, ఏరియా మరియు జిల్లా ఆసుపత్రుల కోసం శోధించండి...',
      'all_districts': 'అన్ని జిల్లాలు',
      'delivery_available': '24/7 ప్రసవ సౌకర్యం కలదు',
      'c_section_available': 'సి-సెక్షన్ ఆపరేషన్ థియేటర్ కలదు',
      'special_maternal_care': 'SNCU / హై-రిస్క్ ప్రత్యేక చికిత్స',

      // Profile & Settings
      'language_switch': 'భాష / Language',
      'current_language': 'తెలుగు',
      'change_to_telugu': 'Switch to English',
      'asha_worker_contact': 'ఆశా వర్కర్ / ANM సమాచారం',
      'emergency_caregiver': 'కుటుంబ అత్యవసర కాంటాక్ట్',
      'privacy_policy': 'డేటా గోప్యత & నిబంధనలు',
      'clinical_disclaimer': 'వైద్య నిరాకరణ: మాకేర్ తెలంగాణ ఒక విద్యా మరియు ఆరోగ్య పర్యవేక్షణ యాప్ మాత్రమే. ఇది అర్హత కలిగిన డాక్టర్ లేదా వైద్య సిబ్బంది ప్రత్యక్ష సలహాకు ప్రత్యామ్నాయం కాదు.',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'te'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
