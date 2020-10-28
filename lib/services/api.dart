import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ytf_app/models/video.dart';

class Api {
  static final _instance = Api._internal();
  static const MAX = 10;
  static const NEXT_PAGE = 'next';
  static const KEY = 'AIzaSyDXdJIp5AXIpfu7GqMZMze_jrLxJJspzDY';
  static const BASE_SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search';
  static const BASE_SUGGEST_URL =
      'http://suggestqueries.google.com/complete/search';

  String _nextPageToken;
  String _lastSearch;

  static Api get instance {
    return _instance;
  }

  Api._internal();

  String get lastSearch {
    return _lastSearch;
  }

  static Future<List<Video>> search(String term,
      {@required bool nextPage}) async {
    final content = await instance.getSearchData(term, nextPage: nextPage);
    return content['items'].map<Video>((data) {
      return Video.fromJson(data);
    }).toList();
  }

  String getSearchUrl(String term, bool nextPage) {
    if (term != null && term.isNotEmpty) _lastSearch = term;
    String q = (nextPage && _lastSearch != null) ? _lastSearch : term;
    String qs = 'key=$KEY&part=snippet&q=$q&type=video&maxResults=$MAX';
    if (nextPage) {
      qs += '&pageToken=$_nextPageToken';
    }

    return "$BASE_SEARCH_URL?$qs";
  }

  String getSuggestUrl(String term) {
    return "$BASE_SUGGEST_URL?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$term&format=5&alt=json";
  }

  Future<Map<String, dynamic>> getSearchData(q, {bool nextPage}) async {
    final data = await _getData(getSearchUrl(q, nextPage));
    _nextPageToken = data['nextPageToken'] ?? null;
    return data;
  }

  Future<List> getSuggestData(q) async => await _getData(getSuggestUrl(q));

  Future<dynamic> _getData(String url) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to load videos');
  }
}
