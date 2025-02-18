import 'package:cinemapedia_nt/domain/entities/actor.dart';

abstract class ActorRespository {
  Future<List<Actor>> getActorByMovie(String id);
}
