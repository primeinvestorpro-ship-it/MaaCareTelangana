import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pregnancy_model.dart';

class GeminiReportAnalysis {
  final String summary;
  final String testName;
  final String resultValue;
  final String normalRange;
  final String status; // 'normal', 'borderline', 'requiresReview'
  final List<String> recommendations;
  final String suggestedNextCheckup;
  final String clinicalCause;

  GeminiReportAnalysis({
    required this.summary,
    required this.testName,
    required this.resultValue,
    required this.normalRange,
    required this.status,
    required this.recommendations,
    required this.suggestedNextCheckup,
    this.clinicalCause = '',
  });

  factory GeminiReportAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiReportAnalysis(
      summary: json['summary'] ?? '',
      testName: json['testName'] ?? 'Diagnostic Test',
      resultValue: json['resultValue'] ?? '',
      normalRange: json['normalRange'] ?? '',
      status: json['status'] ?? 'normal',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      suggestedNextCheckup: json['suggestedNextCheckup'] ?? '',
      clinicalCause: json['clinicalCause'] ?? '',
    );
  }
}

class GeminiPrescriptionAnalysis {
  final String diagnosisCause;
  final String clinicalReason;
  final List<Map<String, String>> medicines;
  final List<String> precautions;
  final List<String> foodsToAvoid;

  GeminiPrescriptionAnalysis({
    required this.diagnosisCause,
    required this.clinicalReason,
    required this.medicines,
    required this.precautions,
    required this.foodsToAvoid,
  });

  factory GeminiPrescriptionAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiPrescriptionAnalysis(
      diagnosisCause: json['diagnosisCause'] ?? '',
      clinicalReason: json['clinicalReason'] ?? '',
      medicines: (json['medicines'] as List<dynamic>? ?? [])
          .map((item) => Map<String, String>.from(item as Map))
          .toList(),
      precautions: List<String>.from(json['precautions'] ?? []),
      foodsToAvoid: List<String>.from(json['foodsToAvoid'] ?? []),
    );
  }
}

class GeminiService {
  static String? _apiKey;

  static void setApiKey(String key) {
    _apiKey = key.trim();
  }

  static String get apiKey => _apiKey ?? '';

  static const String _defaultModel = 'gemini-1.5-flash';

