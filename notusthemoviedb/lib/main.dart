import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notusthemoviedb/simple_bloc_observer.dart';

import 'app.dart';
import 'dependency_injection.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  runApp(const App());
}
