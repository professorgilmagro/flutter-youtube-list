import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:ytf_app/blocs/favorite_bloc.dart';
import 'package:ytf_app/blocs/videos_bloc.dart';
import 'package:ytf_app/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      bloc: VideoBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          title: 'Favoritos do YouTube',
          debugShowCheckedModeBanner: false,
          home: Home(),
        ),
      ),
    ),
  );
}
