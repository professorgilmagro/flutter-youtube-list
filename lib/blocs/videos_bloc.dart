import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ytf_app/models/video.dart';
import 'package:ytf_app/services/api.dart';

class VideoBloc implements BlocBase {
  List<Video> videos = List();
  static const NEXT_PAGE_ACTION = 'smZ@&H0nj4:m%9q';
  final _videoController = StreamController<List<Video>>();
  final _searchController = StreamController<String>();

  Stream get outVideos => _videoController.stream;

  Sink get inSearch => _searchController.sink;

  VideoBloc() {
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    final goToNextPage = search == NEXT_PAGE_ACTION;

    videos += await Api.search(search, nextPage: goToNextPage);
    _videoController.sink.add(videos);
  }

  void nextPage() {
    inSearch.add(NEXT_PAGE_ACTION);
  }

  @override
  void dispose() {
    _searchController.close();
    _videoController.close();
  }
}
