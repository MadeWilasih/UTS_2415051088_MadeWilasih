// 2415051088 - Made Wilasih
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieService {
  // Ganti dengan API Key TMDB kamu (atau gunakan endpoint publik yang valid)
  static const String apiKey = 'eae974107602568774a45ff640139f27';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1',
        ),
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

  // Fungsi untuk mencari film berdasarkan keyword
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mencari film (Error: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}
