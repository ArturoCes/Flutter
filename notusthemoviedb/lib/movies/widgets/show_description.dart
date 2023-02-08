import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/movie.dart';

void showDescription(BuildContext context, Movie movie) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieDescriptionPage(movie: movie)));
}

//Crear la clase MovieDescriptionPage:
class MovieDescriptionPage extends StatelessWidget {
  const MovieDescriptionPage({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Description')),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('${movie.overview}'),
              Text('${movie.title}'),
              Image.network(
                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                width: 180,
                height: 190,
              )
            ],
          )),
    );
  }
}
