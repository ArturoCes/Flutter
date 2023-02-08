import 'package:flutter/material.dart';
import 'package:notusthemoviedb/movies/view/movie_page.dart';

import 'movies/model/movie.dart';

class App extends MaterialApp {
  const App({super.key}) : super(home: const MoviesPage());
}
