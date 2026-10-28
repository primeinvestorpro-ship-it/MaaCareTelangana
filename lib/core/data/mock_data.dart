import '../models/pregnancy_model.dart';
import '../models/appointment_model.dart';
import '../models/medication_model.dart';
import '../models/vaccine_model.dart';
import '../models/medical_record_model.dart';
import '../models/hospital_model.dart';
import '../models/nutrition_model.dart';

class MockDataRepository {
  static PregnancyProfile getInitialProfile() {
    final now = DateTime.now();
    // Default mock pregnancy: Week 24 (LMP roughly 168 days ago)
    final mockLmp = now.subtract(const Duration(days: 165));
    // Naegele's rule: LMP + 280 days
    final mockEdd = mockLmp.add(const Duration(days: 280));

    return PregnancyProfile(
      id: 'preg_tg_001',
      motherName: 'Anitha Reddy',
      phoneNumber: '9876543210',
      lmpDate: mockLmp,
      estimatedDueDate: mockEdd,
      eddSource: 'CLINICIAN_USG',
      gravida: 1,
      parity: 0,
      isHighRisk: false,
      preferredHospital: 'Govt Maternity Hospital, Petlaburj, Hyderabad',
      bloodGroup: 'O Positive',
      ashaWorkerName: 'K. Padma (ASHA)',
      ashaWorkerPhone: '9440567890',
      emergencyCaregiverPhone: '9848123456',
    );
  }

  static List<ANCAppointment> getInitialAppointments() {
    final now = DateTime.now();
    return [
      ANCAppointment(
        id: 'anc_1',
        title: '1st ANC Checkup & Registration',
        titleTe: '1వ ప్రసవ పూర్వ తనిఖీ & రిజిస్ట్రేషన్',
        visitNumber: 1,
        scheduledDate: now.subtract(const Duration(days: 90)),
        facilityName: 'UPHC Amberpet, Hyderabad',
        doctorOrWorker: 'Dr. S. Sunitha (Medical Officer)',
        notes: 'MCP card issued. Blood grouping, Hb, HIV/HBsAg tests conducted. Folic acid given.',
        notesTe: 'MCP కార్డు ఇవ్వబడింది. రక్త పరీక్షలు మరియు ఫోలిక్ యాసిడ్ మాత్రలు ఇవ్వబడ్డాయి.',
        requiresMcpCard: true,
        status: AppointmentStatus.completed,
      ),
      ANCAppointment(
        id: 'anc_2',
        title: '2nd ANC Visit & Anomaly Scan',
        titleTe: '2వ తనిఖీ & టిఫా (Anomaly) అల్ట్రాసౌండ్ స్కాన్',
        visitNumber: 2,
        scheduledDate: now.subtract(const Duration(days: 20)),
        facilityName: 'Modern Govt Maternity Hospital, Petlaburj',
        doctorOrWorker: 'Dr. K. Anuradha (Obstetrician)',
        notes: 'Anomaly scan normal. IFA and Calcium supplements started. Td-1 vaccine given.',
        notesTe: 'టిఫా స్కాన్ సాధారణంగా ఉంది. ఐరన్ మరియు కాల్షియం మాత్రలు ప్రారంభించారు. Td-1 టీకా పూర్తయింది.',
        requiresMcpCard: true,
        requiresUltrasound: true,
        status: AppointmentStatus.completed,
      ),
      ANCAppointment(
        id: 'anc_3',
        title: '3rd ANC Checkup & Sugar Screening',
        titleTe: '3వ తనిఖీ & గర్భధారణ మధుమేహ (OGTT) పరీక్ష',
        visitNumber: 3,
        scheduledDate: now.add(const Duration(days: 12)),
        facilityName: 'Modern Govt Maternity Hospital, Petlaburj',
        doctorOrWorker: 'Dr. K. Anuradha (Obstetrician)',
        notes: 'Oral Glucose Tolerance Test (OGTT), BP check, abdominal palpation, Hb repeat.',
        notesTe: 'గ్లూకోజ్ సహన పరీక్ష (OGTT), రక్తపోటు తనిఖీ, కడుపు పరీక్ష, Hb పునఃపరిశీలన.',
        requiresMcpCard: true,
        requiresFastingBlood: true,
        status: AppointmentStatus.upcoming,
      ),
      ANCAppointment(
        id: 'anc_4',
        title: '4th ANC Checkup & Delivery Planning',
        titleTe: '4వ తనిఖీ & ప్రసవ సన్నద్ధత ప్రణాళిక',
        visitNumber: 4,
        scheduledDate: now.add(const Duration(days: 70)),
        facilityName: 'Modern Govt Maternity Hospital, Petlaburj',
        doctorOrWorker: 'Dr. K. Anuradha (Obstetrician)',
        notes: 'Fetal presentation, growth assessment, delivery facility confirmation, Amma Vodi 102 coordination.',
        notesTe: 'శిశువు స్థానం, ఎదుగుదల అంచనా, ప్రసవ ఆసుపత్రి ఎంపిక, అమ్మ ఒడి 102 సమన్వయం.',
        requiresMcpCard: true,
        status: AppointmentStatus.upcoming,
      ),
    ];
  }

