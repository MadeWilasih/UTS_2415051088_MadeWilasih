// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'My Watchlist',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final watchlist = provider.watchlist;

          if (watchlist.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada film di Watchlist kamu.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final movie = watchlist[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    // Poster kecil film di Watchlist
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: movie.posterPath.isNotEmpty
                          ? Image.network(
                              movie.fullPosterPath,
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                            )
                          : Container(
                              width: 50,
                              height: 75,
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                color: Color(0xFFFFC107),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
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
                    // Tombol Hapus dari Watchlist
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        provider.toggleWatchlist(movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dihapus dari Watchlist'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
