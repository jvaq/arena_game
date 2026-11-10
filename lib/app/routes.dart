import 'package:flutter/material.dart';

import '../screens/pantalla_inicio.dart';
import '../screens/pantalla_personaje.dart';
import '../screens/pantalla_proximamente.dart';
import '../screens/pantalla_ranking.dart';
import '../screens/pantalla_registro_jugador.dart';
import '../screens/pantalla_splash.dart';

/// Nombres de las rutas de la app. Se usan así:
///
///   Navigator.pushNamed(context, Rutas.ranking);
///   Navigator.pushReplacementNamed(context, Rutas.inicio);   // sin poder volver
///
/// Lo mantiene el profesor; cada pantalla nueva se añade aquí.
class Routes {
  Routes._();

  static const splash = '/';
  static const registro = '/registro';
  static const inicio = '/inicio';
  static const personaje = '/personaje';
  static const ranking = '/ranking';
  static const rival = '/rival';
  static const historial = '/historial';
  static const ajustes = '/ajustes';

  static Map<String, WidgetBuilder> get mapa => {
    splash: (_) => const PantallaSplash(),
    registro: (_) => const PantallaRegistroJugador(),
    inicio: (_) => const PantallaInicio(),
    personaje: (_) => const PantallaPersonaje(),
    ranking: (_) => const PantallaRanking(),
    rival: (_) => const PantallaProximamente(titulo: 'Elegir rival'),
    historial: (_) => const PantallaProximamente(titulo: 'Historial'),
    ajustes: (_) => const PantallaProximamente(titulo: 'Ajustes del servidor'),
  };
}
