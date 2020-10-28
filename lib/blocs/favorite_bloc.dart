import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ytf_app/models/video.dart';

class FavoriteBloc implements BlocBase {
  static const PREFER_KEY = 'favorites';
  Map<String, Video> _favorites = {};

  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains(PREFER_KEY)) {
        _favorites = json.decode(prefs.getString(PREFER_KEY)).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();

        _favController.sink.add(_favorites);
      }
    });
  }

  Stream<Map<String, Video>> get outFav => _favController.stream;

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    else
      _favorites[video.id] = video;

    _favController.sink.add(_favorites);
    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(PREFER_KEY, json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }
}
