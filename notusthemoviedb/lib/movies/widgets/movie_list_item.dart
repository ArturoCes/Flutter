import 'package:flutter/material.dart';
import 'package:notusthemoviedb/movies/widgets/show_description.dart';

import '../model/movie.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 150,
        height: 150,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            movie.title,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Image.network(
            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
            width: 150,
            height: 150,
          ),
          SizedBox(height: 10),
          Expanded(
            // use expanded widget here
            flex: 1,
            child: TextButton(
              child: const Text("Descripción"),
              onPressed: () => showDescription(context, movie),
            ),
          )
        ]),
      ),
    );
  }
}
