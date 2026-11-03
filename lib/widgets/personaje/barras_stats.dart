import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../pieza_pendiente.dart';

/// PIEZA G · Tres barras de stats (vida, ataque, velocidad).
///
/// Cada fila: icono (`ArenaAssets.iconoVida/iconoAtaque/iconoVelocidad`) +
/// `LinearProgressIndicator` + número.
///  - Valor de la barra = stat / `maxPuntosBarra` (12). Usa `.clamp(0.0, 1.0)`:
///    con bonus negativos el valor podría salir del rango.
///  - Color de la barra = `color`; fondo `ArenaColors.superficieAlta`.
///
/// NO cambies el constructor.

class BarrasStats extends StatelessWidget {
  const BarrasStats({
    super.key,
    required this.stats,
    required this.maxPuntosBarra,
    required this.color,
  });

  final Stats stats;
  final int maxPuntosBarra;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // TODO(grupo G)
    return PiezaPendiente('BarrasStats · ${stats}', alto: 120);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Icon(ArenaAssets.iconoVida),
          Text('Vida'),
          Expanded(
            child: LinearProgressIndicator(
            value: (stats.vida / maxPuntosBarra).clamp(0.0, 1.0),
            color: ArenaColors.positivo,
            backgroundColor: ArenaColors.superficieAlta,
          ),
          Text('${stats.vida}'),
        ],
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
          Icon(ArenaAssets.iconoAtaque),
      Text('Ataque'),
      Expanded(
        child: LinearProgressIndicator(
          value: (stats.ataque / maxPuntosBarra).clamp(0.0, 1.0),
          color: ArenaColors.negativo,
          backgroundColor: ArenaColors.superficieAlta,
        ),
        Text('${stats.ataque}'),
        ],
      ),Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
        Icon(ArenaAssets.iconoVelocidad),
      Text('Velocidad'),
      Expanded(
        child: LinearProgressIndicator(
          value: (stats.velocidad / maxPuntosBarra).clamp(0.0, 1.0),
          color: ArenaColors.dorado,
          backgroundColor: ArenaColors.superficieAlta,
        ),
        Text('${stats.velocidad}'),
        ],
      ),
    );
  }
}
