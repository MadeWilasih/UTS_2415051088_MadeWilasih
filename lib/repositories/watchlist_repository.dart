// 2415051088 - Made Wilasih
import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistRepository {
  final _supabase = Supabase.instance.client;

  Future<List> getWatchlist() async {
    final response = await _supabase
        .from('watchlist')
        .select()
        .order('created_at', ascending: false);

    return response as List;
  }

  Future<void> addToWatchlist({
    required int movieId,
    required String title,
    required String note,
    required double rating,
  }) async {
    await _supabase.from('watchlist').insert({
      'movie_id': movieId,
      'title': title,
      'note': note,
      'rating': rating,
    });
  }
}
