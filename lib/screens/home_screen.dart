import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';
import '../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'MAXLE',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final streakCount = provider.streak.count;
          final hasCheckedIn = provider.hasCheckedInToday;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$streakCount',
                  style: GoogleFonts.outfit(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFBB86FC),
                  ),
                ),
                Text(
                  'DAY STREAK',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    color: Colors.white54,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: hasCheckedIn
                      ? null
                      : () {
                          provider.checkIn();
                        },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasCheckedIn
                          ? LinearGradient(
                              colors: [Colors.grey[800]!, Colors.grey[900]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFBB86FC), Color(0xFF3700B3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: hasCheckedIn
                              ? Colors.black26
                              : const Color(0xFFBB86FC).withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        hasCheckedIn
                            ? Icons.check
                            : Icons.local_fire_department,
                        size: 80,
                        color: hasCheckedIn ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  hasCheckedIn ? 'CHECKED IN' : 'TAP TO CHECK IN',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: hasCheckedIn ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
