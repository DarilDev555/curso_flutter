import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorRespository {
  Future<List<Actor>> getActorByMovie(String id);
}
