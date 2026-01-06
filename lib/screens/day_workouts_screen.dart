import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout_models.dart';

class DayWorkoutsScreen extends StatelessWidget {
  final DateTime selectedDate;

  const DayWorkoutsScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, y').format(selectedDate);
    final workouts = Provider.of<WorkoutProvider>(
      context,
    ).getWorkoutsForDate(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          formattedDate.toUpperCase(),
          style: GoogleFonts.outfit(letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: workouts.isEmpty
          ? Center(
              child: Text(
                'No workouts logged.',
                style: GoogleFonts.outfit(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: workouts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = workouts[index];
                final time = DateFormat('jm').format(log.date); // e.g. 5:30 PM

                return Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconForArea(log.area),
                          color: const Color(0xFFBB86FC),
                          size: 24,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatArea(log.area),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatLocation(log.location),
                                style: GoogleFonts.outfit(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: GoogleFonts.outfit(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: log.completed
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.orange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              log.completed ? 'Completed' : 'Incomplete',
                              style: GoogleFonts.outfit(
                                color: log.completed
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        if (log.exercises.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "No exercises recorded for this workout.",
                              style: GoogleFonts.outfit(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          ...log.exercises.map((exercise) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      exercise.name,
                                      style: GoogleFonts.outfit(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${exercise.sets} x ${exercise.reps}",
                                    style: GoogleFonts.outfit(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Duration: ${log.duration} min',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFBB86FC),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForArea(WorkoutArea area) {
    switch (area) {
      case WorkoutArea.bicepBack:
        return Icons.fitness_center;
      case WorkoutArea.tricepChest:
        return Icons.accessibility_new;
      case WorkoutArea.legsShoulders:
        return Icons.directions_run;
      case WorkoutArea.stretching:
        return Icons.self_improvement;
    }
  }

  String _formatArea(WorkoutArea area) {
    switch (area) {
      case WorkoutArea.bicepBack:
        return "Bicep & Back";
      case WorkoutArea.tricepChest:
        return "Tricep & Chest";
      case WorkoutArea.legsShoulders:
        return "Legs & Shoulders";
      case WorkoutArea.stretching:
        return "Stretching";
    }
  }

  String _formatLocation(WorkoutLocation location) {
    switch (location) {
      case WorkoutLocation.gym:
        return "Gym";
      case WorkoutLocation.home:
        return "Home";
      case WorkoutLocation.calisthenics:
        return "Calisthenics";
    }
  }
}
