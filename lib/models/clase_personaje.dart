import 'dart:ui' show Color;

import 'arma.dart';
import 'stats.dart';

/// Una clase de personaje de personajes.json (caballero, orco o mago).
class ClasePersonaje {
  final String id;
  final String nombre;
  final String lema;
  final Color color;
  final String imagen; // personaje grande
  final String avatar; // círculo del ranking
  final Stats base;
  final List<Arma> armas;

  const ClasePersonaje({
    required this.id,
    required this.nombre,
    required this.lema,
    required this.color,
    required this.imagen,
    required this.avatar,
    required this.base,
    required this.armas,
  });

  factory ClasePersonaje.fromJson(Map<String, dynamic> json) => ClasePersonaje(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        lema: json['lema'] as String? ?? '',
        color: colorDeHex(json['color'] as String),
        imagen: json['imagen'] as String,
        avatar: json['avatar'] as String,
        base: Stats.fromJson(json['base'] as Map<String, dynamic>),
        armas: (json['armas'] as List<dynamic>)
            .map((a) => Arma.fromJson(a as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'lema': lema,
        'color': colorAHex(color),
        'imagen': imagen,
        'avatar': avatar,
        'base': base.toJson(),
        'armas': armas.map((a) => a.toJson()).toList(),
      };

  /// Stats finales = base + bonus de las armas elegidas.
  Stats statsCon(List<Arma> elegidas) =>
      elegidas.fold(base, (total, arma) => total + arma.bonus);
}

/// '#4C8FD6' -> Color(0xFF4C8FD6)
Color colorDeHex(String hex) =>
    Color(int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000);

/// Color(0xFF4C8FD6) -> '#4C8FD6'  (formato #RRGGBB que pide la API)
String colorAHex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
