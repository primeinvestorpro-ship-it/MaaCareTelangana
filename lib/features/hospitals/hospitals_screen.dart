import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    final districts = ['All', 'Hyderabad', 'Warangal', 'Karimnagar'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.t('hospitals_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  onChanged: (val) => appState.setFacilitySearch(val),
                  decoration: InputDecoration(
                    hintText: loc.t('search_hospitals'),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // District Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: districts.map((district) {
                      final isSelected = appState.selectedDistrict == district;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(
                            district == 'All'
                                ? (appState.isTelugu ? 'అన్ని జిల్లాలు' : 'All Districts')
                                : district,
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLight,
                          checkmarkColor: AppTheme.primaryRose,
                          onSelected: (_) => appState.setDistrictFilter(district),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Facilities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.filteredFacilities.length,
              itemBuilder: (context, index) {
                final fac = appState.filteredFacilities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_hospital, color: AppTheme.primaryRose),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appState.isTelugu ? fac.nameTe : fac.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    appState.isTelugu ? fac.typeLabelTe : fac.typeLabel,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.secondaryTeal,
                                    ),
                                  ),
                                  Text(
                                    '${fac.mandal}, ${fac.district}',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          fac.address,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        const Divider(height: 18),
                        // Service capability Badges
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (fac.has24x7Delivery)
                              _buildBadge(loc.t('delivery_available'), Colors.green),
                            if (fac.hasCSectionOt)
                              _buildBadge(loc.t('c_section_available'), Colors.blue),
                            if (fac.hasSncuNicu)
                              _buildBadge(loc.t('special_maternal_care'), Colors.purple),
                            if (fac.hasAmmaVodi102)
                              _buildBadge(appState.isTelugu ? 'అమ్మ ఒడి 102 రవాణా' : 'Amma Vodi 102 Transport', Colors.teal),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Calling ${fac.contactNumber}...'),
                                      backgroundColor: AppTheme.secondaryTeal,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.call, size: 16),
                                label: Text(fac.contactNumber),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.emergencyRed,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Dialing 108 Emergency Ambulance...'),
                                    backgroundColor: AppTheme.emergencyRed,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.emergency, size: 16),
                              label: const Text('108'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
