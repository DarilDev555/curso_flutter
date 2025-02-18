import 'package:cinemapedia_nt/config/constants/environment.dart';
import 'package:cinemapedia_nt/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_nt/domain/entities/actor.dart';
import 'package:cinemapedia_nt/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia_nt/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Actor> _jsonToActor(Map<String, dynamic> json) {
    final castDBResponse = CreditsResponse.fromJson(json);
    final List<Actor> actors =
        castDBResponse.cast
            // .where((actorBD) => actorBD.profilePath != 'no-profiePath')
            .map((actorBD) => ActorMapper.castToEntity(actorBD))
            .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorByMovie(String id) async {
    final response = await dio.get('/movie/$id/credits');

    return _jsonToActor(response.data);
  }
}
