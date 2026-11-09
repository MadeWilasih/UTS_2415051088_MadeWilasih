// 2415051088 - Made Wilasih

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Factory constructor untuk parsing JSON dari TMDB API
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Description',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] != null)
          ? (json['vote_average'] as num).toDouble()
          : 0.0,
      releaseDate: json['release_date'] ?? '',
    );
  }

  // Mengubah ke Map untuk kebutuhan database Supabase (watchlist)
  Map<String, dynamic> toJson() {
    return {
      'movie_id': id.toString(),
      'movie_title': title,
      'poster_path': posterPath,
      'user_note': '',
      'user_rating': 0.0,
    };
  }

  // === TAMBAHKAN GETTER INI DI BAGIAN BAWAH ===
  String get fullPosterPath {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
