import 'package:cinemapedia_nt/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_nt/domain/entities/actor.dart';
import 'package:cinemapedia_nt/domain/repositories/actor_respository.dart';

class ActorRepositoryImpl extends ActorRespository {
  final ActorsDatasource datasource;

  ActorRepositoryImpl({required this.datasource});

  @override
  Future<List<Actor>> getActorByMovie(String id) {
    return datasource.getActorByMovie(id);
  }
}
