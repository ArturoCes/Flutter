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
  // ignore: use_key_in_widget_constructors
  const MovieDescriptionPage({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descripción de la pelicula')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                width: 180,
                height: 190,
              ),
              Text(movie.title),
              Text(movie.overview),
            ],
          )),
    );
  }
}
