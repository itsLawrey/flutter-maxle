import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/home_screen.dart';
import 'screens/weight_screen.dart';

import 'screens/workout_selection_screen.dart';
import 'screens/active_workout_screen.dart';
import 'utils/loader_utils.dart';

void main() {
  runApp(const MaxleApp());
}

class MaxleApp extends StatelessWidget {
  const MaxleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: MaterialApp(
        title: 'Maxle',
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFBB86FC),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFBB86FC),
            secondary: Color(0xFF03DAC6),
            surface: Color(0xFF1E1E1E),
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: const MainScaffold(),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 1;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Check for active workout after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      removeWebLoadingIndicator();
      await _checkActiveWorkout();
    });
  }

  Future<void> _checkActiveWorkout() async {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    final hasActive = await provider.checkActiveWorkout();

    if (hasActive && mounted) {
      // Per user request: ALWAYS ask to resume, regardless of date.
      // If resumed: Continue.
      // If NOT resumed: Save as incomplete with ORIGINAL start date/duration.

      final startTime = provider.activeWorkoutStartTime;
      String dateStr = "an active workout";
      if (startTime != null) {
        dateStr = "a workout started on ${startTime.day}/${startTime.month}";
      }

      final resume = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Resume Workout?'),
          content: Text(
            'You have $dateStr in progress. Do you want to resume it?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No, Finish & Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Resume'),
            ),
          ],
        ),
      );

      if (resume == true) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ActiveWorkoutScreen(),
            ),
          );
        }
      } else {
        // User chose NOT to resume.
        // Save as incomplete, using the ORIGINAL start date.
        // The provider's finishWorkout method already handles using the stored start date.
        await provider.finishWorkout(completed: false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout saved to history (incomplete).'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const WeightScreen(),
    const HomeScreen(),
    const WorkoutSelectionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Optional: for nicer feel
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: const Color(0xFFBB86FC),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_weight),
              label: 'Weight',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on),
              label: 'Streak',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Workout',
            ),
          ],
        ),
      ),
    );
  }
}
