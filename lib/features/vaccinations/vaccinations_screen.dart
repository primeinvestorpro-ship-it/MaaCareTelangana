import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/app_state.dart';
import '../../core/models/vaccine_model.dart';
import '../../app/localization.dart';
import '../../app/theme.dart';

class VaccinationsScreen extends StatelessWidget {
  const VaccinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    final maternalVaccines =
        appState.vaccines.where((v) => v.target == VaccineTarget.mother).toList();
    final babyVaccines =
        appState.vaccines.where((v) => v.target == VaccineTarget.baby).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            loc.t('vaccination_title'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryRose,
            labelColor: AppTheme.primaryRose,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: loc.t('maternal_vaccines')),
              Tab(text: loc.t('baby_immunisation')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Maternal Vaccines (Td-1, Td-2)
            _buildVaccineList(maternalVaccines, appState, loc, dateFormat),

            // Tab 2: Baby Birth Doses (National Immunisation Schedule)
            _buildVaccineList(babyVaccines, appState, loc, dateFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineList(
      List<VaccineItem> list, AppState state, AppLocalizations loc, DateFormat df) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final vac = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        state.isTelugu ? vac.nameTe : vac.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: vac.isCompleted ? AppTheme.secondaryLight : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        vac.isCompleted ? loc.t('completed') : loc.t('due_soon'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: vac.isCompleted ? AppTheme.secondaryTeal : Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  state.isTelugu ? vac.recommendedPeriodTe : vac.recommendedPeriod,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                if (vac.isCompleted && vac.administrationDate != null) ...[
                  const Divider(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppTheme.secondaryTeal),
                      const SizedBox(width: 6),
                      Text(
                        '${state.isTelugu ? 'ఇచ్చిన తేదీ' : 'Given On'}: ${df.format(vac.administrationDate!)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (vac.administeredFacility != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${state.isTelugu ? 'ఆసుపత్రి' : 'Facility'}: ${vac.administeredFacility!}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                  if (vac.batchNumber != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Batch No: ${vac.batchNumber!}',
                      style: const TextStyle(fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
