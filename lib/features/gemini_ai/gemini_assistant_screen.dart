import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/services/gemini_service.dart';
import '../../core/models/medical_record_model.dart';
import '../../core/models/appointment_model.dart';
import '../../core/models/medication_model.dart';
import '../../app/theme.dart';

class GeminiAssistantScreen extends StatefulWidget {
  final String? initialTopic;

  const GeminiAssistantScreen({super.key, this.initialTopic});

  @override
  State<GeminiAssistantScreen> createState() => _GeminiAssistantScreenState();
}

class _ChatMessage {
  final String sender; // 'user' or 'gemini'
  final String text;
  final GeminiReportAnalysis? reportAnalysis;
  final GeminiPrescriptionAnalysis? prescriptionAnalysis;
  final DateTime timestamp;

  _ChatMessage({
    required this.sender,
    required this.text,
    this.reportAnalysis,
    this.prescriptionAnalysis,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class _GeminiAssistantScreenState extends State<GeminiAssistantScreen> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addInitialWelcomeMessage();
    if (widget.initialTopic != null) {
      _handleTopicSelection(widget.initialTopic!);
    }
  }

  void _addInitialWelcomeMessage() {
    final appState = Provider.of<AppState>(context, listen: false);
    final welcomeText = appState.isTelugu
        ? 'నమస్కారం! నేను మీ MaaCare జెమిని AI మాతృత్వ సహాయకురాలిని. గర్భస్రావం నివారణ, ప్రయాణాల్లో జాగ్రత్తలు, తినకూడని ఆహారాలు, బరువు పెరగడం, లేదా పాతకాలపు అమ్మమ్మల చిట్కాల గురించి నన్ను అడగవచ్చు. మీ ల్యాబ్ రిపోర్టులు లేదా ప్రిస్క్రిప్షన్ ఫోటోలను కూడా స్కాన్ చేయవచ్చు!'
        : 'Hello! I am your MaaCare Gemini AI Maternal Health Companion. You can ask me how to avoid miscarriage, precautions while traveling, foods to avoid, healthy weight gain, or Granny\'s traditional remedies. You can also scan your medical reports or prescription photos!';

    _messages.add(_ChatMessage(sender: 'gemini', text: welcomeText));
  }

  Future<void> _handleTopicSelection(String topic) async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _messages.add(_ChatMessage(sender: 'user', text: topic));
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await GeminiService.getMaternalGuidance(
      topic,
      isTelugu: appState.isTelugu,
      profile: appState.profile,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(sender: 'gemini', text: response));
      });
      _scrollToBottom();
    }
  }

  Future<void> _handleSendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      _messages.add(_ChatMessage(sender: 'user', text: text));
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await GeminiService.getMaternalGuidance(
      text,
      isTelugu: appState.isTelugu,
      profile: appState.profile,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(sender: 'gemini', text: response));
      });
      _scrollToBottom();
    }
  }

  Future<void> _scanReport(ImageSource source) async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      final pickedFile = await _picker.pickImage(source: source, maxWidth: 1600, maxHeight: 1600);
      if (pickedFile == null) return;

      setState(() {
        _messages.add(_ChatMessage(
          sender: 'user',
          text: appState.isTelugu ? '📄 ల్యాబ్ రిపోర్ట్ స్కాన్ చేస్తున్నాను...' : '📄 Scanning medical test report...',
        ));
        _isLoading = true;
      });
      _scrollToBottom();

      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final analysis = await GeminiService.analyzeReport(
        base64Image: base64Image,
        mimeType: 'image/jpeg',
        isTelugu: appState.isTelugu,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add(_ChatMessage(
            sender: 'gemini',
            text: appState.isTelugu
                ? 'మీ రిపోర్టును జెమిని AI విశ్లేషించింది. వివరాలు క్రింద ఇవ్వబడ్డాయి:'
                : 'Gemini AI has analyzed your medical report. Here are the clinical insights:',
            reportAnalysis: analysis,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning report: $e'), backgroundColor: AppTheme.emergencyRed),
        );
      }
    }
  }

  Future<void> _scanPrescription(ImageSource source) async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      final pickedFile = await _picker.pickImage(source: source, maxWidth: 1600, maxHeight: 1600);
      if (pickedFile == null) return;

      setState(() {
        _messages.add(_ChatMessage(
          sender: 'user',
          text: appState.isTelugu ? '💊 ప్రిస్క్రిప్షన్ ఫోటో స్కాన్ చేస్తున్నాను...' : '💊 Scanning medicine prescription photo...',
        ));
        _isLoading = true;
      });
      _scrollToBottom();

      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final analysis = await GeminiService.analyzePrescriptionImage(
        base64Image: base64Image,
        mimeType: 'image/jpeg',
        isTelugu: appState.isTelugu,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add(_ChatMessage(
            sender: 'gemini',
            text: appState.isTelugu
                ? 'డాక్టర్ ప్రిస్క్రిప్షన్‌ను జెమిని AI విశ్లేషించింది. మందులు మరియు కారణాలు:'
                : 'Gemini AI analyzed the prescription. Details, clinical reasoning & medicines:',
            prescriptionAnalysis: analysis,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning prescription: $e'), backgroundColor: AppTheme.emergencyRed),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showApiKeyDialog() {
    final controller = TextEditingController(text: GeminiService.apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppTheme.primaryRose),
            SizedBox(width: 8),
            Text('Gemini API Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your Google Gemini API Key for live AI responses and multimodal vision analysis. If left empty, built-in clinical guidance is used.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              GeminiService.setApiKey(controller.text.trim());
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gemini API Key updated!'), backgroundColor: AppTheme.secondaryTeal),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final quickTopics = [
      {'label': appState.isTelugu ? '🛡️ గర్భస్రావం నివారణ' : '🛡️ Prevent Miscarriage', 'query': 'How to avoid miscarriage during pregnancy?'},
      {'label': appState.isTelugu ? '🚗 ప్రయాణాల్లో జాగ్రత్తలు' : '🚗 Journey & Travel Precautions', 'query': 'How to take precautions while journey and when to avoid travel?'},
      {'label': appState.isTelugu ? '🚫 తినకూడని ఆహారాలు' : '🚫 Foods to Strictly Avoid', 'query': 'What kind of foods should be strictly avoided in pregnancy?'},
      {'label': appState.isTelugu ? '📈 బరువు పెరగడం' : '📈 Healthy Weight Gain', 'query': 'How to safely increase maternal and baby weight?'},
      {'label': appState.isTelugu ? '👵 అమ్మమ్మ పాతకాలపు చిట్కాలు' : '👵 Granny\'s Natural Remedies & Courage', 'query': 'Natural remedies and courage followed by grandmothers in olden days for pregnancy'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.purple, AppTheme.primaryRose]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appState.isTelugu ? 'MaaCare జెమిని AI సలహాదారు' : 'MaaCare Gemini AI Advisor',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    appState.isTelugu ? 'క్లినికల్ విశ్లేషణ & సాంప్రదాయ మార్గదర్శి' : 'Clinical Reports & Maternal Wisdom',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Gemini API Key',
            onPressed: _showApiKeyDialog,
            icon: const Icon(Icons.key, color: AppTheme.primaryRose),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Horizontal Chips
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: quickTopics.length,
              itemBuilder: (context, index) {
                final topic = quickTopics[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    backgroundColor: AppTheme.primaryLight.withOpacity(0.5),
                    side: BorderSide(color: AppTheme.primaryRose.withOpacity(0.3)),
                    label: Text(
                      topic['label']!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                    ),
                    onPressed: () => _handleTopicSelection(topic['query']!),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageItem(msg, appState);
              },
            ),
          ),

          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryRose)),
                  const SizedBox(width: 10),
                  Text(
                    appState.isTelugu ? 'జెమిని AI ఆలోచిస్తోంది...' : 'Gemini AI is analyzing...',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

          // Bottom Input & Scanner Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Scan Report Button
                  IconButton(
                    tooltip: appState.isTelugu ? 'ల్యాబ్ రిపోర్ట్ ఫోటో' : 'Scan Lab Report',
                    onPressed: () => _showScanOptions(isReport: true),
                    icon: const Icon(Icons.document_scanner, color: AppTheme.secondaryTeal),
                  ),
                  // Scan Prescription Button
                  IconButton(
                    tooltip: appState.isTelugu ? 'ప్రిస్క్రిప్షన్ ఫోటో' : 'Scan Prescription',
                    onPressed: () => _showScanOptions(isReport: false),
                    icon: const Icon(Icons.camera_alt, color: AppTheme.primaryRose),
                  ),
                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _handleSendText(),
                      decoration: InputDecoration(
                        hintText: appState.isTelugu ? 'మీ సందేహాన్ని అడగండి...' : 'Ask pregnancy question...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppTheme.primaryRose),
                    onPressed: _handleSendText,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(_ChatMessage msg, AppState appState) {
    final isUser = msg.sender == 'user';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isUser) ...[
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppTheme.primaryRose,
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 6),
                const Text('MaaCare Gemini', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUser ? AppTheme.primaryRose : Colors.white,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),

          // If this message contains a Report Analysis
          if (msg.reportAnalysis != null) _buildReportCard(msg.reportAnalysis!, appState),

          // If this message contains a Prescription Analysis
          if (msg.prescriptionAnalysis != null) _buildPrescriptionCard(msg.prescriptionAnalysis!, appState),
        ],
      ),
    );
  }

  Widget _buildReportCard(GeminiReportAnalysis report, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.testName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: report.status == 'normal' ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  report.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: report.status == 'normal' ? Colors.green.shade800 : Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${appState.isTelugu ? 'ఫలితం' : 'Measured Result'}: ${report.resultValue} (${appState.isTelugu ? 'సాధారణ పరిధి' : 'Normal'}: ${report.normalRange})',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(report.summary, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const Divider(height: 16),
          Text(
            appState.isTelugu ? 'తదుపరి తనిఖీ సూచన:' : 'Suggested Checkup Schedule:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(report.suggestedNextCheckup, style: const TextStyle(fontSize: 12, color: Colors.teal)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              // Auto-add to Medical Records and Schedule Next Checkup
              appState.addMedicalRecord(
                MedicalRecordItem(
                  id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
                  testName: report.testName,
                  testNameTe: report.testName,
                  category: 'Lab Scan',
                  recordedValue: report.resultValue,
                  normalRange: report.normalRange,
                  testDate: DateTime.now(),
                  facility: 'Gemini AI Verified Lab Scan',
                  reviewStatus: report.status == 'normal' ? TestReviewStatus.normal : TestReviewStatus.requiresReview,
                  clinicalNotes: report.summary,
                  clinicalNotesTe: report.summary,
                ),
              );
              // Also add suggested checkup
              appState.addAppointment(
                ANCAppointment(
                  id: 'anc_ai_${DateTime.now().millisecondsSinceEpoch}',
                  title: 'ANC Follow-up (${report.testName})',
                  titleTe: 'ANC పునఃపరిశీలన (${report.testName})',
                  visitNumber: appState.appointments.length + 1,
                  scheduledDate: DateTime.now().add(const Duration(days: 28)),
                  facilityName: appState.profile.preferredHospital,
                  doctorOrWorker: 'Obstetrician / Medical Officer',
                  notes: report.suggestedNextCheckup,
                  notesTe: report.suggestedNextCheckup,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appState.isTelugu
                      ? 'రిపోర్ట్ రికార్డు మరియు తదుపరి పరీక్ష విజయవంతంగా జోడించబడ్డాయి!'
                      : 'Report saved and next checkup added to your schedule!'),
                  backgroundColor: AppTheme.secondaryTeal,
                ),
              );
            },
            icon: const Icon(Icons.bookmark_add, size: 16),
            label: Text(
              appState.isTelugu ? 'రిపోర్ట్ & చెకప్ నమోదు చేయండి' : 'Save to Records & Schedule Checkup',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(GeminiPrescriptionAnalysis prescription, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_information, color: Colors.deepOrange, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${appState.isTelugu ? 'రోగ నిర్ధారణ కారణం' : 'Diagnosed Reason'}: ${prescription.diagnosisCause}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepOrange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(prescription.clinicalReason, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const Divider(height: 16),
          Text(
            appState.isTelugu ? 'గుర్తించబడిన మందులు:' : 'Identified Medicines:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          ...prescription.medicines.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: AppTheme.primaryRose),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${m['name']} (${m['strength']}) - ${m['timing']} - ${m['instructions']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRose,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              for (final m in prescription.medicines) {
                appState.addMedication(
                  MedicationItem(
                    id: 'med_ai_${DateTime.now().millisecondsSinceEpoch}_${m['name']}',
                    name: m['name'] ?? 'Prescribed Medicine',
                    nameTe: m['name'] ?? 'వైద్యుల మందు',
                    strength: m['strength'] ?? 'Standard Dose',
                    dosageSchedule: m['timing'] ?? 'As Prescribed',
                    dosageScheduleTe: m['timing'] ?? 'డాక్టర్ సూచించినట్లు',
                    foodInstructions: m['instructions'] ?? 'Follow doctor instruction',
                    foodInstructionsTe: m['instructions'] ?? 'డాక్టర్ సూచనల ప్రకారం',
                    prescribedBy: 'Extracted from Prescription Photo',
                    startDate: DateTime.now(),
                  ),
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appState.isTelugu ? 'మందులు మీ ఔషధాల జాబితాకు చేర్చబడ్డాయి!' : 'Medicines added to your Daily Medication Tracker!'),
                  backgroundColor: AppTheme.primaryRose,
                ),
              );
            },
            icon: const Icon(Icons.playlist_add, size: 16),
            label: Text(
              appState.isTelugu ? 'మందులను ట్రాకర్‌లో చేర్చండి' : 'Add to Daily Medication Tracker',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showScanOptions({required bool isReport}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryRose),
              title: Text(isReport ? 'Take Photo of Medical Report' : 'Take Photo of Prescription'),
              onTap: () {
                Navigator.of(ctx).pop();
                if (isReport) {
                  _scanReport(ImageSource.camera);
                } else {
                  _scanPrescription(ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.secondaryTeal),
              title: Text(isReport ? 'Choose Report from Gallery' : 'Choose Prescription from Gallery'),
              onTap: () {
                Navigator.of(ctx).pop();
                if (isReport) {
                  _scanReport(ImageSource.gallery);
                } else {
                  _scanPrescription(ImageSource.gallery);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
