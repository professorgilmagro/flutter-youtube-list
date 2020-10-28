import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:ytf_app/blocs/favorite_bloc.dart';
import 'package:ytf_app/models/video.dart';
import 'package:ytf_app/services/api.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  VideoTile({this.video});

  @override
  Widget build(BuildContext context) {
    final favBloc = BlocProvider.of<FavoriteBloc>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(
              onTap: () {
                FlutterYoutube.playYoutubeVideoById(
                  backgroundColor: Colors.black87,
                  appBarColor: Colors.black87,
                  autoPlay: true,
                  fullScreen: true,
                  apiKey: Api.KEY,
                  videoId: video.id,
                );
              },
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        video.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        video.channel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<Map<String, Video>>(
                  stream: favBloc.outFav,
                  initialData: {},
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? IconButton(
                            icon: Icon(
                              snapshot.data.containsKey(video.id)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              favBloc.toggleFavorite(video);
                            },
                          )
                        : CircularProgressIndicator();
                  }),
            ],
          )
        ],
      ),
    );
  }
}
