import 'package:flutter/material.dart';
import 'package:film_app/logic/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:film_app/data/models/movie_details.dart';
import 'package:film_app/core/constants/api_constants.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  String imageUrl(String? path) {
    if (path == null) return '';
    return '${ApiConstants.imageBaseUrl}w780$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetails>(
        future: context.read<MovieProvider>().getMovieDetails(movieId),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(movie.title),
                  background: movie.backdropPath == null
                      ? Container(color: Colors.black)
                      : Image.network(
                          imageUrl(movie.backdropPath),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.overview,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text('Рейтинг: ${movie.voteAverage}'),
                      Text('Длительность: ${movie.runtime} мин'),
                      Text('Статус: ${movie.status}'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
