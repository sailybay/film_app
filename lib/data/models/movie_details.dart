import 'movie.dart';
import 'genre.dart';

class MovieDetails extends Movie {
  final List<Genre> genres;
  final int runtime;
  final String status;
  final int budget;
  final int revenue;

  MovieDetails({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    required super.overview,
    required super.voteAverage,
    required super.releaseDate,
    required super.genreIds,
    required this.genres,
    required this.runtime,
    required this.status,
    required this.budget,
    required this.revenue,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'],
      title: json['title'] ?? 'Без названия',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'] ?? 'Описание отсутствует',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      genres:
          (json['genres'] as List?)?.map((g) => Genre.fromJson(g)).toList() ??
          [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  String get runtimeFormatted {
    if (runtime == 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}ч ${minutes}м';
  }
}
