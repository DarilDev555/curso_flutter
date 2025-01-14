


import 'package:toktik/domain/datasources/video_post_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_post_repository.dart';

class VideoPostRepositoryImpl  implements VideoPostRepository {

  final VideoPostDatasource videoPostDatasource;

  VideoPostRepositoryImpl({ required this.videoPostDatasource });

  @override
  Future<List<VideoPost>> getFavoriteVideosBypage(String userID) {
    // TODO: implement getFavoriteVideosBypage
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videoPostDatasource.getTrendingVideosByPage(page);
  } 

}