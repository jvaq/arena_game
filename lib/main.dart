import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'theme/arena_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Arena',
    debugShowCheckedModeBanner: false,
    theme: ArenaTheme.oscuro(),
    initialRoute: Routes.splash,
    routes: Routes.mapa,
  );
}
