// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/movie_provider.dart';
import '../screens/movie_detail_screen.dart'; // Pastikan path import ini sesuai

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State data profil yang bisa diedit
  String _name = 'Made Wilasih';
  String _nimInfo = 'NIM: 2415051088 | PTI 5B';
  String _prodiInfo = 'Pendidikan Teknik Informatika - Undiksha';
  String _imagePath = 'assets/profile.jpg';
  String _favoriteGenre = 'Sci-Fi';
  int _targetWatched = 4; // Target nonton film bulan ini

  // Fungsi untuk menampilkan Dialog Edit Profil
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final nimController = TextEditingController(text: _nimInfo);
    final prodiController = TextEditingController(text: _prodiInfo);
    final imageController = TextEditingController(text: _imagePath);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Edit Profil Saya',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nimController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'NIM & Kelas',
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: prodiController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'URL Foto Profil / Asset Path',
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                  _nimInfo = nimController.text;
                  _prodiInfo = prodiController.text;
                  _imagePath = imageController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui!')),
                );
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk Memilih Genre Favorit
  void _showGenreChooserDialog() {
    final genres = ['Action', 'Sci-Fi', 'Animation', 'Horror', 'Drama'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Pilih Genre Favorit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: genres.map((genre) {
              return ListTile(
                title: Text(genre, style: const TextStyle(color: Colors.white)),
                trailing: _favoriteGenre == genre
                    ? const Icon(Icons.check, color: Colors.amber)
                    : null,
                onTap: () {
                  setState(() {
                    _favoriteGenre = genre;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Genre favorit diubah ke $genre')),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Fungsi untuk Mengatur Target Nonton / Movie Challenge secara Manual
  void _showTargetDialog() {
    final targetController = TextEditingController(
      text: _targetWatched.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Atur Target Nonton Bulan Ini',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: targetController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Jumlah Target Film',
              labelStyle: TextStyle(color: Colors.amber),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final newTarget = int.tryParse(targetController.text);
                if (newTarget != null) {
                  setState(() {
                    _targetWatched = newTarget;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Target nonton berhasil diperbarui!'),
                    ),
                  );
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk Menampilkan Riwayat Tontonan (Film yang pernah dibuka) dengan Poster & Judul yang bisa diklik
  void _showWatchHistoryDialog(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    final historyMovies =
        provider.watchHistory; // Mengambil data riwayat dari provider

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Riwayat Tontonan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: historyMovies.isEmpty
                ? const Text(
                    'Belum ada riwayat film yang ditonton atau dibuka.',
                    style: TextStyle(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: historyMovies.length,
                    itemBuilder: (context, index) {
                      final movie = historyMovies[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: movie.posterPath.isNotEmpty
                              ? Image.network(
                                  movie.fullPosterPath,
                                  width: 40,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.movie,
                                        color: Colors.amber,
                                      ),
                                )
                              : Container(
                                  width: 40,
                                  height: 60,
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.movie,
                                    color: Colors.amber,
                                  ),
                                ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Rating: ${movie.voteAverage.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Tutup dialog riwayat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk Menampilkan Ulasan & Catatan dari Supabase dengan benar
  void _showMyReviewsDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );

    try {
      // Mengambil data dari tabel ulasan Supabase
      final response = await Supabase.instance.client
          .from('movie_notes')
          .select();
      Navigator.pop(context); // Tutup loading

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Ulasan & Catatan Saya',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: response.isEmpty
                  ? const Text(
                      'Belum ada ulasan atau catatan film yang disimpan.',
                      style: TextStyle(color: Colors.grey),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: response.length,
                      itemBuilder: (context, index) {
                        final item = response[index];

                        // Menyesuaikan dengan nama kolom Supabase (bisa disesuaikan jika namanya berbeda)
                        final title =
                            item['movie_title'] ?? item['title'] ?? 'Film';
                        final note = item['user_note'] ?? item['note'] ?? '-';
                        final rating =
                            item['user_rating'] ?? item['rating'] ?? '-';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Rating: $rating',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Catatan: $note',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat ulasan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchlistCount = context.watch<MovieProvider>().watchlist.length;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.amber),
            tooltip: 'Edit Profil',
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar / Foto Profil
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              backgroundImage: _imagePath.startsWith('http')
                  ? NetworkImage(_imagePath) as ImageProvider
                  : AssetImage(_imagePath),
            ),
            const SizedBox(height: 16),

            // Nama Mahasiswa
            Text(
              _name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),

            // NIM & Kelas
            Text(
              _nimInfo,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _prodiInfo,
              style: const TextStyle(fontSize: 13, color: Colors.amber),
            ),
            const SizedBox(height: 30),

            // Kartu Statistik Ringkasan (Watchlist, Rating, Genre Fav yang bisa diklik)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  Icons.bookmark,
                  'Watchlist',
                  '$watchlistCount Film',
                ),
                _buildStatCard(Icons.star, 'Rating', '4.8 / 5.0'),
                GestureDetector(
                  onTap: _showGenreChooserDialog,
                  child: _buildStatCard(
                    Icons.movie_creation,
                    'Genre Fav',
                    _favoriteGenre,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Menu Aktivitas & Pengaturan Fungsional
            _buildSectionTitle('Aktivitas & Pengaturan'),
            _buildMenuTile(
              Icons.history,
              'Riwayat Tontonan',
              'Lihat daftar film yang pernah dibuka',
              onTap: () => _showWatchHistoryDialog(context),
            ),
            _buildMenuTile(
              Icons.rate_review,
              'Ulasan & Catatan Saya',
              'Lihat riwayat catatan',
              onTap: _showMyReviewsDialog,
            ),
            _buildMenuTile(
              Icons.flag,
              'Target Nonton / Movie Challenge',
              'Target: $_targetWatched Film Bulan Ini (Ketuk untuk atur)',
              onTap: _showTargetDialog,
            ),
            _buildMenuTile(
              Icons.cleaning_services,
              'Hapus Riwayat Pencarian & Cache',
              'Bersihkan data penyimpanan lokal sementara',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Riwayat pencarian dan cache berhasil dihapus!',
                    ),
                  ),
                );
              },
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
  Widget _buildMenuTile(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
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
        onTap: onTap,
      ),
    );
  }
}
