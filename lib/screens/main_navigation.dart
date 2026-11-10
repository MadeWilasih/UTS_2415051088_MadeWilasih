// 2415051088 - Made Wilasih (PTI 5B)
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'watchlist_screen.dart';

// Nanti kita buat file search_screen.dart dan profile_screen.dart setelah ini
// Untuk sementara kita siapkan kerangkanya dulu

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar halaman yang akan dipanggil lewat Bottom Navigation Bar
  final List<Widget> _pages = [
    const HomeScreen(),
    const WatchlistScreen(),
    const Center(
      child: Text(
        'Fitur Search (Segera Hadir)',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
    const Center(
      child: Text(
        'Fitur Profile (Segera Hadir)',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_rounded),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
