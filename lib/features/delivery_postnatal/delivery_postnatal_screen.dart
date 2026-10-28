import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class DeliveryPostnatalScreen extends StatefulWidget {
  const DeliveryPostnatalScreen({super.key});

  @override
  State<DeliveryPostnatalScreen> createState() => _DeliveryPostnatalScreenState();
}

class _DeliveryPostnatalScreenState extends State<DeliveryPostnatalScreen> {
  final Map<String, bool> _hospitalBagItems = {
    'MCP Card (Mother & Child Protection Card)': true,
    'Aadhaar Card of Mother & Father': true,
    'All Previous Ultrasound Scans & Lab Reports': true,
    '3-4 Sets of Clean, Washed Cotton Clothes for Baby': false,
    'Maternity Sanitary Pads & Clean Undergarments': false,
    'Warm Baby Blanket / Soft Wrapping Cloths': false,
    'Personal Toiletries, Soap & Clean Towel': false,
    'Contact Numbers of 108, Amma Vodi 102 & ASHA Worker': true,
  };

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appState.isTelugu ? 'ప్రసవ సన్నద్ధత & ప్రసవానంతర సంరక్షణ' : 'Delivery & Postnatal Care',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryRose,
            labelColor: AppTheme.primaryRose,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: appState.isTelugu ? 'ప్రసవ సంచి & ఏర్పాట్లు' : 'Hospital Bag Checklist'),
              Tab(text: appState.isTelugu ? 'తొలి 42 రోజుల సంరక్షణ' : 'Postnatal Care (42 Days)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Hospital Bag Checklist
            _buildHospitalBagTab(appState, loc),

            // Tab 2: Postnatal & Newborn Care Guide
            _buildPostnatalCareTab(appState, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalBagTab(AppState state, AppLocalizations loc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryRose.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.luggage, color: AppTheme.primaryRose, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.isTelugu
                        ? '36వ వారం నాటికి ఆసుపత్రికి తీసుకెళ్లవలసిన వస్తువుల బ్యాగ్ సిద్ధంగా ఉంచుకోండి.'
                        : 'Keep your hospital bag packed and ready by week 36 for peace of mind.',
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: _hospitalBagItems.keys.map((item) {
                  return CheckboxListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: _hospitalBagItems[item]! ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    activeColor: AppTheme.primaryRose,
                    value: _hospitalBagItems[item],
                    onChanged: (val) {
                      setState(() {
                        _hospitalBagItems[item] = val ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostnatalCareTab(AppState state, AppLocalizations loc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Early Breastfeeding Box
          _buildInfoCard(
            title: state.isTelugu ? 'ముర్రుపాలు (తొలి గంటలోనే ప్రారంభించండి)' : 'Immediate Breastfeeding (Within 1 Hour)',
            desc: state.isTelugu
                ? 'బిడ్డ పుట్టిన మొదటి గంటలోనే ముర్రుపాలు (Colostrum) పట్టించడం శిశువుకు మొట్టమొదటి టీకా వంటిది. ఇది రోగనిరోధక శక్తిని పెంచుతుంది.'
                : 'Initiating breastfeeding within 1 hour provides colostrum, which protects the newborn against severe infections.',
            icon: Icons.baby_changing_station,
            color: AppTheme.secondaryTeal,
          ),
          const SizedBox(height: 12),
          // Caesarean / Episiotomy Wound Care
          _buildInfoCard(
            title: state.isTelugu ? 'గాయం సంరక్షణ (సి-సెక్షన్ & కుట్లు)' : 'Post-Delivery Wound Care',
            desc: state.isTelugu
                ? 'కుట్లు వేసిన భాగాన్ని పొడిగా, శుభ్రంగా ఉంచుకోండి. ఎలాంటి పసుపు లేదా లోషన్లు డాక్టర్ సలహా లేకుండా పూయకండి. అధిక రక్తస్రావం ఉంటే వెంటనే చూపించండి.'
                : 'Keep incision/episiotomy sites dry and clean. Do not apply unauthorized ointments. Report heavy foul-smelling discharge immediately.',
            icon: Icons.healing,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 12),
          // Emotional Wellbeing
          _buildInfoCard(
            title: state.isTelugu ? 'తల్లి మానసిక ఆరోగ్యం (బేబీ బ్లూస్)' : 'Maternal Mental Wellbeing',
            desc: state.isTelugu
                ? 'హార్మోన్ల మార్పుల వల్ల అలసట, ఏడుపు రావడం సహజం. తగినంత నిద్ర, కుటుంబ సభ్యుల సహకారం ముఖ్యం. నిరంతర ఆందోళన ఉంటే ఆరోగ్య సిబ్బందితో మాట్లాడండి.'
                : 'Postpartum fatigue and tearfulness are common. Adequate rest and family support are crucial. Seek guidance if feelings persist.',
            icon: Icons.psychology,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
