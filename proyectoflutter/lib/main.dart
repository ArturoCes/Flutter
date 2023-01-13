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
  Future<List<Pokemon>>? _pokemon;

  @override
  void initState() {
    super.initState();
    _pokemon = getPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: _pokemon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final pokemon = snapshot.data![index];
              return ListTile(
                leading: Image.network(pokemon.imageUrl),
                title: Text(pokemon.name),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/pokemon', arguments: pokemon);
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

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});
}

Future<List<Pokemon>> getPokemon() async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
  if (response.statusCode != 200) {
    throw Exception('Error al obtener los Pokemon');
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final pokemonList = data['results'] as List<dynamic>;
  final pokemon = <Pokemon>[];
  for (final pokemonData in pokemonList) {
    final pokemonResponse = await http.get(Uri.parse(pokemonData['url']));
    final pokemonJson =
        jsonDecode(pokemonResponse.body) as Map<String, dynamic>;
    final imageUrl = pokemonJson['sprites']['front_default'];
    if (imageUrl == null || imageUrl.isEmpty) {
    } else {
      final uri = Uri.tryParse(imageUrl);
      if (uri == null) {
      } else {
        final currentPokemon = Pokemon(
          id: pokemonJson['id'],
          name: pokemonJson['name'],
          imageUrl: imageUrl,
        );
        pokemon.add(currentPokemon);
      }
    }
  }
  return pokemon;
}

class PokemonDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Details'),
      ),
      body: PokemonDetails(pokemon: pokemon),
    );
  }
}

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;
  PokemonDetails({required this.pokemon});

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  Future<Map<String, dynamic>>? _pokemon;

  @override
  void initState() {
    super.initState();
    _pokemon = getPokemonDetails(widget.pokemon.id);
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
              // Imagen del pokemón
              Image.network(widget.pokemon.imageUrl),
              // Nombre del pokemón
              Text(
                  'Nombre: ${widget.pokemon.name.toUpperCase()[0] + widget.pokemon.name.substring(1)}'),
              // ID del pokémon
              Text('ID : ${pokemon?['id']}'),
              // Peso del pokemón
              Text('Peso : ${pokemon?['weight']}'),
              //Estatura del pokemón
              Text('Altura : ${pokemon?['height']}'),
              //Tipo de pokemón
              Text(
                  'Tipos: ${pokemon?['types'].map((t) => t['type']['name']).join(', ')}'),
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

Future<Map<String, dynamic>> getPokemonDetails(int id) async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
  if (response.statusCode != 200) {
    throw Exception('Error al obtener los detalles del Pokemon');
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}
