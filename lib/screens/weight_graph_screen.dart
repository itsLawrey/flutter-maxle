import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/weight_entry.dart';

class WeightGraphScreen extends StatefulWidget {
  const WeightGraphScreen({super.key});

  @override
  State<WeightGraphScreen> createState() => _WeightGraphScreenState();
}

class _WeightGraphScreenState extends State<WeightGraphScreen> {
  bool _showWeeklyAverages = false;

  Map<DateTime, double> _calculateWeeklyAverages(List<WeightEntry> logs) {
    if (logs.isEmpty) return {};

    final Map<DateTime, List<double>> weeklyGroups = {};

    for (var entry in logs) {
      final date = entry.date;
      // Calculate Monday of the week
      final monday = DateTime(
        date.year,
        date.month,
        date.day,
      ).subtract(Duration(days: date.weekday - 1));

      if (!weeklyGroups.containsKey(monday)) {
        weeklyGroups[monday] = [];
      }
      weeklyGroups[monday]!.add(entry.weight);
    }

    final Map<DateTime, double> averages = {};
    weeklyGroups.forEach((monday, weights) {
      final avg = weights.reduce((a, b) => a + b) / weights.length;
      averages[monday] = avg;
    });

    return averages;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final weeklyAverages = _calculateWeeklyAverages(provider.weightLogs);
        final canShowWeekly = weeklyAverages.length >= 2;

        // If data changes and we can no longer show weekly, reset toggle
        if (!canShowWeekly && _showWeeklyAverages) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _showWeeklyAverages = false;
              });
            }
          });
        }

        final sortedLogs = List.of(provider.weightLogs)
          ..sort((a, b) => a.date.compareTo(b.date));

        // Prepare display data
        List<FlSpot> spots = [];
        if (_showWeeklyAverages && canShowWeekly) {
          final sortedWeeks = weeklyAverages.keys.toList()..sort();
          spots = sortedWeeks
              .map(
                (date) => FlSpot(
                  date.millisecondsSinceEpoch.toDouble(),
                  weeklyAverages[date]!,
                ),
              )
              .toList();
        } else {
          spots = sortedLogs
              .map(
                (e) =>
                    FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.weight),
              )
              .toList();
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            title: Text('PROGRESS', style: GoogleFonts.outfit()),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (canShowWeekly)
                IconButton(
                  icon: Icon(
                    _showWeeklyAverages
                        ? Icons.calendar_view_week
                        : Icons.show_chart,
                    color: _showWeeklyAverages
                        ? const Color(0xFFBB86FC)
                        : Colors.white54,
                  ),
                  tooltip: _showWeeklyAverages
                      ? 'Show All Logs'
                      : 'Show Weekly Averages',
                  onPressed: () {
                    setState(() {
                      _showWeeklyAverages = !_showWeeklyAverages;
                    });
                  },
                ),
            ],
          ),
          body: provider.weightLogs.length < 2
              ? Center(
                  child: Text(
                    'Need at least 2 logs to show a graph.',
                    style: GoogleFonts.outfit(color: Colors.white54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    left: 12,
                    top: 24,
                    bottom: 24,
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: Colors.white10,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: _showWeeklyAverages
                                ? 86400000 *
                                      14 // 2 weeks interval if weekly view
                                : 86400000 * 5, // 5 days interval if daily view
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt(),
                              );
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MM/dd').format(date),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFBB86FC), Color(0xFF03DAC6)],
                          ),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFBB86FC).withValues(alpha: 0.3),
                                const Color(0xFF03DAC6).withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      // Add tooltips to show exact value and date
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                barSpot.x.toInt(),
                              );
                              return LineTooltipItem(
                                '${DateFormat('MMM d').format(date)}\n${barSpot.y.toStringAsFixed(1)} kg',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                          getTooltipColor: (Spot) =>
                              const Color(0xFF1E1E1E).withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