  static List<MedicationItem> getInitialMedications() {
    final now = DateTime.now();
    return [
      MedicationItem(
        id: 'med_1',
        name: 'Iron & Folic Acid (IFA)',
        nameTe: 'ఐరన్ & ఫోలిక్ యాసిడ్ మాత్ర',
        strength: '100mg Iron + 500mcg Folic Acid',
        dosageSchedule: '1 Tablet Daily (After Dinner)',
        dosageScheduleTe: 'రోజుకు 1 మాత్ర (రాత్రి భోజనం తర్వాత)',
        foodInstructions: 'Take with water or fresh lime water. Never take with tea, coffee or milk. Maintain 2 hours gap from Calcium.',
        foodInstructionsTe: 'మంచినీరు లేదా నిమ్మరసంతో వేసుకోండి. పాలు, టీ, కాఫీలతో వేసుకోకండి. కాల్షియం మాత్రకు 2 గంటల వ్యవధి పాటించండి.',
        prescribedBy: 'Dr. K. Anuradha (Govt Maternity Hospital)',
        startDate: now.subtract(const Duration(days: 45)),
        isTakenToday: false,
      ),
      MedicationItem(
        id: 'med_2',
        name: 'Calcium + Vitamin D3',
        nameTe: 'కాల్షియం + విటమిన్ D3 మాత్ర',
        strength: '500mg Calcium + 250 IU D3',
        dosageSchedule: '1 Tablet Twice Daily (Morning & Afternoon)',
        dosageScheduleTe: 'రోజుకు 2 మాత్రలు (ఉదయం & మధ్యాహ్నం)',
        foodInstructions: 'Take after breakfast and lunch with water. Helps strengthen baby bones and maternal calcium levels.',
        foodInstructionsTe: 'అల్పాహారం మరియు భోజనం తర్వాత నీటితో వేసుకోండి. శిశువు ఎముకల బలానికి మరియు తల్లి ఆరోగ్యానికి అవసరం.',
        prescribedBy: 'Dr. K. Anuradha (Govt Maternity Hospital)',
        startDate: now.subtract(const Duration(days: 45)),
        isTakenToday: true,
      ),
    ];
  }

