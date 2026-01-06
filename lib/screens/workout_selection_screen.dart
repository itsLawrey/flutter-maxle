import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout_models.dart';
import '../widgets/app_drawer.dart';
import 'active_workout_screen.dart';

class WorkoutSelectionScreen extends StatelessWidget {
  const WorkoutSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Your Workout'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Area',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildAreaGrid(context, provider),
                    const SizedBox(height: 32),
                    Text(
                      'Select Location',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildLocationSelector(context, provider),
                  ],
                ),
              ),
            ),
            _buildStartButton(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaGrid(BuildContext context, WorkoutProvider provider) {
    // Custom mapping for display names
    final Map<WorkoutArea, String> areaNames = {
      WorkoutArea.bicepBack: 'Bicep & Back',
      WorkoutArea.tricepChest: 'Tricep & Chest',
      WorkoutArea.legsShoulders: 'Legs & Shoulders',
      WorkoutArea.stretching: 'Stretching',
    };

    final Map<WorkoutArea, IconData> areaIcons = {
      WorkoutArea.bicepBack: Icons.fitness_center,
      WorkoutArea.tricepChest: Icons.accessibility_new,
      WorkoutArea.legsShoulders: Icons.directions_run,
      WorkoutArea.stretching: Icons.self_improvement,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: WorkoutArea.values.length,
      itemBuilder: (context, index) {
        final area = WorkoutArea.values[index];
        final isSelected = provider.selectedArea == area;

        return GestureDetector(
          onTap: () => provider.selectArea(area),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  areaIcons[area],
                  size: 40,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  areaNames[area]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSelector(
    BuildContext context,
    WorkoutProvider provider,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: WorkoutLocation.values.asMap().entries.map((entry) {
              final index = entry.key;
              final location = entry.value;
              final isSelected = provider.selectedLocation == location;
              String label = location.name.toUpperCase();
              if (location == WorkoutLocation.home) label = "HOME WORKOUT";
              if (location == WorkoutLocation.gym) label = "GYM";
              if (location == WorkoutLocation.calisthenics)
                label = "CALISTHENICS";

              return Padding(
                padding: EdgeInsets.only(
                  right: index == WorkoutLocation.values.length - 1 ? 0 : 12,
                ),
                child: FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (_) => provider.selectLocation(location),
                  // checkmarkColor: Colors.black, // No longer needed
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, WorkoutProvider provider) {
    final bool canStart =
        provider.selectedArea != null && provider.selectedLocation != null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: canStart
              ? () {
                  provider.startWorkout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActiveWorkoutScreen(),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          child: const Text(
            'START WORKOUT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
