import 'package:cinemapedia_nt/domain/entities/actor.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorByMovie(String id);
}
