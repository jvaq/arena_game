import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../models/stats.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ArenaAssets.iconoVida,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 88,
              child: Text(
                'Vida',
                style: ArenaTextos.etiqueta.copyWith(fontSize: 16),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (stats.vida / maxPuntosBarra).clamp(0.0, 1.0),
                    minHeight: 12,
                    color: ArenaColors.positivo,
                    backgroundColor: ArenaColors.superficieAlta,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Text(
              '${stats.vida}',
              style: ArenaTextos.puntos.copyWith(color: ArenaColors.texto),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ArenaAssets.iconoAtaque,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 88,
              child: Text(
                'Ataque',
                style: ArenaTextos.etiqueta.copyWith(fontSize: 16),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (stats.ataque / maxPuntosBarra).clamp(0.0, 1.0),
                    minHeight: 12,
                    color: ArenaColors.negativo,
                    backgroundColor: ArenaColors.superficieAlta,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Text(
              '${stats.ataque}',
              style: ArenaTextos.puntos.copyWith(color: ArenaColors.texto),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ArenaAssets.iconoVelocidad,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 88,
              child: Text(
                'Velocidad',
                style: ArenaTextos.etiqueta.copyWith(fontSize: 16),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (stats.velocidad / maxPuntosBarra).clamp(0.0, 1.0),
                    minHeight: 12,
                    color: ArenaColors.dorado,
                    backgroundColor: ArenaColors.superficieAlta,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Text(
              '${stats.velocidad}',
              style: ArenaTextos.puntos.copyWith(color: ArenaColors.texto),
            ),
          ],
        ),
      ],
    );
  }
}