  static List<VaccineItem> getInitialVaccines() {
    final now = DateTime.now();
    return [
      // Maternal Vaccines
      VaccineItem(
        id: 'vac_m1',
        name: 'Td-1 (Tetanus & adult Diphtheria)',
        nameTe: 'Td-1 (టెటానస్ & డిఫ్తీరియా 1వ డోస్)',
        targetGroup: 'Mother (Maternal)',
        recommendedPeriod: 'Early pregnancy / 1st Trimester',
        recommendedPeriodTe: 'మొదటి త్రైమాసికం లేదా గర్భం దాల్చిన వెంటనే',
        target: VaccineTarget.mother,
        isCompleted: true,
        administrationDate: now.subtract(const Duration(days: 50)),
        administeredFacility: 'UPHC Amberpet, Hyderabad',
        batchNumber: 'TD-9021-HYD',
      ),
      VaccineItem(
        id: 'vac_m2',
        name: 'Td-2 (Tetanus & adult Diphtheria)',
        nameTe: 'Td-2 (టెటానస్ & డిఫ్తీరియా 2వ డోస్)',
        targetGroup: 'Mother (Maternal)',
        recommendedPeriod: '4 weeks after Td-1 dose',
        recommendedPeriodTe: 'Td-1 తీసుకున్న 4 వారాల తర్వాత',
        target: VaccineTarget.mother,
        isCompleted: true,
        administrationDate: now.subtract(const Duration(days: 15)),
        administeredFacility: 'Govt Maternity Hospital, Petlaburj',
        batchNumber: 'TD-9410-PLB',
      ),
      // Baby Birth Dose (National Immunisation Schedule)
      VaccineItem(
        id: 'vac_b1',
        name: 'BCG (Tuberculosis Protection)',
        nameTe: 'BCG టీకా (క్షయ వ్యాధి రక్షణ)',
        targetGroup: 'Newborn Baby',
        recommendedPeriod: 'At Birth (within 48 hours of delivery)',
        recommendedPeriodTe: 'పుట్టిన వెంటనే (48 గంటల్లోపు)',
        target: VaccineTarget.baby,
        isCompleted: false,
      ),
      VaccineItem(
        id: 'vac_b2',
        name: 'OPV-0 (Oral Polio Vaccine Birth Dose)',
        nameTe: 'పోలియో చుక్కలు (OPV-0 పుట్టిన వెంటనే)',
        targetGroup: 'Newborn Baby',
        recommendedPeriod: 'At Birth in delivery hospital',
        recommendedPeriodTe: 'ప్రసవాసుపత్రిలోనే పుట్టిన వెంటనే',
        target: VaccineTarget.baby,
        isCompleted: false,
      ),
      VaccineItem(
        id: 'vac_b3',
        name: 'Hepatitis B Birth Dose',
        nameTe: 'హెపటైటిస్-బి బర్త్ డోస్',
        targetGroup: 'Newborn Baby',
        recommendedPeriod: 'Within 24 hours of birth',
        recommendedPeriodTe: 'పుట్టిన 24 గంటల లోపు',
        target: VaccineTarget.baby,
        isCompleted: false,
      ),
    ];
  }

  static List<MedicalRecordItem> getInitialMedicalRecords() {
    final now = DateTime.now();
    return [
      MedicalRecordItem(
        id: 'rec_hb',
        testName: 'Hemoglobin (Hb)',
        testNameTe: 'హీమోగ్లోబిన్ (రక్త శాతం)',
        category: 'Blood',
        recordedValue: '11.4 g/dL',
        normalRange: '11.0 - 14.0 g/dL',
        testDate: now.subtract(const Duration(days: 20)),
        facility: 'Govt Maternity Hospital Diagnostic Lab',
        reviewStatus: TestReviewStatus.normal,
        clinicalNotes: 'Adequate hemoglobin level. Continue daily IFA tablet as prescribed.',
        clinicalNotesTe: 'రక్త శాతం సంతృప్తికరంగా ఉంది. రోజూ ఐరన్ మాత్ర వేసుకోవడం కొనసాగించండి.',
      ),
      MedicalRecordItem(
        id: 'rec_bg',
        testName: 'Blood Group & Rh Type',
        testNameTe: 'బ్లడ్ గ్రూప్ & Rh రకం',
        category: 'Blood',
        recordedValue: 'O Rh Positive (O+)',
        normalRange: 'Compatible',
        testDate: now.subtract(const Duration(days: 90)),
        facility: 'UPHC Amberpet Lab',
        reviewStatus: TestReviewStatus.normal,
        clinicalNotes: 'Rh Positive. No anti-D immunoglobulin required.',
        clinicalNotesTe: 'Rh పాజిటివ్. యాంటీ-డి అవసరం లేదు.',
      ),
      MedicalRecordItem(
        id: 'rec_usg_anomaly',
        testName: 'Targeted Anomaly Scan (TIFFA)',
        testNameTe: 'టిఫా అల్ట్రాసౌండ్ స్కాన్ (అంగవైకల్య పరిశీలన)',
        category: 'Ultrasound',
        recordedValue: 'Single live fetus, 20 weeks 4 days. Normal anatomy.',
        normalRange: 'Normal Morphology & Liquor volume',
        testDate: now.subtract(const Duration(days: 20)),
        facility: 'Govt Maternity Hospital, Petlaburj Sonology Dept',
        reviewStatus: TestReviewStatus.normal,
        clinicalNotes: 'Fetal cardiac activity regular. Amniotic fluid index adequate. Placenta posterior high.',
        clinicalNotesTe: 'శిశువు శరీర అవయవాలు మరియు ఎదుగుదల సాధారణంగా ఉన్నట్లు నిర్ధారించబడింది.',
      ),
      MedicalRecordItem(
        id: 'rec_urine',
        testName: 'Urine Routine (Albumin & Sugar)',
        testNameTe: 'మూత్ర పరీక్ష (అల్బుమిన్ & షుగర్)',
        category: 'Urine',
        recordedValue: 'Albumin: NIL, Sugar: NIL',
        normalRange: 'Nil / Negative',
        testDate: now.subtract(const Duration(days: 20)),
        facility: 'Govt Maternity Hospital Lab',
        reviewStatus: TestReviewStatus.normal,
        clinicalNotes: 'No proteinuria. Blood pressure normal (116/74 mmHg). Low pre-eclampsia risk.',
        clinicalNotesTe: 'ప్రోటీన్ లీకేజ్ లేదు. రక్తపోటు సాధారణం.',
      ),
    ];
  }

