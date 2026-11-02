import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../theme/arena_assets.dart';
import 'clase_personaje.dart';

/// Contenido completo de assets/data/personajes.json.
class Catalogo {
  final int version;
  final int maxPuntosBarra; // valor máximo de las barras de stats (12)
  final int armasPorPersonaje; // armas que se pueden elegir (2)
  final List<ClasePersonaje> clases;

  const Catalogo({
    required this.version,
    required this.maxPuntosBarra,
    required this.armasPorPersonaje,
    required this.clases,
  });

  factory Catalogo.fromJson(Map<String, dynamic> json) => Catalogo(
        version: json['version'] as int,
        maxPuntosBarra: json['maxPuntosBarra'] as int,
        armasPorPersonaje: json['armasPorPersonaje'] as int,
        clases: (json['clases'] as List<dynamic>)
            .map((c) => ClasePersonaje.fromJson(c as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'maxPuntosBarra': maxPuntosBarra,
        'armasPorPersonaje': armasPorPersonaje,
        'clases': clases.map((c) => c.toJson()).toList(),
      };

  /// Busca una clase por id ('mago'...). Devuelve null si no existe.
  ClasePersonaje? clasePorId(String id) {
    for (final c in clases) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Lee y convierte el JSON de assets.
  static Future<Catalogo> cargar() async {
    final texto = await rootBundle.loadString(ArenaAssets.personajesJson);
    return Catalogo.fromJson(jsonDecode(texto) as Map<String, dynamic>);
  }
}
