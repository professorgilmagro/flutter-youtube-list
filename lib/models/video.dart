class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({this.id, this.title, this.thumb, this.channel});

  String toString() {
    return this.toMap().toString();
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  Map toMap() {
    return {
      'id': id,
      'title': title,
      'thumb': thumb,
      'channel': channel,
    };
  }

  factory Video.fromJson(Map<String, dynamic> data) {
    if (data.containsKey('snippet')) {
      return Video.fromGoogleJson(data);
    }

    return Video.fromSelfJson(data);
  }

  factory Video.fromSelfJson(Map<String, dynamic> data) {
    return Video(
      id: data['id'],
      title: data['title'],
      thumb: data['thumb'],
      channel: data['channel'],
    );
  }

  factory Video.fromGoogleJson(Map<String, dynamic> data) {
    return Video(
      id: data['id']['videoId'],
      title: data['snippet']['title'],
      thumb: data['snippet']['thumbnails']['high']['url'],
      channel: data['snippet']['channelTitle'],
    );
  }
}
