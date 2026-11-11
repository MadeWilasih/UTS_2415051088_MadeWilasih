// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _movies = [];
  // List untuk menyimpan data Watchlist
  final List<Movie> _watchlist = [];
  // List untuk menyimpan data Riwayat Tontonan
  final List<Movie> _watchHistory = [];
  // Tambahan list untuk menyimpan data Favorite (ikon hati)
  final List<Movie> _favorites = [];

  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
  List<Movie> get watchlist => _watchlist;
  List<Movie> get watchHistory => _watchHistory;
  // Getter untuk mengambil data favorite
  List<Movie> get favorites => _favorites;

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

  bool isInWatchlist(Movie movie) {
    return _watchlist.contains(movie);
  }

  void addToWatchHistory(Movie movie) {
    _watchHistory.removeWhere((m) => m.id == movie.id);
    _watchHistory.insert(0, movie);
    notifyListeners();
  }

  // Tambahan Fungsi untuk Toggle Favorite (Ikon Hati)
  void toggleFavorite(Movie movie) {
    if (_favorites.contains(movie)) {
      _favorites.remove(movie);
    } else {
      _favorites.add(movie);
    }
    notifyListeners();
  }

  // Cek apakah film sudah ada di favorite
  bool isFavorite(Movie movie) {
    return _favorites.contains(movie);
  }

  // Fungsi untuk membersihkan riwayat tontonan dan cache pencarian
  void clearCacheAndHistory() {
    _watchHistory.clear();
    _movies.clear();
    _errorMessage = '';
    notifyListeners();
  }
}
