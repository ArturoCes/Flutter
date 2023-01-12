import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon List',
      routes: {
        '/pokemon': (context) => PokemonDetailsScreen(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pokemon List'),
        ),
        body: PokemonList(),
      ),
    );
  }
}

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  Future<List<String>>? _pokemonNames;

  @override
  void initState() {
    super.initState();
    _pokemonNames = getPokemonNames();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _pokemonNames,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () {
                  final id = index + 1;
                  Navigator.of(context).pushNamed('/pokemon', arguments: id);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class PokemonDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Details'),
      ),
      body: PokemonDetails(id: id),
    );
  }
}

class PokemonDetails extends StatefulWidget {
  final int id;
  PokemonDetails({required this.id});

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  Future<Map<String, dynamic>>? _pokemon;

  @override
  void initState() {
    super.initState();
    _pokemon = getPokemonDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _pokemon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pokemon = snapshot.data;
          return Column(
            children: <Widget>[
// You can add an Image widget to display the Pokemon's sprite
              Image.network(pokemon?['sprites']['front_default']),
// You can add a Text widget to display the Pokemon's name
              Text(pokemon?['name']),
// You can add a Text widget to display the Pokemon's ID
              Text('ID: ${pokemon?['id']}'),
// You can add a Text widget to display the Pokemon's weight
              Text('Weight: ${pokemon?['weight']}'),
// You can add a Text widget to display the Pokemon's height
              Text('Height: ${pokemon?['height']}'),
// You can add a Text widget to display the Pokemon's types
              Text(
                  'Types: ${pokemon?['types'].map((t) => t['type']['name']).join(', ')}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}

Future<List<String>> getPokemonNames() async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    final pokemonList = parsed['results'] as List<dynamic>;
    return pokemonList.map<String>((p) => p['name'] as String).toList();
  } else {
    throw Exception('Error al cargar los pokemones ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getPokemonDetails(int id) async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error al cargar el Pokemon $id');
  }
}
