import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';
import 'pregnancy_setup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  final _otpController = TextEditingController(text: '123456');
  bool _otpSent = false;
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AppTheme.emergencyRed,
        ),
      );
      return;
    }
    setState(() {
      _otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo OTP sent: 123456'),
        backgroundColor: AppTheme.secondaryTeal,
      ),
    );
  }

  void _handleVerifyAndLogin() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the health data privacy notice to continue'),
          backgroundColor: AppTheme.emergencyRed,
        ),
      );
      return;
    }
    final appState = Provider.of<AppState>(context, listen: false);
    appState.login(_phoneController.text.trim());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PregnancySetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => appState.toggleLanguage(),
            icon: const Icon(Icons.language, color: AppTheme.primaryRose),
            label: Text(
              appState.isTelugu ? 'English' : 'తెలుగు',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryRose,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Maternal Symbol
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryRose.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pregnant_woman_rounded,
                      size: 54,
                      color: AppTheme.primaryRose,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                loc.t('app_name'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.t('app_tagline'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified, size: 16, color: AppTheme.secondaryTeal),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        loc.t('gov_initiative'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Login Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.isTelugu
                            ? 'మొబైల్ నంబర్ ద్వారా లాగిన్ అవ్వండి'
                            : 'Login with Mobile Number',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appState.isTelugu
                            ? 'మీ గర్భధారణ వివరాలు మరియు ప్రభుత్వ పథకాల సమాచారం పొందండి'
                            : 'Enter your 10-digit mobile number for secure OTP verification.',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Phone Input
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone_android, color: AppTheme.primaryRose),
                          prefixText: '+91 ',
                          labelText: appState.isTelugu ? 'మొబైల్ నంబర్' : 'Mobile Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          counterText: '',
                        ),
                      ),

                      if (_otpSent) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.secondaryTeal),
                            labelText: appState.isTelugu ? 'OTP కోడ్' : '6-Digit OTP',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            counterText: '',
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Terms & Consent
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            activeColor: AppTheme.primaryRose,
                            onChanged: (val) => setState(() => _acceptedTerms = val ?? true),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                              child: Text(
                                appState.isTelugu
                                    ? 'నేను ఆరోగ్య డేటా గోప్యత మరియు వినియోగ నిబంధనలను అంగీకరిస్తున్నాను'
                                    : 'I agree to the maternal health data privacy notice & informed consent.',
                                style: const TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Main Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _otpSent ? _handleVerifyAndLogin : _handleSendOtp,
                          child: Text(
                            _otpSent
                                ? (appState.isTelugu ? 'ధృవీకరించి కొనసాగండి' : 'Verify & Continue')
                                : (appState.isTelugu ? 'OTP పంపండి' : 'Request OTP'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Emergency 108 direct button without login (PRD Section 4.11 requirement: basic emergency accessible without barriers)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.emergencyRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.emergencyRed.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emergency_outlined, color: AppTheme.emergencyRed, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.isTelugu ? 'అత్యవసర వైద్య సహాయం కావాలా?' : 'Medical Emergency?',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.emergencyRed,
                            ),
                          ),
                          Text(
                            loc.t('call_108'),
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dialing Telangana 108 Emergency Ambulance...'),
                            backgroundColor: AppTheme.emergencyRed,
                          ),
                        );
                      },
                      child: const Text('108', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
