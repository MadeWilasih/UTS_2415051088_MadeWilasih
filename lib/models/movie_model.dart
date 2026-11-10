// 2415051088 - Made Wilasih

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds; // Tambahan untuk menampung ID genre film

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
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
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : [], // Parsing data genre_ids dari TMDB
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

  // Getter untuk URL Poster
  String get fullPosterPath {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
