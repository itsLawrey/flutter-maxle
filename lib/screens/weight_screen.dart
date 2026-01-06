import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/weight_entry.dart';
import '../widgets/app_drawer.dart';
import 'weight_graph_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  void _showAddWeightDialog(BuildContext context) {
    final TextEditingController weightController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            'Log Weight',
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBB86FC)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: [
                      Text(
                        DateFormat('MMM d, y').format(selectedDate),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Color(0xFFBB86FC),
                                    onPrimary: Colors.black,
                                    surface: Color(0xFF1E1E1E),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Change Date'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final weight = double.tryParse(weightController.text);
                if (weight == null || weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid weight greater than 0 kg',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Provider.of<AppProvider>(context, listen: false).addWeightEntry(
                  WeightEntry(
                    id: const Uuid().v4(),
                    date: selectedDate,
                    weight: weight,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'WEIGHT LOG',
          style: GoogleFonts.outfit(letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightGraphScreen()),
              );
            },
          ),
        ],
      ),

      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWeightDialog(context),
        backgroundColor: const Color(0xFF03DAC6),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Log Weight'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final weeklyAvg = provider.currentWeeklyAverage;
          final prevWeeklyAvg = provider.previousWeeklyAverage;

          return Column(
            children: [
              // Summary Section
              if (provider.weightLogs.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFBB86FC).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'This Week\'s Average',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weeklyAvg != null
                            ? '${weeklyAvg.toStringAsFixed(1)} kg'
                            : '--',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (weeklyAvg != null && prevWeeklyAvg != null) ...[
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final difference = weeklyAvg - prevWeeklyAvg;
                            final percentage =
                                (difference / prevWeeklyAvg) * 100;
                            final isPositive = percentage > 0;
                            final isZero = percentage == 0;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isZero
                                      ? Icons.remove
                                      : isPositive
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isZero
                                      ? Colors.grey
                                      : isPositive
                                      ? Colors.redAccent
                                      : Colors.greenAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${percentage.abs().toStringAsFixed(1)}%',
                                  style: GoogleFonts.outfit(
                                    color: isZero
                                        ? Colors.grey
                                        : isPositive
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

              // Existing List
              Expanded(
                child: provider.weightLogs.isEmpty
                    ? Center(
                        child: Text(
                          'No logs yet.\nStart tracking your progress!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.weightLogs.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final entry = provider.weightLogs[index];
                          return Card(
                            color: const Color(0xFF1E1E1E),
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFBB86FC,
                                  ).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.monitor_weight_outlined,
                                  color: Color(0xFFBB86FC),
                                ),
                              ),
                              title: Text(
                                '${entry.weight} kg',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('EEEE, MMM d, y').format(entry.date),
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  provider.removeWeightEntry(entry.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
