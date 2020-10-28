import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytf_app/blocs/favorite_bloc.dart';
import 'package:ytf_app/models/video.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favBloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: favBloc.outFav,
        builder: (context, snapshot) {
          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data.values.map((video) {
              return InkWell(
                onTap: () {},
                onLongPress: () {
                  favBloc.toggleFavorite(video);
                },
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 75,
                      child: Image.network(video.thumb),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          video.title,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
