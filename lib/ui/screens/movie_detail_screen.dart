import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/logic/providers/movie_detail_provider.dart';
import 'package:film_app/core/constants/api_constants.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем детали фильма через провайдер
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieDetailProvider>(
        context,
        listen: false,
      ).loadMovie(widget.movieId);
    });
  }

  String imageUrl(String? path) {
    if (path == null) return '';
    return '${ApiConstants.imageBaseUrl}w780$path';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieDetailProvider>(context);
    final movie = provider.movie;
    final isLoading = provider.isLoading;
    final error = provider.error;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.loadMovie(widget.movieId),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    if (movie == null) return const SizedBox.shrink();

    return Scaffold(
      body: CustomScrollView(
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
                  Text(movie.overview, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text('Рейтинг: ${movie.voteAverage}'),
                  Text('Длительность: ${movie.runtimeFormatted}'),
                  Text('Статус: ${movie.status}'),
                  const SizedBox(height: 8),
                  Text('Бюджет: \$${movie.budget}'),
                  Text('Сборы: \$${movie.revenue}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: movie.genres
                        .map((g) => Chip(label: Text(g.name)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
