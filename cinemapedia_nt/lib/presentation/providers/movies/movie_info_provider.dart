import 'package:cinemapedia_nt/domain/entities/movie.dart';
import 'package:cinemapedia_nt/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final getMovie = ref.watch(movieRepositoryProvider).getMovieById;

      return MovieMapNotifier(getMovie: getMovie);
    });

typedef GetMovieCallback = Future<Movie> Function({String id});

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getMovie(id: movieId);

    state = {...state, movieId: movie};
  }
}
