import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({
    super.key,
    required this.movies,
    this.loadNextPage,
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        return MoviePosterLink(movie: widget.movies[index]);
      },
    );
  }
}

// ListView.builder(
//         itemCount: favoriteMovies.length,
//         itemBuilder: (context, index) {
//           final movie = favoriteMovies[index];

//           return ListTile(
//             title: Text('${movie.title}'),
//           );
//         },
//       ),
//     );
