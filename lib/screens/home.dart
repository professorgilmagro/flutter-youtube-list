import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ytf_app/blocs/videos_bloc.dart';
import 'package:ytf_app/delegates/data_search.dart';
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
            child: Text("0"),
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
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder(
        stream: blocVideo.outVideos,
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
              blocVideo.nextPage();
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
