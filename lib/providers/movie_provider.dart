// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
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
}