  static List<HealthcareFacility> getTelanganaHospitals() {
    return [
      HealthcareFacility(
        id: 'hosp_petlaburj',
        name: 'Modern Govt Maternity Hospital, Petlaburj',
        nameTe: 'మోడరన్ ప్రభుత్వ ప్రసూతి ఆసుపత్రి, పెట్లబుర్జ్',
        type: FacilityType.teachingMaternity,
        district: 'Hyderabad',
        mandal: 'Charminar',
        address: 'High Court Road, Petlaburj, Hyderabad - 500002',
        contactNumber: '040-24528822',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 3.2,
      ),
      HealthcareFacility(
        id: 'hosp_niloufer',
        name: 'Niloufer Hospital for Women & Children',
        nameTe: 'నీలోఫర్ మహిళలు మరియు పిల్లల ఆసుపత్రి',
        type: FacilityType.teachingMaternity,
        district: 'Hyderabad',
        mandal: 'Nampally',
        address: 'Bazar Ghat, Red Hills, Hyderabad - 500004',
        contactNumber: '040-23394243',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 4.8,
      ),
      HealthcareFacility(
        id: 'hosp_koti',
        name: 'Govt Maternity Hospital, Sultan Bazaar (Koti)',
        nameTe: 'ప్రభుత్వ ప్రసూతి ఆసుపత్రి, సుల్తాన్ బజార్ (కోటి)',
        type: FacilityType.teachingMaternity,
        district: 'Hyderabad',
        mandal: 'Sultan Bazaar',
        address: 'Koti Women\'s College Road, Hyderabad - 500095',
        contactNumber: '040-24755100',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 2.1,
      ),
      HealthcareFacility(
        id: 'hosp_gandhi',
        name: 'Gandhi Hospital (MCH Block), Secunderabad',
        nameTe: 'గాంధీ ఆసుపత్రి (మాతృ & శిశు సంరక్షణ విభాగం), సికింద్రాబాద్',
        type: FacilityType.teachingMaternity,
        district: 'Hyderabad',
        mandal: 'Musheerabad',
        address: 'Padmarao Nagar, Musheerabad, Secunderabad - 500003',
        contactNumber: '040-27505566',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 6.5,
      ),
      HealthcareFacility(
        id: 'hosp_malakpet',
        name: 'Area Hospital, Malakpet',
        nameTe: 'ఏరియా ఆసుపత్రి, మలక్‌పేట్',
        type: FacilityType.areaHospital,
        district: 'Hyderabad',
        mandal: 'Malakpet',
        address: 'Near Old Police Station, Malakpet, Hyderabad - 500036',
        contactNumber: '040-24541299',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: false,
        hasBloodBank: false,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 1.8,
      ),
      HealthcareFacility(
        id: 'hosp_mgm_warangal',
        name: 'MGM Hospital & MCH Center, Warangal',
        nameTe: 'MGM ఆసుపత్రి & మాతృ శిశు సంరక్షణ కేంద్రం, వరంగల్',
        type: FacilityType.teachingMaternity,
        district: 'Warangal',
        mandal: 'Hanamkonda',
        address: 'Near MG Road, Warangal - 506002',
        contactNumber: '0870-2442444',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 142.0,
      ),
      HealthcareFacility(
        id: 'hosp_dh_karimnagar',
        name: 'District Hospital, Karimnagar',
        nameTe: 'జిల్లా ప్రధాన ఆసుపత్రి, కరీంనగర్',
        type: FacilityType.districtHospital,
        district: 'Karimnagar',
        mandal: 'Karimnagar Urban',
        address: 'Hospital Road, Clock Tower, Karimnagar - 505001',
        contactNumber: '0878-2243222',
        has24x7Delivery: true,
        hasCSectionOt: true,
        hasSncuNicu: true,
        hasBloodBank: true,
        hasFreeUltrasound: true,
        hasAmmaVodi102: true,
        distanceKm: 164.0,
      ),
    ];
  }

