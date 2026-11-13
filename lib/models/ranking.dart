import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../theme/arena_assets.dart';

/// Una fila del ranking (sirve para assets/data/ranking_ejemplo.json
/// y para cada elemento de GET /ranking).
class EntradaRanking {
  final int posicion;
  final int id;
  final String nick;
  final String clase;
  final String? color; // la API lo envía; el JSON de ejemplo no
  final int puntos;
  final int victorias;
  final int derrotas;

  const EntradaRanking({
    required this.posicion,
    required this.id,
    required this.nick,
    required this.clase,
    this.color,
    required this.puntos,
    required this.victorias,
    required this.derrotas,
  });

  factory EntradaRanking.fromJson(Map<String, dynamic> json) => EntradaRanking(
        posicion: json['posicion'] as int,
        id: json['id'] as int,
        nick: json['nick'] as String,
        clase: json['clase'] as String,
        color: json['color'] as String?,
        puntos: json['puntos'] as int,
        victorias: json['victorias'] as int,
        derrotas: json['derrotas'] as int,
      );

  Map<String, dynamic> toJson() => {
        'posicion': posicion,
        'id': id,
        'nick': nick,
        'clase': clase,
        if (color != null) 'color': color,
        'puntos': puntos,
        'victorias': victorias,
        'derrotas': derrotas,
      };
  /// Texto "21 V · 3 D" de la segunda línea de cada fila.
  String get victoriasDerrotas => '$victorias V · $derrotas D';
}

/// Contenido de assets/data/ranking_ejemplo.json: el top y tu posición.
class RankingEjemplo {
  final List<EntradaRanking> top;
  final EntradaRanking tu;

  const RankingEjemplo({required this.top, required this.tu});

  factory RankingEjemplo.fromJson(Map<String, dynamic> json) => RankingEjemplo(
        top: (json['top'] as List<dynamic>)
            .map((e) => EntradaRanking.fromJson(e as Map<String, dynamic>))
            .toList(),
        tu: EntradaRanking.fromJson(json['tu'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() =>
      {'top': top.map((e) => e.toJson()).toList(), 'tu': tu.toJson()};

  static Future<RankingEjemplo> cargar() async {
    final texto = await rootBundle.loadString(ArenaAssets.rankingEjemploJson);
    return RankingEjemplo.fromJson(jsonDecode(texto) as Map<String, dynamic>);
  }
}
