import 'package:arena_game/screens/menu_pruebas.dart';
import 'package:arena_game/theme/arena_theme.dart';
import 'package:flutter/material.dart';

import 'app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arena',
      debugShowCheckedModeBanner: false,
      theme: ArenaTheme.oscuro(),
      initialRoute: Routes.registro,
      routes: Routes.mapa,
    );
  }
}