  static List<MealRecommendation> getDailyTelanganaDiet() {
    return [
      MealRecommendation(
        mealType: 'Morning Breakfast',
        mealTypeTe: 'ఉదయపు అల్పాహారం (8:00 AM)',
        title: 'Ragi Ambali / Idli with Pesara Pappu',
        titleTe: 'రాగి అంబలి / ఇడ్లీ & పెసర పప్పు చట్నీ',
        foods: [
          '2-3 Steamed Idlis or Dosa with Green Gram (Pesara) Chutney',
          '1 Cup Warm Ragi Malt / Ambali (rich in natural calcium)',
          '1 Boiled Egg (or hand-roasted chana if vegetarian)',
        ],
        foodsTe: [
          '2-3 ఆవిరి ఇడ్లీలు లేదా దోశ + పెసరపప్పు చట్నీ',
          '1 కప్పు వెచ్చని రాగి అంబలి (సహజ కాల్షియం పుష్కలం)',
          '1 ఉడకబెట్టిన గుడ్డు (శాకాహారులైతే వేయించిన శనగలు)',
        ],
        keyNutrient: 'Calcium, Protein & Vitamin B12',
        telanganaTip: 'Ragi (Finger Millet) is a celebrated Telangana staple that strengthens bones and prevents maternal osteopenia.',
        telanganaTipTe: 'రాగి తెలంగాణ సాంప్రదాయ ఆహారం. ఇది ఎముకలకు సహజ సిద్ధమైన కాల్షియంను అందిస్తుంది.',
      ),
      MealRecommendation(
        mealType: 'Nutritious Lunch',
        mealTypeTe: 'మధ్యాహ్న బలవర్ధక భోజనం (1:00 PM)',
        title: 'Jowar Roti & Thotakura / Gongura Pappu',
        titleTe: 'జొన్న రొట్టె & తోటకూర లేదా గోంగూర పప్పు',
        foods: [
          '1-2 Jowar (Jonnalu) Rotis with Steamed Brown or White Rice',
          'Generous bowl of Leafy Greens Dal (Thotakura / Palakura Pappu)',
          'Fresh Curd / Majjiga (Spiced buttermilk with ginger and curry leaves)',
          'Seasonal vegetable curry (Carrot, Beans, Bottle Gourd)',
        ],
        foodsTe: [
          '1-2 జొన్న రొట్టెలు + అన్నం',
          'తోటకూర లేదా పాలకూర పప్పు (సహజ ఐరన్ పుష్కలం)',
          'తాజా పెరుగు లేదా అల్లం కరివేపాకు మజ్జిగ',
          'సొరకాయ, బీరకాయ లేదా క్యారెట్ కూర',
        ],
        keyNutrient: 'Dietary Fiber, Iron & Probiotics',
        telanganaTip: 'Local green leafy vegetables like Thotakura and Palakura contain abundant bioavailable iron.',
        telanganaTipTe: 'తోటకూర, పాలకూరలో సహజమైన ఐరన్ ఉంటుంది. ఇది రక్తహీనత (ఎనీమియా)ను నివారిస్తుంది.',
      ),
      MealRecommendation(
        mealType: 'Evening Snack',
        mealTypeTe: 'సాయంత్రం చిరుతిండి (5:00 PM)',
        title: 'Roasted Chana, Seasonal Guava & Murmura',
        titleTe: 'వేయించిన శనగలు, తాజా జామపండు & మరమరాలు',
        foods: [
          '1 Handful of Roasted Bengal Gram (Chana)',
          '1 Fresh Washed Guava (జామపండు) or Pomegranate (దాన్నిమ్మ)',
          'Cup of warm Milk or herbal cumin/ginger water',
        ],
        foodsTe: [
          'గుప్పెడు వేయించిన శనగలు లేదా పల్లీలు',
          'బాగా కడిగిన తాజా జామపండు లేదా దానిమ్మ గింజలు',
          'వెచ్చని పాలు లేదా జీలకర్ర నీరు',
        ],
        keyNutrient: 'Vitamin C & Plant Protein',
        telanganaTip: 'Guava (జామ) has more Vitamin C than oranges and costs very little. Vitamin C helps absorb dietary iron!',
        telanganaTipTe: 'జామపండులో విటమిన్-సి పుష్కలంగా ఉంటుంది. ఇది మనం తినే ఆహారంలోని ఐరన్‌ను శరీరం గ్రహించడానికి సహాయపడుతుంది.',
      ),
      MealRecommendation(
        mealType: 'Light Dinner',
        mealTypeTe: 'రాత్రి తేలికపాటి భోజనం (8:00 PM)',
        title: 'Warm Vegetable Khichdi or Multigrain Roti',
        titleTe: 'కూరగాయల కిచిడీ లేదా తేలికపాటి రొట్టెలు',
        foods: [
          '1 Bowl of Moong Dal Vegetable Khichdi or 2 Soft Rotis',
          'Light vegetable stew or soup (Tomato & drumstick soup)',
          'Glass of warm milk before sleep (with a pinch of turmeric)',
        ],
        foodsTe: [
          'పెసరపప్పు కూరగాయల కిచిడీ లేదా 2 మెత్తని రొట్టెలు',
          'మునగకాయ చారు లేదా టొమాటో సూప్',
          'పడుకునే ముందు పసుపు కలిపిన గోరువెచ్చని పాలు',
        ],
        keyNutrient: 'Digestive Ease & Restful Sleep',
        telanganaTip: 'Eat dinner at least 2 hours before sleeping to prevent heartburn and reflux common in pregnancy.',
        telanganaTipTe: 'ఎసిడిటీ మరియు గుండెల్లో మంటను నివారించడానికి పడుకోవడానికి 2 గంటల ముందే రాత్రి భోజనం ముగించండి.',
      ),
    ];
  }

