import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MoviesBloc {
  final _controller = StreamController<List<Movie>>();

  Stream<List<Movie>> get movies => _controller.stream;

  int _page = 1;

  void fetchMovies(int currentPage, {required int page}) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=c3a5a1d07a55c4e1925bb5ddc0941453&page=$_page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _controller.sink.add((data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList());
      _page++;
    } else {
      _controller.sink.addError(response.statusCode);
    }
  }

  void dispose() {
    _controller.close();
  }
}
