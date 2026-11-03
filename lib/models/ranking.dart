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


class RankingEjemplo {
  final List<EntradaRanking> top;
  final EntradaRanking tu;

  const RankingEjemplo({required this.top, required this.tu});

  // Constructor de ejemplo con 10 personajes en Dart puro
  factory RankingEjemplo.ejemplo() {
    final List<EntradaRanking> listaTop = [
      const EntradaRanking(posicion: 1, id: 101, nick: 'ShadowMage', clase: 'Mago', puntos: 1500, victorias: 45, derrotas: 5),
      const EntradaRanking(posicion: 2, id: 102, nick: 'IronBlade', clase: 'Caballero', puntos: 1420, victorias: 40, derrotas: 10),
      const EntradaRanking(posicion: 3, id: 103, nick: 'SwiftArrow', clase: 'Mago', puntos: 1380, victorias: 38, derrotas: 12),
      const EntradaRanking(posicion: 4, id: 104, nick: 'HolyHealer', clase: 'Orco', puntos: 1300, victorias: 35, derrotas: 15),
      const EntradaRanking(posicion: 5, id: 105, nick: 'DarkRogue', clase: 'Caballero', puntos: 1250, victorias: 30, derrotas: 20),
      const EntradaRanking(posicion: 6, id: 106, nick: 'FlameStorm', clase: 'Mago', puntos: 1190, victorias: 28, derrotas: 22),
      const EntradaRanking(posicion: 7, id: 107, nick: 'ShieldMaster', clase: 'Caballero', color: '#4CAF50', puntos: 1150, victorias: 25, derrotas: 25),
      const EntradaRanking(posicion: 8, id: 108, nick: 'WindRunner', clase: 'Mago', puntos: 1100, victorias: 22, derrotas: 28),
      const EntradaRanking(posicion: 9, id: 109, nick: 'TanksAot', clase: 'Orco', puntos: 1050, victorias: 20, derrotas: 30),
      const EntradaRanking(posicion: 10, id: 110, nick: 'NovatoStark', clase: 'Mago', puntos: 980, victorias: 15, derrotas: 35),
    ];

    return RankingEjemplo(
      top: listaTop,
      tu: listaTop.last, // 'Tú' eres el último de la lista (NovatoStark)
    );
  }
}

/// Contenido de assets/data/ranking_ejemplo.json: el top y tu posición.
// class RankingEjemplo {
//   final List<EntradaRanking> top;
//   final EntradaRanking tu;
//
//   const RankingEjemplo({required this.top, required this.tu});
//
//   factory RankingEjemplo.fromJson(Map<String, dynamic> json) => RankingEjemplo(
//         top: (json['top'] as List<dynamic>)
//             .map((e) => EntradaRanking.fromJson(e as Map<String, dynamic>))
//             .toList(),
//         tu: EntradaRanking.fromJson(json['tu'] as Map<String, dynamic>),
//       );
//
//   Map<String, dynamic> toJson() =>
//       {'top': top.map((e) => e.toJson()).toList(), 'tu': tu.toJson()};
//
//   static Future<RankingEjemplo> cargar() async {
//     final texto = await rootBundle.loadString(ArenaAssets.rankingEjemploJson);
//     return RankingEjemplo.fromJson(jsonDecode(texto) as Map<String, dynamic>);
//   }
// }
