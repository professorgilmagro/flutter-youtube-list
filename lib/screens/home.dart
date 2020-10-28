import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ytf_app/blocs/favorite_bloc.dart';
import 'package:ytf_app/blocs/videos_bloc.dart';
import 'package:ytf_app/delegates/data_search.dart';
import 'package:ytf_app/models/video.dart';
import 'package:ytf_app/screens/favorites.dart';
import 'package:ytf_app/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocVideo = BlocProvider.of<VideoBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("assets/images/yt_logo_rgb_dark.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.of<FavoriteBloc>(context).outFav,
                initialData: {},
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              final page = MaterialPageRoute(builder: (context) => Favorites());
              Navigator.of(context).push(page);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              if (result != null) {
                blocVideo.inSearch.add(result);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: blocVideo.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.builder(
            itemCount: snapshot.data.length + 1,
            itemBuilder: (context, index) {
              if (index < snapshot.data.length) {
                return VideoTile(
                  video: snapshot.data[index],
                );
              }

              if (index > 1) {
                blocVideo.nextPage();
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
