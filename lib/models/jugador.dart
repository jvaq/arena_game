import 'stats.dart';

/// Respuesta de POST /jugadores (registro). Guarda el token.
class JugadorRegistrado {
  final int id;
  final String nick;
  final String token;

  const JugadorRegistrado(
      {required this.id, required this.nick, required this.token});

  factory JugadorRegistrado.fromJson(Map<String, dynamic> json) =>
      JugadorRegistrado(
        id: json['id'] as int,
        nick: json['nick'] as String,
        token: json['token'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'nick': nick, 'token': token};
}

/// Cuerpo de PUT /jugadores/{id}/personaje (lo que TÚ envías).
/// Ojo: vida + ataque + velocidad deben sumar exactamente 10.
class ConfigPersonaje {
  final String clase; // 'guerrero', 'mago' o 'arquero'
  final String color; // '#RRGGBB'
  final Stats reparto;

  const ConfigPersonaje(
      {required this.clase, required this.color, required this.reparto});

  bool get repartoValido =>
      reparto.vida + reparto.ataque + reparto.velocidad == 10;

  Map<String, dynamic> toJson() => {
        'clase': clase,
        'color': color,
        'vida': reparto.vida,
        'ataque': reparto.ataque,
        'velocidad': reparto.velocidad,
      };
}

/// Estadísticas calculadas por el servidor (vida 80, ataque 18...).
class Estadisticas {
  final String nombre;
  final String clase;
  final int vida;
  final int ataque;
  final int velocidad;

  const Estadisticas({
    required this.nombre,
    required this.clase,
    required this.vida,
    required this.ataque,
    required this.velocidad,
  });

  factory Estadisticas.fromJson(Map<String, dynamic> json) => Estadisticas(
        nombre: json['nombre'] as String,
        clase: json['clase'] as String,
        vida: json['vida'] as int,
        ataque: json['ataque'] as int,
        velocidad: json['velocidad'] as int,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'clase': clase,
        'vida': vida,
        'ataque': ataque,
        'velocidad': velocidad,
      };
}

/// Respuesta de GET /jugadores/{id} y de PUT /jugadores/{id}/personaje.
/// Si el jugador aún no configuró personaje, clase/color/reparto/estadisticas
/// llegan vacíos (null).
class Jugador {
  final int id;
  final String nick;
  final bool configurado;
  final String? clase;
  final String? color;
  final Stats? reparto;
  final Estadisticas? estadisticas;
  final int puntos;
  final int victorias;
  final int derrotas;

  const Jugador({
    required this.id,
    required this.nick,
    required this.configurado,
    this.clase,
    this.color,
    this.reparto,
    this.estadisticas,
    this.puntos = 0,
    this.victorias = 0,
    this.derrotas = 0,
  });

  factory Jugador.fromJson(Map<String, dynamic> json) => Jugador(
        id: json['id'] as int,
        nick: json['nick'] as String,
        configurado: json['configurado'] as bool? ?? false,
        clase: json['clase'] as String?,
        color: json['color'] as String?,
        reparto: json['reparto'] == null
            ? null
            : Stats.fromJson(json['reparto'] as Map<String, dynamic>),
        estadisticas: json['estadisticas'] == null
            ? null
            : Estadisticas.fromJson(
                json['estadisticas'] as Map<String, dynamic>),
        puntos: json['puntos'] as int? ?? 0,
        victorias: json['victorias'] as int? ?? 0,
        derrotas: json['derrotas'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nick': nick,
        'configurado': configurado,
        'clase': clase,
        'color': color,
        'reparto': reparto?.toJson(),
        'estadisticas': estadisticas?.toJson(),
        'puntos': puntos,
        'victorias': victorias,
        'derrotas': derrotas,
      };
}
