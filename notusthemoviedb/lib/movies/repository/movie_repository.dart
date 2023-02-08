import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../model/movie.dart';

const _movieLimit = 20;

@singleton
class MovieRepository {
  final httpClient = http.Client();

  Future<List<Movie>> fetchMovies([int startIndex = 0]) async {
    final response = await httpClient.get(Uri.https(
      'api.themoviedb.org',
      '/3/movie/top_rated',
      {'api_key': 'c3a5a1d07a55c4e1925bb5ddc0941453', 'page': '$startIndex'},
    ));
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = body['results'] as List<dynamic>;

      return List<Movie>.from(results.map((m) => Movie.fromJson(m)));
    }
    throw Exception('error fetching movies');
  }
}
