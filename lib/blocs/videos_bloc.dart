import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ytf_app/models/video.dart';
import 'package:ytf_app/services/api.dart';

class VideoBloc implements BlocBase {
  Api api;
  List<Video> videos;
  final _videoController = StreamController<List<Video>>();
  final _searchController = StreamController<String>();

  Stream get outVideos => _videoController.stream;

  Sink get inSearch => _searchController.sink;

  VideoBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    final goToNextPage = search == null;
    if (goToNextPage || videos == null) videos = List();

    videos += await api.search(search, nextPage: goToNextPage);
    _videoController.sink.add(videos);
  }

  @override
  void dispose() {
    _searchController.close();
    _videoController.close();
  }
}
