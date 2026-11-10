import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar / Foto Profil
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 16),

            // Nama Mahasiswa
            const Text(
              'Made Wilasih',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),

            // NIM & Kelas
            const Text(
              'NIM: 2415051088 | PTI 5B',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pendidikan Teknik Informatika - Undiksha',
              style: TextStyle(fontSize: 13, color: Colors.amber),
            ),
            const SizedBox(height: 30),

            // Kartu Statistik Ringkasan (Watchlist & Aktivitas)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(Icons.bookmark, 'Watchlist', '12 Film'),
                _buildStatCard(Icons.star, 'Rating', '4.8 / 5.0'),
                _buildStatCard(Icons.movie_creation, 'Genre Fav', 'Sci-Fi'),
              ],
            ),
            const SizedBox(height: 30),

            // Menu Pengaturan / Informasi
            _buildSectionTitle('Informasi Aplikasi'),
            _buildMenuTile(
              Icons.info_outline,
              'Tentang MovieExplorer',
              'Versi 1.0.0 (UTS Project)',
            ),
            _buildMenuTile(
              Icons.security,
              'Keamanan Data',
              'Supabase Sync Active',
            ),
            _buildMenuTile(
              Icons.color_lens,
              'Tema Aplikasi',
              'Dark Cinematic Mode',
            ),

            const SizedBox(height: 30),

            // Tombol Logout / Keluar
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil keluar dari akun')),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.black),
              label: const Text(
                'Keluar Akun',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Kartu Statistik
  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget Pembantu untuk Judul Bagian
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget Pembantu untuk Menu List
  Widget _buildMenuTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () {},
      ),
    );
  }
}
