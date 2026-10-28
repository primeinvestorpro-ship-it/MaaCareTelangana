import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pregnancy_model.dart';
import '../models/appointment_model.dart';
import '../models/medication_model.dart';
import '../models/vaccine_model.dart';
import '../models/medical_record_model.dart';
import '../models/hospital_model.dart';
import '../models/nutrition_model.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  // Authentication & Session
  bool _isLoggedIn = true;
  String _currentPhoneNumber = '9876543210';

  // Localization: 'en' (English) or 'te' (Telugu)
  Locale _locale = const Locale('te');

  // Pregnancy Profile
  late PregnancyProfile _pregnancyProfile;

  // Domain Collections
  List<ANCAppointment> _appointments = [];
  List<MedicationItem> _medications = [];
  List<VaccineItem> _vaccines = [];
  List<MedicalRecordItem> _medicalRecords = [];
  List<HealthcareFacility> _facilities = [];
  List<MealRecommendation> _dailyMeals = [];

  // Selected week in pregnancy tracker
  int _selectedTrackerWeek = 24;

  // Daily Hydration Counter (Target: 8 - 10 glasses)
  int _waterGlassesToday = 5;
  final int _waterTargetGlasses = 8;

  // Popup Reminders State
  bool _hasDismissedFluidReminder = false;
  bool _hasDismissedMedReminder = false;

  // Hospital filters
  String _selectedDistrict = 'All';
  String _facilitySearchQuery = '';

  AppState() {
    _initData();
    _loadFromPreferences();
  }

  void _initData() {
    _pregnancyProfile = MockDataRepository.getInitialProfile();
    _appointments = MockDataRepository.getInitialAppointments();
    _medications = MockDataRepository.getInitialMedications();
    _vaccines = MockDataRepository.getInitialVaccines();
    _medicalRecords = MockDataRepository.getInitialMedicalRecords();
    _facilities = MockDataRepository.getTelanganaHospitals();
    _dailyMeals = MockDataRepository.getDailyTelanganaDiet();
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get currentPhoneNumber => _currentPhoneNumber;
  Locale get locale => _locale;
  bool get isTelugu => _locale.languageCode == 'te';
  PregnancyProfile get profile => _pregnancyProfile;
  List<ANCAppointment> get appointments => _appointments;
  List<MedicationItem> get medications => _medications;
  List<VaccineItem> get vaccines => _vaccines;
  List<MedicalRecordItem> get medicalRecords => _medicalRecords;
  List<HealthcareFacility> get facilities => _facilities;
  List<MealRecommendation> get dailyMeals => _dailyMeals;
  int get selectedTrackerWeek => _selectedTrackerWeek;
  int get waterGlassesToday => _waterGlassesToday;
  int get waterTargetGlasses => _waterTargetGlasses;
  String get selectedDistrict => _selectedDistrict;
  String get facilitySearchQuery => _facilitySearchQuery;
  bool get hasDismissedFluidReminder => _hasDismissedFluidReminder;
  bool get hasDismissedMedReminder => _hasDismissedMedReminder;

  // Unfinished medicines today
  List<MedicationItem> get pendingMedicationsToday =>
      _medications.where((m) => !m.isTakenToday).toList();

  // Upcoming next appointment
  ANCAppointment? get nextUpcomingAppointment {
    final upcoming = _appointments
        .where((a) => a.status == AppointmentStatus.upcoming)
        .toList();
    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    return upcoming.first;
  }

  // Filtered hospitals
  List<HealthcareFacility> get filteredFacilities {
    return _facilities.where((fac) {
      final matchesDistrict = _selectedDistrict == 'All' ||
          fac.district.toLowerCase() == _selectedDistrict.toLowerCase();
      final matchesSearch = _facilitySearchQuery.isEmpty ||
          fac.name.toLowerCase().contains(_facilitySearchQuery.toLowerCase()) ||
          fac.nameTe.contains(_facilitySearchQuery) ||
          fac.mandal.toLowerCase().contains(_facilitySearchQuery.toLowerCase());
      return matchesDistrict && matchesSearch;
    }).toList();
  }

  // --- Real Data Actions ---

  void clearDemoData() {
    final now = DateTime.now();
    _pregnancyProfile = PregnancyProfile(
      id: 'preg_real_${now.millisecondsSinceEpoch}',
      motherName: '',
      phoneNumber: _currentPhoneNumber,
      lmpDate: now.subtract(const Duration(days: 30)),
      estimatedDueDate: now.subtract(const Duration(days: 30)).add(const Duration(days: 280)),
      eddSource: 'LMP_CALCULATION',
      gravida: 1,
      parity: 0,
      isHighRisk: false,
      preferredHospital: 'UPHC / Govt Maternity Hospital',
      bloodGroup: 'Not Set',
      ashaWorkerName: '',
      ashaWorkerPhone: '',
      emergencyCaregiverPhone: '',
    );

    _appointments = [];
    _medications = [];
    _medicalRecords = [];
    _waterGlassesToday = 0;
    _saveToPreferences();
    notifyListeners();
  }

  void resetToDemoData() {
    _initData();
    _saveToPreferences();
    notifyListeners();
  }

  void dismissFluidReminder() {
    _hasDismissedFluidReminder = true;
    notifyListeners();
  }

  void dismissMedReminder() {
    _hasDismissedMedReminder = true;
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('te');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  void login(String phone) {
    _isLoggedIn = true;
    _currentPhoneNumber = phone;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void updatePregnancyLmp(DateTime newLmp) {
    final newEdd = newLmp.add(const Duration(days: 280));
    _pregnancyProfile = _pregnancyProfile.copyWith(
      lmpDate: newLmp,
      estimatedDueDate: newEdd,
      eddSource: 'LMP_CALCULATION',
    );
    _saveToPreferences();
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? phone,
    String? hospital,
    bool? isHighRisk,
    String? highRiskReason,
    String? bloodGroup,
    String? ashaName,
    String? ashaPhone,
    String? emergencyCaregiverPhone,
  }) {
    _pregnancyProfile = _pregnancyProfile.copyWith(
      motherName: name,
      phoneNumber: phone,
      preferredHospital: hospital,
      isHighRisk: isHighRisk,
      highRiskReason: highRiskReason,
      bloodGroup: bloodGroup,
      ashaWorkerName: ashaName,
      ashaWorkerPhone: ashaPhone,
      emergencyCaregiverPhone: emergencyCaregiverPhone,
    );
    _saveToPreferences();
    notifyListeners();
  }

  void setSelectedTrackerWeek(int week) {
    _selectedTrackerWeek = week.clamp(1, 42);
    notifyListeners();
  }

  // --- Medications CRUD ---
  void toggleMedicationTaken(String id) {
    final index = _medications.indexWhere((m) => m.id == id);
    if (index != -1) {
      final item = _medications[index];
      item.isTakenToday = !item.isTakenToday;
      item.lastTakenTime = item.isTakenToday ? DateTime.now() : null;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void addMedication(MedicationItem med) {
    _medications.add(med);
    _saveToPreferences();
    notifyListeners();
  }

  void editMedication(MedicationItem updated) {
    final index = _medications.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      _medications[index] = updated;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void deleteMedication(String id) {
    _medications.removeWhere((m) => m.id == id);
    _saveToPreferences();
    notifyListeners();
  }

  // --- Hydration ---
  void incrementWater() {
    if (_waterGlassesToday < 15) {
      _waterGlassesToday++;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void decrementWater() {
    if (_waterGlassesToday > 0) {
      _waterGlassesToday--;
      _saveToPreferences();
      notifyListeners();
    }
  }

  // --- Appointments CRUD ---
  void markAppointmentCompleted(String id) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index].status = AppointmentStatus.completed;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void addAppointment(ANCAppointment appt) {
    _appointments.add(appt);
    _saveToPreferences();
    notifyListeners();
  }

  void editAppointment(ANCAppointment updated) {
    final index = _appointments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _appointments[index] = updated;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void deleteAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
    _saveToPreferences();
    notifyListeners();
  }

  // --- Medical Records CRUD ---
  void addMedicalRecord(MedicalRecordItem record) {
    _medicalRecords.insert(0, record);
    _saveToPreferences();
    notifyListeners();
  }

  void deleteMedicalRecord(String id) {
    _medicalRecords.removeWhere((r) => r.id == id);
    _saveToPreferences();
    notifyListeners();
  }

  void setDistrictFilter(String district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void setFacilitySearch(String query) {
    _facilitySearchQuery = query;
    notifyListeners();
  }

  // --- Local Preferences Persistence ---
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('water_glasses', _waterGlassesToday);
      await prefs.setString('mother_name', _pregnancyProfile.motherName);
      await prefs.setString('lmp_date', _pregnancyProfile.lmpDate.toIso8601String());
      await prefs.setString('edd_date', _pregnancyProfile.estimatedDueDate.toIso8601String());
      await prefs.setString('hospital', _pregnancyProfile.preferredHospital);
      await prefs.setBool('is_high_risk', _pregnancyProfile.isHighRisk);
      await prefs.setString('blood_group', _pregnancyProfile.bloodGroup);
      await prefs.setString('asha_phone', _pregnancyProfile.ashaWorkerPhone);
      await prefs.setString('emergency_phone', _pregnancyProfile.emergencyCaregiverPhone);
    } catch (_) {}
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('mother_name');
      final savedLmp = prefs.getString('lmp_date');
      final savedEdd = prefs.getString('edd_date');

      if (savedName != null && savedLmp != null && savedEdd != null) {
        _pregnancyProfile = _pregnancyProfile.copyWith(
          motherName: savedName,
          lmpDate: DateTime.parse(savedLmp),
          estimatedDueDate: DateTime.parse(savedEdd),
          preferredHospital: prefs.getString('hospital') ?? _pregnancyProfile.preferredHospital,
          isHighRisk: prefs.getBool('is_high_risk') ?? _pregnancyProfile.isHighRisk,
          bloodGroup: prefs.getString('blood_group') ?? _pregnancyProfile.bloodGroup,
          ashaWorkerPhone: prefs.getString('asha_phone') ?? _pregnancyProfile.ashaWorkerPhone,
          emergencyCaregiverPhone: prefs.getString('emergency_phone') ?? _pregnancyProfile.emergencyCaregiverPhone,
        );
      }

      final savedWater = prefs.getInt('water_glasses');
      if (savedWater != null) {
        _waterGlassesToday = savedWater;
      }
      notifyListeners();
    } catch (_) {}
  }
}
