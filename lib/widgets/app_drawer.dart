import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../utils/profile_utils.dart';
import '../screens/history_screen.dart';
import '../screens/personalization_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final avatarColors = [
      const Color(0xFFBB86FC),
      const Color(0xFF03DAC6),
      const Color(0xFFCF6679),
      const Color(0xFF4CAF50),
      const Color(0xFFFFEB3B),
      const Color(0xFF2196F3),
    ];

    final colorIndex = int.tryParse(provider.profileImageIndex);
    final isCustomImage = colorIndex == null;
    final customImageProvider = isCustomImage
        ? getProfileImageProvider(provider.profileImageIndex)
        : null;
    final showCustomImage = isCustomImage && customImageProvider != null;

    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBB86FC), Color(0xFF3700B3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalizationScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: showCustomImage
                              ? Colors.transparent
                              : avatarColors[(colorIndex ?? 0) %
                                    avatarColors.length],
                          image: showCustomImage
                              ? DecorationImage(
                                  image: customImageProvider!,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: !showCustomImage
                            ? Center(
                                child: Text(
                                  provider.nickname.isNotEmpty
                                      ? provider.nickname[0].toUpperCase()
                                      : 'A',
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.nickname,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${provider.rankName} • Lvl ${provider.currentLevel}',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFFBB86FC)),
            title: Text(
              'History',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFFBB86FC)),
            title: Text(
              'Personalization',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalizationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
