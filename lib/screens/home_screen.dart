// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedGenre = 'All';
  final List<String> _genres = [
    'All',
    'Action',
    'Sci-Fi',
    'Animation',
    'Horror',
    'Drama',
  ];

  @override
  void initState() {
    super.initState();
    // Panggil fetch data saat screen pertama kali dimuat
    Future.microtask(
      () => Provider.of<MovieProvider>(context, listen: false).fetchMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'MovieExplorer',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)),
            );
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat data:\n${provider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          if (provider.movies.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada film ditemukan.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          // Proses Filter Film Berdasarkan Genre yang Dipilih & ID TMDB
          final filteredMovies = provider.movies.where((movie) {
            if (_selectedGenre == 'All') return true;

            int targetGenreId = 0;
            if (_selectedGenre == 'Action')
              targetGenreId = 28;
            else if (_selectedGenre == 'Sci-Fi')
              targetGenreId = 878;
            else if (_selectedGenre == 'Animation')
              targetGenreId = 16;
            else if (_selectedGenre == 'Horror')
              targetGenreId = 27;
            else if (_selectedGenre == 'Drama')
              targetGenreId = 18;

            return movie.genreIds.contains(targetGenreId);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Pilihan Genre / Kategori Horizontal
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _genres.length,
                  itemBuilder: (context, index) {
                    final genre = _genres[index];
                    final isSelected = _selectedGenre == genre;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(genre),
                        selected: isSelected,
                        selectedColor: const Color(0xFFFFC107),
                        backgroundColor: const Color(0xFF1E1E1E),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGenre = genre;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              // Grid View Daftar Film Utama hasil filter
              Expanded(
                child: filteredMovies.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada film untuk genre ini.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies[index];
                          final isInWatchlist = provider.isInWatchlist(movie);

                          return GestureDetector(
                            onTap: () {
                              // Navigasi ke Halaman Detail Film saat kartu diklik
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(12),
                                              ),
                                          child: movie.posterPath.isNotEmpty
                                              ? Image.network(
                                                  movie.fullPosterPath,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                )
                                              : Container(
                                                  color: Colors.grey[800],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.movie,
                                                      color: Color(0xFFFFC107),
                                                      size: 40,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        // Tombol Bookmark / Watchlist di Pojok Kanan Atas Poster
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                isInWatchlist
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: const Color(0xFFFFC107),
                                                size: 18,
                                              ),
                                              constraints:
                                                  const BoxConstraints(),
                                              padding: const EdgeInsets.all(8),
                                              onPressed: () {
                                                provider.toggleWatchlist(movie);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      isInWatchlist
                                                          ? 'Dihapus dari Watchlist'
                                                          : 'Ditambahkan ke Watchlist',
                                                    ),
                                                    duration: const Duration(
                                                      seconds: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Color(0xFFFFC107),
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${movie.voteAverage.toStringAsFixed(1)} / 10',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
