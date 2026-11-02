import 'jugador.dart';

/// Una ronda de la lista `rondas` de POST /jugadores/{id}/combate.
class Ronda {
  final int ronda;
  final String atacante;
  final String defensor;
  final int danio;
  final bool critico;
  final int vidaDefensor;

  const Ronda({
    required this.ronda,
    required this.atacante,
    required this.defensor,
    required this.danio,
    required this.critico,
    required this.vidaDefensor,
  });

  factory Ronda.fromJson(Map<String, dynamic> json) => Ronda(
        ronda: json['ronda'] as int,
        atacante: json['atacante'] as String,
        defensor: json['defensor'] as String,
        danio: json['danio'] as int,
        critico: json['critico'] as bool? ?? false,
        vidaDefensor: json['vidaDefensor'] as int,
      );

  Map<String, dynamic> toJson() => {
        'ronda': ronda,
        'atacante': atacante,
        'defensor': defensor,
        'danio': danio,
        'critico': critico,
        'vidaDefensor': vidaDefensor,
      };
}

/// Cuerpo de la petición de combate: enemigo O rivalId (uno de los dos).
class PeticionCombate {
  final String? enemigo; // 'orco', 'troll' o 'dragon'
  final int? rivalId;

  const PeticionCombate.contraEnemigo(String this.enemigo) : rivalId = null;
  const PeticionCombate.contraJugador(int this.rivalId) : enemigo = null;

  Map<String, dynamic> toJson() =>
      enemigo != null ? {'enemigo': enemigo} : {'rivalId': rivalId};
}

/// Respuesta de POST /jugadores/{id}/combate.
/// El servidor decide quién gana: la app solo muestra `rondas`.
class ResultadoCombate {
  final String resultado; // 'victoria' o 'derrota'
  final String ganador;
  final int puntosGanados;
  final int puntosTotales;
  final Estadisticas rival;
  final List<Ronda> rondas;

  const ResultadoCombate({
    required this.resultado,
    required this.ganador,
    required this.puntosGanados,
    required this.puntosTotales,
    required this.rival,
    required this.rondas,
  });

  bool get esVictoria => resultado == 'victoria';

  factory ResultadoCombate.fromJson(Map<String, dynamic> json) =>
      ResultadoCombate(
        resultado: json['resultado'] as String,
        ganador: json['ganador'] as String,
        puntosGanados: json['puntosGanados'] as int,
        puntosTotales: json['puntosTotales'] as int,
        rival: Estadisticas.fromJson(json['rival'] as Map<String, dynamic>),
        rondas: (json['rondas'] as List<dynamic>)
            .map((r) => Ronda.fromJson(r as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'resultado': resultado,
        'ganador': ganador,
        'puntosGanados': puntosGanados,
        'puntosTotales': puntosTotales,
        'rival': rival.toJson(),
        'rondas': rondas.map((r) => r.toJson()).toList(),
      };
}
