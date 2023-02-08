part of 'movie_bloc.dart';

enum MovieStatus { initial, success, failure }

class MovieState extends Equatable {
  const MovieState({
    this.status = MovieStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
  });

  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;

  MovieState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''MovieState { status: $status, hasReachedMax: $hasReachedMax, movies: ${movies.length} }''';
  }

  @override
  List<Object> get props => [status, movies, hasReachedMax];
}
