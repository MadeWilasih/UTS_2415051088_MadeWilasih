// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _movies = [];
  // Tambahan list untuk menyimpan data Watchlist
  final List<Movie> _watchlist = [];

  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
  // Getter untuk mengambil data watchlist
  List<Movie> get watchlist => _watchlist;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _movies = await _movieService.fetchPopularMovies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk menambah atau menghapus film dari Watchlist
  void toggleWatchlist(Movie movie) {
    if (_watchlist.contains(movie)) {
      _watchlist.remove(movie);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
  }

  // Cek apakah film sudah ada di watchlist
  bool isInWatchlist(Movie movie) {
    return _watchlist.contains(movie);
  }
}
