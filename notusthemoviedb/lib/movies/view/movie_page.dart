import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import 'movie_list.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: BlocProvider(
        create: (_) => MovieBloc(),
        child: const MovieList(key: Key("movie_list")),
      ),
    );
  }
}
