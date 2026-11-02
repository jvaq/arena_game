/// Tres números que usa todo el juego: vida, ataque y velocidad.
/// Sirve para: `base` y `bonus` de personajes.json, `reparto` y
/// `estadisticas` de la API.
class Stats {
  final int vida;
  final int ataque;
  final int velocidad;

  const Stats({this.vida = 0, this.ataque = 0, this.velocidad = 0});

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        vida: (json['vida'] as num?)?.toInt() ?? 0,
        ataque: (json['ataque'] as num?)?.toInt() ?? 0,
        velocidad: (json['velocidad'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {'vida': vida, 'ataque': ataque, 'velocidad': velocidad};

  /// Suma dos conjuntos de stats (base + bonus de las armas).
  Stats operator +(Stats otro) => Stats(
        vida: vida + otro.vida,
        ataque: ataque + otro.ataque,
        velocidad: velocidad + otro.velocidad,
      );

  @override
  String toString() => 'Stats(vida: $vida, ataque: $ataque, velocidad: $velocidad)';
}
