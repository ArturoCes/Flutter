import 'dart:convert';

import 'package:flutter/material.dart';
import 'register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/auth/login': (context) => LoginPage(),
        '/auth/register': (context) => RegisterForm(),
      },
      title: 'My Login Form',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  get _password => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "Iniciar Sesión",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo Usuario no puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo Contraseña no puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            Container(
  margin: EdgeInsets.only(bottom: 20),
  child: TextButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // Aquí debes enviar los datos a la API
          // Ejemplo usando http:
          var _username;
          var http;
          final response = await http.post(Uri.parse(
            'https://localhost:8080/auth/login'),
            body: {
              'username': _username,
              'password': _password,
            },
          );
          final data = json.decode(response.body);
          if (data['success']) {
            // Mostrar mensaje de éxito
          } else {
            // Mostrar mensaje de error
          }
        } catch (e) {
          // Mostrar mensaje de error
        }
      }
    },
    child: Text("Iniciar Sesión"),
  ),
),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth/register');
                },
                child: Text("Registrarse"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
