import 'package:flutter/material.dart';

import '../model/movie.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 180,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              movie.title,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.network(
              'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
              width: 230,
              height: 230,
            ),
          ],
        ),
      ),
    );
  }
}
