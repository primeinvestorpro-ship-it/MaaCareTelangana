# MaaCare Telangana — Pregnancy & Maternal Health Companion
**Platform:** Flutter (Android / Multiplatform)  
**Version:** 1.0.0+1  
**Target Region:** Telangana, India  
**Languages:** Telugu (తెలుగు) & English (Bilingual with instant toggle)

---

## 🌸 Overview

**MaaCare Telangana** is a comprehensive, clinically grounded maternal health companion application designed according to the official Product Requirements Document (PRD v1.0). It guides pregnant women and new mothers through their complete journey—from early pregnancy confirmation through labor, delivery, and the initial 42-day postnatal recovery period.

The application is tailored to the **Telangana public healthcare ecosystem**, seamlessly incorporating:
- **Urban Primary Health Centres (UPHCs) & PHCs**
- **Community Health Centres (CHCs) & Area Hospitals**
- **Teaching Maternity Hospitals** (Niloufer, Modern Govt Maternity Hospital Petlaburj, Sultan Bazaar Koti, Gandhi Hospital)
- **Amma Vodi (102)** Free Maternal Transport
- **108 Emergency Ambulance** One-Touch Dispatch
- **Telangana Cultural Nutrition** (Ragi Ambali, Jowar Rotis, Thotakura/Gongura Pappu, Pesara Pappu, Seasonal Guava)

---

## 📱 Core Modules Implemented

### 1. Authentication & Onboarding
- Mobile OTP Login (`9876543210` / `123456` demo pre-filled)
- Instant Bilingual Language Toggle (English <-> తెలుగు)
- Digital Personal Data Protection (DPDP) informed consent modal
- Emergency 108 bypass button directly on login screen

### 2. Pregnancy Setup & Lifecycle Engine
- LMP (Last Menstrual Period) picker with automatic Naegele's rule EDD calculation (`LMP + 280 days`)
- Automatic Gestational Age computation (Weeks and Days)
- Trimester partitioning (Trimester 1, 2, and 3)
- Clinician-documented High-Risk pregnancy tagging
- Designated Government delivery facility selection

### 3. Home Dashboard
- Real-time pregnancy hero banner with week, day, trimester, and countdown to EDD
- Baby development preview with size metaphor (e.g. *Size of an Ear of Corn / మొక్కజొన్న కంకి*)
- Next Antenatal Checkup (ANC) countdown card with **MCP Card reminder**
- Prescribed Medicines Due Today with quick check-off button
- Daily Water Hydration Tracker (Glasses logged vs target)
- Quick actions grid (Hospitals, Records, Vaccines, Hospital Bag)

### 4. Week-by-Week Pregnancy Journey
- 40-Week horizontal scrollable selector
- Fetal milestones (weight in grams, length in cm, auditory development)
- Maternal bodily changes & symptoms
- Recommended clinical tests for that gestational week (e.g. Anomaly Scan at 18-20 weeks, OGTT at 24-28 weeks)
- Danger warning signs for each week
- Clinical content review stamps (MoHFW & Telangana Health Dept guidelines)

### 5. Antenatal Care (ANC) & MCP Schedule
- Upcoming & completed visits tracking (ANC 1 to ANC 4 and Postnatal)
- Telangana MCP Card checklist items
- Add/edit visit modal

### 6. Medical Records & Diagnostic Tests
- Tracks Hemoglobin (Hb), Blood Group/Rh, Urine Albumin & Sugar, Targeted Anomaly Ultrasound Scan (TIFFA)
- Review status indicators: *Normal*, *Borderline*, *Clinical Review Needed*
- Add new test record modal
- Medical safety disclaimers prominently displayed

### 7. Vaccination & Immunisation Tracker
- **Maternal Vaccines:** Td-1 and Td-2 / Td Booster with administration dates and batch numbers
- **Infant Vaccines:** National Immunisation Schedule birth doses (BCG, OPV-0, Hepatitis B-0)

### 8. Clinician-Prescribed Medication Tracker
- Active prescriptions: Iron & Folic Acid (IFA), Calcium + Vitamin D3
- Critical Safety Warning Banner: *"Never take Iron and Calcium together; maintain at least a 2-hour gap."*
- Missed dose guidance: *"Do not double up doses; consult doctor or ANM."*
- Daily taken / skipped toggle

### 9. Telangana Nutrition & Diet Planner
- Meal-by-meal guide (Breakfast, Lunch, Evening Snack, Light Dinner) featuring local foods:
  - *Ragi Ambali (రాగి అంబలి)*
  - *Jowar Rotis (జొన్న రొట్టెలు)*
  - *Thotakura / Gongura Pappu (తోటకూర / గోంగూర పప్పు)*
  - *Pesara Pappu Chutney (పెసరపప్పు)*
  - *Fresh Washed Guava (జామపండు - high Vitamin C to absorb iron)*
  - *Boiled Eggs & Curd (మజ్జిగ)*
- Interactive daily hydration counter (+ / - buttons)
- Food safety & hygiene rules (pasteurized dairy, wash vegetables, avoid alcohol/tobacco)

### 10. Government Hospital & Healthcare Directory
- Authentic Telangana facilities: Niloufer Hospital, Petlaburj Maternity Hospital, Koti Maternity Hospital, Gandhi Hospital, Area Hospital Malakpet, MGM Warangal, District Hospital Karimnagar
- Filters by District (*Hyderabad, Warangal, Karimnagar*) and Search Query
- Badges: 24/7 Delivery, C-Section OT, SNCU/NICU, Free Ultrasound, Amma Vodi 102
- One-touch Call and Emergency 108 dispatch

