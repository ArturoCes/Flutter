import 'package:flutter/material.dart';
import '../bloc/movies_bloc.dart';
import '../models/movie.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _bloc = MoviesBloc();
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isLoading = false;
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_isBottom) {
        _fetchData();
      }
    });
    _fetchData();
  }

  void _fetchData() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      _bloc.fetchMovies(_page, page: 1);
      _bloc.movies.listen((movies) {
        setState(() {
          _movies.addAll(movies);
          _page++;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 1;
            _movies = [];
          });
          _fetchData();
        },
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _movies.length + 1,
          itemBuilder: (context, index) {
            if (index == _movies.length) {
              return Container(
                height: 70.0,
                child: Center(
                  child: isLoading ? CircularProgressIndicator() : Container(),
                ),
              );
            }
            return Card(
              
              child: Column(
                children: [
                  Image.network(
                      'https://image.tmdb.org/t/p/w500${_movies[index].posterPath}',height: 300, width:300 ,
                  ),
                      
                  Text(_movies[index].title),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return maxScroll == currentScroll;
  }
}
