import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_app/data/models/movie.dart';
import 'package:film_app/ui/screens/movie_detail_screen.dart';
import 'package:film_app/core/utils/responsive_util.dart';
import 'package:film_app/ui/widgets/rating_badge.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtil.isDesktop(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Poster + Rating =====
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Плакат фильма
                  movie.posterUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: movie.posterUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.movie, size: 64),
                          ),
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.movie, size: 64),
                        ),

                  // Рейтинг (только на десктопе сверху)
                  if (isDesktop)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: RatingBadge(
                        rating: movie.voteAverage,
                        fontSize: 12,
                        iconSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // ===== Title + Rating (мобильная версия) =====
            Padding(
              padding: EdgeInsets.all(isDesktop ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 13 : 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isDesktop)
                    Row(
                      children: [
                        RatingBadge(
                          rating: movie.voteAverage,
                          fontSize: 14,
                          iconSize: 16,
                          backgroundColor: Colors.transparent,
                        ),
                        const Spacer(),
                        Text(
                          movie.year,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      movie.year,
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
