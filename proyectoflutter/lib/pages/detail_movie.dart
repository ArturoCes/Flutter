/* import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailMoviePage extends StatelessWidget {
  final Movie movie;

  const DetailMoviePage({required Key key,  required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Container(
        child: Column(
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
            ),
            Text(movie.title),
            Text(movie.overview),
          ],
        ),
      ),
    );
  }
}
*/