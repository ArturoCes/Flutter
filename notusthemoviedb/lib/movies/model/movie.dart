import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({required this.id, required this.title, required this.overview});

  final int id;
  final String title;
  final String overview;

  @override
  List<Object> get props => [id, title, overview];

  static fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] 
    );
  }
}