### 11. Emergency & Danger Signs Module
- High-contrast emergency interface
- **Huge "CALL 108 NOW" Ambulance Button**
- **Amma Vodi (102) Transport Button**
- Danger signs triage guide:
  - Vaginal bleeding (రక్తస్రావం)
  - Water bag breakage / fluid leakage (ఉమ్మనీరు లీకేజ్)
  - Severe continuous abdominal pain (తీవ్రమైన కడుపు నొప్పి)
  - Severe headache & blurring vision (High BP / Pre-eclampsia)
  - Reduced fetal movements (శిశువు కదలికలు తగ్గడం)
  - Convulsions or fits (మూర్ఛ)
- What to tell the emergency doctor checklist

### 12. Delivery Planning & Postnatal Care
- Hospital delivery bag interactive checklist (MCP card, Aadhaar, baby clothes, sanitary pads)
- Postnatal recovery guidelines for the first 42 days
- Early breastfeeding initiation within 1 hour (Colostrum / ముర్రుపాలు)
- Caesarean / Episiotomy wound care

### 13. Profile & Clinical Governance
- Full mother profile, LMP & EDD summary
- Language toggle (English / Telugu)
- Assigned ASHA Worker & Emergency Family Contact cards
- Statutory Clinical Disclaimer and DPDP Act compliance notices

---

## 🏛️ Project Directory Structure

```text
D:\MaaCareTelangana/
├── android/
│   └── app/src/main/AndroidManifest.xml
├── lib/
│   ├── main.dart                          # Application entry point & localization provider
│   ├── app/
│   │   ├── theme.dart                     # Maternal Rose & Healthcare Teal Material 3 theme
│   │   └── localization.dart              # Complete English & Telugu (తెలుగు) dictionaries
│   ├── core/
│   │   ├── models/
│   │   │   ├── pregnancy_model.dart       # LMP, EDD, Gestational Age, Trimester model
│   │   │   ├── appointment_model.dart     # ANC Visit schedule & MCP card model
│   │   │   ├── medication_model.dart      # IFA, Calcium, prescription tracking model
│   │   │   ├── vaccine_model.dart         # Maternal Td & Infant birth doses model
│   │   │   ├── medical_record_model.dart  # Hb, Ultrasound, Lab test results model
│   │   │   ├── hospital_model.dart        # Telangana UPHC, PHC, Maternity Hospital model
│   │   │   └── nutrition_model.dart       # Telangana diet & nutrient model
│   │   ├── state/
│   │   │   └── app_state.dart             # Reactive state management with ChangeNotifier
│   │   └── data/
│   │       └── mock_data.dart             # Authentic Telangana medical & facility repository
│   └── features/
│       ├── auth/
│       │   ├── auth_screen.dart           # OTP login, consent, and language selection
│       │   └── pregnancy_setup_screen.dart# LMP entry, EDD calculation, high-risk flag
│       ├── dashboard/
│       │   ├── main_navigation_shell.dart # 5-tab NavigationBar & Floating Emergency 108
│       │   └── home_dashboard_screen.dart # Hero card, baby growth, medicines, nutrition
│       ├── pregnancy_tracker/
│       │   └── pregnancy_tracker_screen.dart # 40-week timeline, baby milestones, warnings
│       ├── antenatal_care/
│       │   └── antenatal_care_screen.dart # ANC checkup calendar & MCP card checklist
│       ├── medical_records/
│       │   └── medical_records_screen.dart# Lab test reports, normal ranges, doctor notes
│       ├── vaccinations/
│       │   └── vaccinations_screen.dart   # Td vaccines & Infant immunisation cards
│       ├── medications/
│       │   └── medications_screen.dart    # Prescribed supplements & safety instructions
│       ├── nutrition/
│       │   └── nutrition_screen.dart      # Telangana diet plan & hydration tracker
│       ├── hospitals/
│       │   └── hospitals_screen.dart      # Government hospital directory & search
│       ├── emergency/
│       │   └── emergency_screen.dart      # Call 108 & danger signs triage
│       ├── delivery_postnatal/
│       │   └── delivery_postnatal_screen.dart # Hospital bag checklist & 42-day recovery
│       └── profile/
│           └── profile_screen.dart        # User profile, ASHA contact, clinical disclaimer
├── test/
│   └── pregnancy_calculation_test.dart    # Unit tests for EDD & gestational math
└── pubspec.yaml                           # Flutter dependencies & metadata
```

---

## 🚀 How to Run the App

1. Ensure the Flutter SDK is installed and added to your `PATH`.
2. Open terminal in `D:\MaaCareTelangana`:
   ```bash
   cd D:\MaaCareTelangana
   ```
3. Fetch packages:
   ```bash
   flutter pub get
   ```
4. Run tests:
   ```bash
   flutter test
   ```
5. Run on an Android device or emulator:
   ```bash
   flutter run
   ```
6. Build release APK:
   ```bash
   flutter build apk --release
   ```

---

## ⚕️ Clinical Governance & Safety Notice

This application strictly implements the governance mandates of PRD Section 10:
- It **does not** generate medical diagnoses using AI or unvalidated algorithms.
- It **does not** independently calculate or change drug doses.
- In case of missed medication, it explicitly instructs the mother **not** to take a double dose and to seek clinician counsel.
- Direct **108 Emergency Ambulance** and **102 Amma Vodi** contact numbers are surfaced without requiring login or complex navigation.
