import 'package:cinemapedia_nt/domain/entities/actor.dart';
import 'package:cinemapedia_nt/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((
      ref,
    ) {
      final getActors = ref.watch(actorsRepositoryProvider);

      return ActorsByMovieNotifier(getActors: getActors.getActorByMovie);
    });

typedef GetActorsCallback = Future<List<Actor>> Function(String id);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
