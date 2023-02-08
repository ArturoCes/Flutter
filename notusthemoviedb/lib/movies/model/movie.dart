import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie(
      {required this.id,
      required this.title,
      required this.overview,
      required this.posterPath});

  final int id;
  final String title;
  final String overview;
  final String posterPath;

  @override
  List<Object> get props => [id, title, overview];

  get image => null;

  static fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}
