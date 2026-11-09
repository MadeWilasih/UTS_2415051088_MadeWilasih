// 2415051088 - Made Wilasih
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieService {
  // Ganti dengan API Key TMDB kamu (atau gunakan endpoint publik yang valid)
  static const String apiKey = 'YOUR_TMDB_API_KEY';
  static const String baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?api_key=$apiKey&language=en-US&page=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat data film (Error: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}