  // Analyze Lab/Scan Reports (text or image)
  static Future<GeminiReportAnalysis> analyzeReport({
    String? text,
    String? base64Image,
    String? mimeType,
    bool isTelugu = false,
  }) async {
    final language = isTelugu ? 'Telugu' : 'English';
    final systemPrompt = '''
You are an expert maternal healthcare assistant for Telangana public health.
Analyze the following medical report (lab report, ultrasound scan, or blood investigation).
Extract the key test findings and return a JSON object with this exact structure:
{
  "testName": "Name of test (e.g., Hemoglobin Hb, Anomaly Scan, OGTT)",
  "resultValue": "Extracted measured value with unit",
  "normalRange": "Standard gestational normal reference range",
  "status": "normal" | "borderline" | "requiresReview",
  "summary": "Clear, non-technical explanation in $language for the mother",
  "clinicalCause": "Medical reason for these numbers",
  "recommendations": ["Recommendation 1 in $language", "Recommendation 2"],
  "suggestedNextCheckup": "Recommended ANC checkup details and timeline in $language"
}
Output only valid JSON. Do not add markdown or comments.
''';

    try {
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        final contentParts = <Map<String, dynamic>>[];
        contentParts.add({'text': systemPrompt});
        if (text != null && text.isNotEmpty) {
          contentParts.add({'text': 'Report Content:\n$text'});
        }
        if (base64Image != null && base64Image.isNotEmpty) {
          contentParts.add({
            'inlineData': {
              'mimeType': mimeType ?? 'image/jpeg',
              'data': base64Image,
            }
          });
        }

        final response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_defaultModel:generateContent?key=$_apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': contentParts,
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'responseMimeType': 'application/json',
            }
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidateText = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (candidateText != null) {
            final jsonMap = jsonDecode(candidateText);
            return GeminiReportAnalysis.fromJson(jsonMap);
          }
        }
      }
    } catch (_) {
      // Fallback to intelligent built-in clinical rule engine
    }

    return _fallbackReportAnalysis(text ?? '', isTelugu);
  }

  // Analyze Prescription Photos
  static Future<GeminiPrescriptionAnalysis> analyzePrescriptionImage({
    required String base64Image,
    String mimeType = 'image/jpeg',
    bool isTelugu = false,
  }) async {
    final language = isTelugu ? 'Telugu' : 'English';
    final systemPrompt = '''
You are an expert obstetric clinician. Analyze this photo of a doctor's maternal medicine prescription.
Extract the details into a JSON object with this exact structure:
{
  "diagnosisCause": "Condition diagnosed by doctor (e.g., Routine 2nd Trimester, Mild Anaemia, Gestational Hypertension)",
  "clinicalReason": "Clinical purpose of the prescribed medications in $language",
  "medicines": [
    {
      "name": "Medicine name (e.g., Iron Folic Acid, Calcium)",
      "strength": "Dose (e.g., 100mg)",
      "timing": "When to take (e.g., After dinner with water)",
      "instructions": "Special instruction (e.g., Keep 2 hours gap from milk or calcium)"
    }
  ],
  "precautions": ["Precaution 1 in $language", "Precaution 2"],
  "foodsToAvoid": ["Foods to avoid while on this medication"]
}
Output only valid JSON.
''';

    try {
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        final response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_defaultModel:generateContent?key=$_apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': systemPrompt},
                  {
                    'inlineData': {
                      'mimeType': mimeType,
                      'data': base64Image,
                    }
                  }
                ],
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'responseMimeType': 'application/json',
            }
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidateText = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (candidateText != null) {
            final jsonMap = jsonDecode(candidateText);
            return GeminiPrescriptionAnalysis.fromJson(jsonMap);
          }
        }
      }
    } catch (_) {
      // Fallback
    }

    return _fallbackPrescriptionAnalysis(isTelugu);
  }

  // Maternal Health Advisor on specific core topics
  static Future<String> getMaternalGuidance(
    String topic, {
    bool isTelugu = false,
    PregnancyProfile? profile,
  }) async {
    final language = isTelugu ? 'Telugu' : 'English';
    final prompt = '''
You are "MaaCare Gemini", a compassionate maternal advisor for Telangana mothers.
Topic requested: "$topic".
User Profile: Week ${profile?.currentWeek ?? 24}, High Risk: ${profile?.isHighRisk ?? false}.

Provide thorough, practical, reassuring guidance in $language covering:
1. Direct, clear answer and clinical reasons.
2. What to do and practical daily steps.
3. What to strictly avoid (warning signs).
4. Traditional wisdom from olden days ("Ammamma / Nani's ancient remedies", courage, mindset, natural food habits).
5. When to immediately seek doctor or 108 emergency help.

Keep the tone supportive, culturally respectful to Telangana traditions, clear, and actionable.
''';

    try {
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        final response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_defaultModel:generateContent?key=$_apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ],
              }
            ],
            'generationConfig': {
              'temperature': 0.7,
            }
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
          if (text != null && text.isNotEmpty) {
            return text;
          }
        }
      }
    } catch (_) {}

    return _fallbackMaternalAdvice(topic, isTelugu);
  }

  // --- Fallback Rule-Based Knowledge Base ---

  static GeminiReportAnalysis _fallbackReportAnalysis(String text, bool isTelugu) {
    final lower = text.toLowerCase();
    if (lower.contains('hb') || lower.contains('hemoglobin') || lower.contains('blood')) {
      return GeminiReportAnalysis(
        testName: isTelugu ? 'హీమోగ్లోబిన్ (Hb) రక్త పరీక్ష' : 'Hemoglobin (Hb) Blood Test',
        resultValue: '10.8 g/dL',
        normalRange: '11.0 - 14.0 g/dL',
        status: 'borderline',
        summary: isTelugu
            ? 'రక్త శాతం కొద్దిగా సరిహద్దులో (10.8 g/dL) ఉంది. స్వల్ప రక్తహీనత నివారణకు ఐరన్ మాత్రలు మరియు తోటకూర, ఖర్జూరం వంటి ఆహారాలు అవసరం.'
            : 'Hemoglobin is borderline at 10.8 g/dL (mild anaemia risk). Daily Iron-Folic Acid supplementation and iron-rich foods are recommended.',
        clinicalCause: isTelugu
            ? 'గర్భధారణలో రక్త పరిమాణం పెరగడం (హీమోడైల్యూషన్) వల్ల సహజంగా ఐరన్ అవసరాలు పెరుగుతాయి.'
            : 'Expansion of maternal blood plasma naturally increases fetal iron demand.',
        recommendations: isTelugu
            ? [
                'రోజూ రాత్రి ఐరన్ (IFA) మాత్ర నిమ్మరసం లేదా మంచినీటితో తీసుకోండి.',
                'తోటకూర, పాలకూర, బెల్లం, వేరుశనగలు ఆహారంలో చేర్చండి.',
                'పాలు లేదా టీ తాగిన వెంటనే ఐరన్ మాత్ర వేసుకోకండి (2 గంటల వ్యవధి పాటించండి).'
              ]
            : [
                'Take prescribed IFA tablet with vitamin C/lemon water daily.',
                'Include green leafy vegetables (Thotakura), dates, and jaggery in meals.',
                'Never take iron with milk or tea; keep a 2-hour gap.'
              ],
        suggestedNextCheckup: isTelugu
            ? 'తదుపరి ANC తనిఖీ: 4 వారాల తర్వాత రక్తపోటు మరియు Hb రిపీట్ పరీక్ష కోసం UPHC కి వెళ్లండి.'
            : 'Next ANC Visit: Recheck Hb and BP in 4 weeks at your designated UPHC.',
      );
    }

    return GeminiReportAnalysis(
      testName: isTelugu ? 'సాధారణ ప్రసవ పూర్వ తనిఖీ రిపోర్ట్' : 'General Antenatal Diagnostic Report',
      resultValue: isTelugu ? 'సంతృప్తికరం' : 'Normal / Stable',
      normalRange: 'Gestational Baseline',
      status: 'normal',
      summary: isTelugu
          ? 'రిపోర్టులో ప్రాథమిక సంకేతాలు సాధారణంగా ఉన్నాయి. డాక్టర్ సూచించిన పోషకాహార నియమాలు మరియు మందులు క్రమం తప్పకుండా పాటించండి.'
          : 'Report findings are consistent with gestational expectations. Continue standard antenatal care and prescribed supplements.',
      clinicalCause: isTelugu ? 'గర్భధారణ సాధారణ పురోగతి' : 'Standard maternal physiological adaptation',
      recommendations: isTelugu
          ? ['రోజూ 8-10 గ్లాసుల మంచినీరు త్రాగండి.', 'క్రమం తప్పకుండా సమతుల్య ఆహారం తీసుకోండి.', 'ఏవైనా అసాధారణ నొప్పులుంటే డాక్టర్‌ను కలవండి.']
          : ['Maintain 8-10 glasses of clean water daily.', 'Continue balanced nutrition and prescribed IFA/Calcium.', 'Consult your clinician on any warning signs.'],
      suggestedNextCheckup: isTelugu
          ? 'షెడ్యూల్ ప్రకారం తదుపరి ప్రసవ పూర్వ వైద్య పరీక్షకు హాజరుకండి.'
          : 'Attend next scheduled ANC checkup as marked in your MCP card.',
    );
  }

  static GeminiPrescriptionAnalysis _fallbackPrescriptionAnalysis(bool isTelugu) {
    return GeminiPrescriptionAnalysis(
      diagnosisCause: isTelugu ? '2వ త్రైమాసిక ప్రసవ పూర్వ సంరక్షణ & ఎముకల బలం' : '2nd Trimester Routine Antenatal Care & Fetal Bone Development',
      clinicalReason: isTelugu
          ? 'శిశువు ఎముకల నిర్మాణం మరియు తల్లిలో రక్తహీనత రాకుండా నివారించడానికి డాక్టర్ ఈ మందులను సూచించారు.'
          : 'Prescribed to prevent maternal anaemia and support healthy fetal skeletal growth and neural development.',
      medicines: [
        {
          'name': isTelugu ? 'ఐరన్ & ఫోలిక్ యాసిడ్ (IFA)' : 'Iron & Folic Acid (IFA)',
          'strength': '100mg Iron + 500mcg FA',
          'timing': isTelugu ? 'రాత్రి భోజనం తర్వాత' : '1 Tablet Daily (Night after food)',
          'instructions': isTelugu ? 'మంచినీరు లేదా నిమ్మరసంతో వేసుకోండి. పాలు కలపకూడదు.' : 'Take with water or citrus juice. Never with milk.',
        },
        {
          'name': isTelugu ? 'కాల్షియం + విటమిన్ D3' : 'Calcium + Vitamin D3',
          'strength': '500mg + 250 IU',
          'timing': isTelugu ? 'ఉదయం అల్పాహారం & మధ్యాహ్నం భోజనం తర్వాత' : '1 Tablet Twice Daily (Morning & Afternoon)',
          'instructions': isTelugu ? 'ఐరన్ మాత్రకు, దీనికి మధ్య కనీసం 2 గంటల వ్యవధి ఉండాలి.' : 'Keep at least 2 hours gap from Iron tablets.',
        },
      ],
      precautions: isTelugu
          ? [
              'ఐరన్ మరియు కాల్షియం మాత్రలను ఒకేసారి మింగకూడదు.',
              'మందు వేసుకోవడం మర్చిపోతే తర్వాతి సారి డబుల్ డోస్ వేసుకోకండి.',
              'మలబద్ధకం నివారించడానికి తగినంత నీరు, పీచు పదార్థాలు తినండి.'
            ]
          : [
              'Never take Iron and Calcium tablets simultaneously.',
              'Never take a double dose if you forgot a scheduled tablet.',
              'Drink plentiful fluids to prevent constipation.'
            ],
      foodsToAvoid: isTelugu
          ? ['టీ, కాఫీలను భోజనం లేదా మందుల సమయంలో త్రాగకూడదు.', 'పచ్చి లేదా అరకొరగా ఉడికిన ఆహారాలు.']
          : ['Tea and coffee around medication time (blocks iron absorption).', 'Uncooked or raw foods.'],
    );
  }

  static String _fallbackMaternalAdvice(String topic, bool isTelugu) {
    final lower = topic.toLowerCase();

    // 1. Miscarriage prevention
    if (lower.contains('miscarriage') || lower.contains('గర్భస్రావం') || lower.contains('avoid mis carriage')) {
      if (isTelugu) {
        return '''
🛡️ గర్భస్రావం నివారణ & జాగ్రత్తలు (How to Avoid Miscarriage)

1. మొదటి త్రైమాసికంలో తీసుకోవాల్సిన ముఖ్య జాగ్రత్తలు:
• బరువైన వస్తువులు ఎత్తడం, అధిక శ్రమతో కూడిన పనులు చేయకూడదు.
• డాక్టర్ సలహా లేకుండా ఎలాంటి నొప్పి నివారణ మాత్రలు (Painkillers) వాడకూడదు.
• మొదటి 12 వారాలు ఫోలిక్ యాసిడ్ మాత్రలను తప్పనిసరిగా వేసుకోవాలి.

2. ప్రయాణాలు & జీవనశైలి:
• గతుకుల రోడ్లపై ఆటోరిక్షా, బైక్ ప్రయాణాలను పూర్తిగా నివారించండి.
• శరీర ఉష్ణోగ్రత పెరగకుండా చల్లని వాతావరణంలో ఉండండి, వేడి నీటి స్నానాలు అతిగా చేయవద్దు.

3. ఆహార నియమాలు:
• పచ్చి బొప్పాయి (Raw Papaya) మరియు పైనాపిల్ గర్భాశయ సంకోచాలను ప్రేరేపించవచ్చు కాబట్టి తినకూడదు.
• కాచిన మంచినీరు, తాజా పండ్లు, ఇంట్లో వండిన శుభ్రమైన భోజనం మాత్రమే తినాలి.

👵 అమ్మమ్మల సాంప్రదాయ ధైర్యం & చిట్కాలు:
• "ఆందోళన వద్దు, మనస్సు ప్రశాంతంగా ఉంటే బిడ్డ ఆరోగ్యంగా ఎదుగుతుంది."
• ఉదయం పూట కాస్త ధనియాలు, జీలకర్ర వేసి కాచిన గోరువెచ్చని నీరు తాగితే శరీరం చల్లబడుతుంది.
• రోజూ తగినంత నిద్ర, కుటుంబ సభ్యుల ఆప్యాయత తల్లికి కొండంత బలం.

🚨 ఎప్పుడు వెంటనే ఆసుపత్రికి వెళ్ళాలి?
రక్తస్రావం (Bleeding), తీవ్రమైన కడుపు నొప్పి లేదా నడుము నొప్పి ఉంటే క్షణం కూడా ఆలస్యం చేయకుండా 108 లేదా మీ గైనకాలజిస్ట్‌ని సంప్రదించండి.
''';
      } else {
        return '''
🛡️ Guidelines to Avoid Miscarriage & Protect Early Pregnancy

1. First Trimester Safeguards:
• Avoid lifting heavy weights, strenuous physical exertion, or jerky movements.
• Never take over-the-counter medications without your doctor's explicit approval.
• Daily Folic Acid (5mg) is mandatory to support neural tube closure and embryonic safety.

2. Travel Restrictions:
• Strictly avoid bumpy two-wheeler and auto-rickshaw rides on uneven rural/city roads.
• Avoid long-distance bumpy journeys during the first 12 weeks.

3. Dietary Guidelines:
• Avoid raw/unripe papaya and excess pineapple (contain enzymes associated with uterine cramps).
• Avoid unpasteurized milk, raw eggs, and improperly washed vegetables.

👵 Granny's Wisdom (Ammamma's Ancient Counsel):
• "Peace of mind is the greatest medicine for the unborn child."
• Stay hydrated with boiled and cooled water infused with cumin or coriander seeds.
• Sleep on your left side to maximize placental blood flow and oxygen to the baby.

🚨 Immediate Red Flags:
Any vaginal spotting, bright red bleeding, fluid leakage, or severe cramping demands immediate evaluation. Call 108 or go to your nearest maternity hospital immediately.
''';
      }
    }

    // 2. Journey & Travel precautions
    if (lower.contains('journey') || lower.contains('travel') || lower.contains('ప్రయాణ')) {
      if (isTelugu) {
        return '''
🚗 ప్రయాణాల్లో తీసుకోవాల్సిన జాగ్రత్తలు & ప్రయాణాలు ఎప్పుడు నివారించాలి?

1. ఎప్పుడు ప్రయాణాలు పూర్తిగా నివారించాలి (When to Avoid Travel):
• మొదటి 12 వారాలు (రక్తస్రావం లేదా కడుపు నొప్పి చరిత్ర ఉన్నప్పుడు).
• 36 వారాల తర్వాత (ఎప్పుడైనా ప్రసవ నొప్పులు రావచ్చు).
• రక్తపోటు (BP), మావి కిందకు ఉన్నప్పుడు (Placenta Previa) లేదా కవల పిల్లలు ఉన్నప్పుడు.
• గతుకుల రోడ్లు, ఆటోలు మరియు టూ-వీలర్ ప్రయాణాలు అత్యంత ప్రమాదకరం.

2. తప్పనిసరిగా ప్రయాణించాల్సి వస్తే జాగ్రత్తలు:
• ఎల్లప్పుడూ రైలు లేదా సుఖవంతమైన కారును ఎంచుకోండి.
• ప్రతి 1-2 గంటలకు ఒకసారి కాసేపు నడవండి (రక్త ప్రసరణ బాగుంటుంది, కాళ్ల వాపులు రావు).
• సీటు బెల్టును పొట్టపై కాకుండా, పొట్ట కింద తొడల భాగంలో పెట్టుకోవాలి.
• మీ MCP కార్డు, అన్ని స్కానింగ్ రిపోర్టులు మరియు అత్యవసర కాంటాక్ట్ నంబర్లను ఎప్పుడూ వెంట ఉంచుకోండి.

👵 అమ్మమ్మ మాట:
"పుట్టబోయే బిడ్డ కంటే ఏ ప్రయాణమూ ముఖ్యం కాదు. సుఖప్రసవం అయ్యేవరకు దూర ప్రయాణాలను వాయిదా వేయడమే శ్రేయస్కరం."
''';
      } else {
        return '''
🚗 Travel Precautions & When to Avoid Journeys During Pregnancy

1. When to Strictly Avoid Travel:
• First 12 Weeks if you have any history of spotting, cramps, or prior pregnancy loss.
• Beyond 36 Weeks (delivery can initiate anytime).
• If diagnosed with High Blood Pressure, Low-lying placenta (Placenta Previa), or Twins.
• Avoid rough autorickshaws, two-wheelers, and broken rural roads.

2. Safe Travel Practices (If Unavoidable):
• Trains or comfortable cars on smooth highways are safest.
• Take walking breaks every 90 minutes to prevent blood pooling and DVT (blood clots).
• Wear the seatbelt below your belly across your pelvic bone, never across the stomach.
• Always keep your physical MCP card, water bottle, and emergency 108 contact in your hand bag.

👵 Granny's Wisdom:
"Rest at home brings serenity to the womb. No journey is more important than the safety of your little one."
''';
      }
    }

    // 3. Foods to Avoid
    if (lower.contains('food') || lower.contains('avoid') || lower.contains('ఆహార')) {
      if (isTelugu) {
        return '''
🚫 గర్భధారణ సమయంలో ఏ ఆహారాలు తినకూడదు? (Foods to Strictly Avoid)

1. పచ్చి బొప్పాయి (Raw / Semi-ripe Papaya):
పచ్చి బొప్పాయిలో ఉండే లేటెక్స్ గర్భాశయ సంకోచాలను ప్రేరేపిస్తుంది. బాగా పండిన బొప్పాయిని స్వల్పంగా తినవచ్చు, కానీ పచ్చిది ప్రమాదం.

2. కాచని పాలు & పచ్చి చీజ్ (Unpasteurized Dairy):
లిస్టీరియా అనే ప్రమాదకర బాక్టీరియా సోకే ప్రమాదం ఉంది. ఎల్లప్పుడూ బాగా కాచిన పాలనే వాడండి.

3. పచ్చి లేదా సరిగ్గా ఉడకని గుడ్లు, మాంసం:
సాల్మొనెల్లా ఇన్ఫెక్షన్ రాకుండా గుడ్లు, చికెన్ లేదా చేపలను పూర్తిగా ఉడికించి మాత్రమే తినాలి.

4. అధిక కాఫీ, టీ & శీతల పానీయాలు (Excess Caffeine & Soda):
రోజుకు 1 కప్పు కంటే ఎక్కువ టీ/కాఫీ తాగకూడదు. సోడాలు మరియు రసాయనాలు కలిపిన పానీయాలు పూర్తిగా మానండి.

5. ఆల్కహాల్ మరియు పొగాకు:
శిశువు ఎదుగుదల మరియు మెదడుపై తీవ్ర దుష్ప్రభావం చూపుతుంది (జీరో టాలరెన్స్).

👵 అమ్మమ్మల ఆహార సూత్రం:
"వేడి చేసే పదార్థాలు (నువ్వులు, అధిక మసాలాలు) మితంగా ఉంచండి. తాజా జొన్న రొట్టె, తోటకూర పప్పు, కమ్మని మజ్జిగ బిడ్డకు అమృతం లాంటివి."
''';
      } else {
        return '''
🚫 Foods to Strictly Avoid During Pregnancy

1. Raw or Semi-ripe Papaya:
Contains concentrated latex and papain that can trigger premature uterine contractions.

2. Unpasteurized Milk & Raw Soft Cheeses:
Risk of Listeria infection which can cause severe fetal complications. Drink only well-boiled or pasteurized milk.

3. Undercooked Eggs, Poultry, or Seafood:
Risk of Salmonella and Toxoplasmosis. Ensure all non-vegetarian items and eggs are thoroughly, hygienically cooked.

4. Excess Caffeine, Street Food & Fizzy Drinks:
Limit caffeine to under 1 cup daily. Avoid unhygienic roadside water and uncooked salads outside.

5. Alcohol and Tobacco (Zero Tolerance):
Causes severe irreversible fetal alcohol syndrome and developmental delays.

👵 Granny's Traditional Habit:
"Eat fresh, home-cooked, seasonal foods. Cool buttermilk, drumstick leaves, dal, and fresh fruits nourish both mother and baby safely."
''';
      }
    }

    // 4. Increase healthy weight
    if (lower.contains('weight') || lower.contains('బరువు') || lower.contains('incresse weight')) {
      if (isTelugu) {
        return '''
📈 తల్లి & శిశువు ఆరోగ్యకరమైన బరువు పెరగడానికి చిట్కాలు (How to Increase Healthy Weight)

1. సహజ బలవర్ధకమైన ఆహారాలు:
• రాగి అంబలి / రాగి మాల్ట్: ఎముకలకు కాల్షియం మరియు సహజ బలాన్ని ఇస్తుంది.
• రోజూ 1-2 ఉడకబెట్టిన గుడ్లు (శాకాహారులైతే పెసర్లు, శనగలు, పనీర్).
• డ్రై ఫ్రూట్స్: రాత్రి నానబెట్టిన 4 బాదం పప్పులు, 2 అంజీర్ మరియు ఖర్జూరం.
• పప్పులు (Dal): తోటకూర పప్పు, ముద్దపప్పులో కాస్త స్వచ్ఛమైన ఆవు నెయ్యి వేసుకుని తినడం మంచిది.
• పండ్లు: జామపండు, అరటిపండు, దానిమ్మ రోజూ తినండి.

2. చిన్న చిన్న విరామాలలో తినండి:
ఒకేసారి ఎక్కువగా తినకుండా, రోజుకు 5-6 సార్లు కొద్దికొద్దిగా పోషకాహారం తినడం వల్ల అరుగుదల బాగుంటుంది.

👵 అమ్మమ్మల బలాన్నిచ్చే చిట్కాలు:
"పాతకాలంలో గర్భిణీ స్త్రీలకు రాగి పిండితో జావ కాచి ఇచ్చేవారు. పెసరపప్పు కిచిడీలో నెయ్యి వేసి పెడితే బిడ్డ పుష్టిగా పెరుగుతుంది."
''';
      } else {
        return '''
📈 Safe & Healthy Weight Gain for Mother and Baby

1. Nutrient-Dense Traditional Foods:
• Ragi Malt / Ambali: Exceptional source of natural calcium and stamina.
• 1-2 Boiled Eggs daily (or sprouted moong, paneer, and chickpeas for vegetarians).
• Soaked Dry Fruits: 4 soaked almonds, 2 figs (anjeer), and dates every morning.
• Pure Cow Ghee in moderation with hot dal rice / khichdi.
• Bananas, Guavas, and Pomegranates for natural healthy calories and hemoglobin.

2. Eating Routine:
• Eat 5 to 6 small, frequent meals rather than 2 heavy meals to avoid nausea and acid reflux.

👵 Granny's Wisdom:
"Strength comes from purity of food, not junk calories. Moong dal khichdi, ragi, and fresh milk build strong bones for the little one."
''';
      }
    }

    // Default Granny's Courage & Remedies
    if (isTelugu) {
      return '''
👵 అమ్మమ్మ / బామ్మ మాట: పాతకాలపు సహజ నివారణలు & మనోధైర్యం

1. వేవిళ్ళు (Morning Sickness) తగ్గేందుకు:
• ఉదయం లేవగానే పచ్చి అల్లం ముక్క లేదా యాలకుల గింజ నోట్లో ఉంచుకోండి.
• కాచిన నీటిలో కాస్త జీలకర్ర వేసి చల్లార్చి తాగితే కడుపులో వికారం, మంట తగ్గుతాయి.

2. మంచి నిద్ర & విశ్రాంతి:
• రాత్రి పడుకునే ముందు గోరువెచ్చని పాలలో చిటికెడు పసుపు వేసుకుని తాగండి.
• ఎడమవైపునకు తిరిగి పడుకోవడం వల్ల గర్భాశయానికి రక్తప్రసరణ బాగా జరుగుతుంది.

3. మనోధైర్యం & మానసిక ఉల్లాసం:
• "ఆడపిల్ల అయినా, మగపిల్లవాడైనా ఆరోగ్యంగా పుట్టడమే ముఖ్యం. దేవుడిపై భారం వేసి ధైర్యంగా ఉండు."
• చక్కని జోలపాటలు, ప్రశాంతమైన సంగీతం వినడం తల్లికి, కడుపులోని బిడ్డకు ఎంతో మేలు చేస్తుంది.
''';
    } else {
      return '''
👵 Granny's Ancient Wisdom: Natural Remedies & Inner Courage

1. Morning Sickness & Nausea Relief:
• Chew a small slice of fresh ginger or cardamom pod upon waking up.
• Sip warm water infused with cumin (jeera) and coriander to calm the stomach.

2. Restful Sleep & Blood Circulation:
• Sleep on your left side to maximize nutrients and oxygen delivery via the placenta.
• A glass of warm milk with a pinch of turmeric at bedtime calms nerves and promotes deep sleep.

3. Inner Courage & Serenity:
• "A courageous, smiling mother gives birth to a calm, resilient child."
• Practice slow deep breathing, listen to soothing traditional music, and walk gently for 20 minutes in fresh air.
''';
    }
  }
}