  // Week-by-Week Educational milestones
  static Map<int, Map<String, dynamic>> getWeeklyMilestones() {
    return {
      24: {
        'babySizeMetaphor': 'Ear of Corn (మొక్కజొన్న కంకి)',
        'babySizeMetaphorTe': 'మొక్కజొన్న కంకి పరిమాణం',
        'lengthCm': 30.0,
        'weightG': 600,
        'fetalDevelopment': 'Baby’s inner ear is fully formed, allowing your baby to hear your voice and heartbeat! Tiny lungs are developing surfactant branches.',
        'fetalDevelopmentTe': 'శిశువు లోపలి చెవి పూర్తిగా ఏర్పడింది. శిశువు ఇప్పుడు మీ స్వరాన్ని, గుండె చప్పుడును వినగలదు! ఊపిరితిత్తులలో నాళాలు రూపుదిద్దుకుంటున్నాయి.',
        'maternalChanges': 'Your growing uterus now reaches about 2 inches above your navel. You might feel steady kicks and movements, especially in the evening.',
        'maternalChangesTe': 'మీ గర్భాశయం బొడ్డుపై 2 అంగుళాల వరకు విస్తరించింది. ముఖ్యంగా సాయంత్రం వేళల్లో శిశువు కాళ్ళతో తన్నడం స్పష్టంగా తెలుస్తుంది.',
        'urgentWarningSigns': 'Sudden swelling in face/hands, intense continuous headache, blurring vision, or persistent abdominal pain.',
        'urgentWarningSignsTe': 'ముఖం లేదా చేతుల్లో ఆకస్మిక వాపు, తీవ్రమైన తలనొప్పి, కంటి చూపు మసకబారడం లేదా ఆగని కడుపు నొప్పి.',
        'recommendedAction': 'Get your Oral Glucose Screening (OGTT) done between 24-28 weeks at your nearest PHC or UPHC.',
        'recommendedActionTe': '24 నుండి 28 వారాల మధ్య మీ సమీప ప్రాథమిక ఆరోగ్య కేంద్రంలో మధుమేహ (OGTT) రక్త పరీక్ష చేయించుకోండి.',
        'lastReviewedBy': 'Telangana MCH Technical Committee (MoHFW Guidelines, 2026)',
      },
    };
  }
}
