// 2415051088 - Made Wilasih
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieNoteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. READ: Mengambil semua catatan film
  Future getNotes() async {
    final response = await _supabase
        .from('movie_notes')
        .select()
        .order('created_at', ascending: false);
    return response;
  }

  // 2. CREATE: Menambah catatan baru
  Future<void> addNote({
    required String movieId,
    required String title,
    required String note,
    required double rating,
  }) async {
    await _supabase.from('movie_notes').insert({
      'movie_id': movieId,
      'title': title,
      'note': note,
      'rating': rating,
    });
  }

  // 3. UPDATE: Memperbarui catatan
  Future<void> updateNote({
    required int id,
    required String note,
    required double rating,
  }) async {
    await _supabase
        .from('movie_notes')
        .update({'note': note, 'rating': rating})
        .eq('id', id);
  }

  // 4. DELETE: Menghapus catatan
  Future<void> deleteNote(int id) async {
    await _supabase.from('movie_notes').delete().eq('id', id);
  }
}
