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
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //number of columns
              childAspectRatio: 1.5,
            ),
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final pokemon = snapshot.data![index];
              return Card(
                child: Column(
                  children: <Widget>[
                    Image.network(
                      pokemon.imageUrl,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Text(pokemon.name.substring(0, 1).toUpperCase() +
                        pokemon.name.substring(1)),
                    TextButton(
                      child: Text("Ver detalles"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/pokemon', arguments: pokemon);
                      },
                    ),
                  ],
                ),
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
  final double weight;
  final double height;
  final List<String> types;
  final List<String> abilities;

  Pokemon(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.weight,
      required this.height,
      required this.types,
      required this.abilities});
}

Future<List<Pokemon>> getPokemon() async {
  try {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
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
        continue;
      }
      final uri = Uri.tryParse(imageUrl);
      if (uri == null) {
        continue;
      }
      final weight = pokemonJson['weight'] / 10;
      final height = pokemonJson['height'] / 10;
      final types = (pokemonJson['types'] as List<dynamic>)
          .map((type) => type['type']['name'])
          .cast<String>()
          .toList();
      final abilities = (pokemonJson['abilities'] as List<dynamic>)
          .map((ability) => ability['ability']['name'])
          .cast<String>()
          .toList();
      final id = pokemonJson['id'];
      pokemon.add(Pokemon(
          id: id,
          name: pokemonData['name'],
          imageUrl: imageUrl,
          weight: weight,
          height: height,
          types: types,
          abilities: abilities));
    }
    return pokemon;
  } catch (e) {
    throw Exception('Error al obtener los Pokemon');
  }
}

class PokemonDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pokemon pokemon =
        ModalRoute.of(context)!.settings.arguments as Pokemon;
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Column(
        children: <Widget>[
          Image.network(pokemon.imageUrl, width: 400,
                      height: 400,
                      fit: BoxFit.cover,),
          SizedBox(height: 16),
          Text("Altura: ${pokemon.height}m"),
          SizedBox(height: 16),
          Text("Peso: ${pokemon.weight}kg"),
          SizedBox(height: 16),
          Text("Tipos: ${pokemon.types.join(', ')}"),
          SizedBox(height: 16),
          Text("Habilidades: ${pokemon.abilities.join(', ')}"),
        ],
      ),
    );
  }
}
