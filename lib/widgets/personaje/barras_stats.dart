import 'package:arena_game/theme/arena_assets.dart';
import 'package:arena_game/theme/arena_theme.dart';
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
    return Column(
      children: [
        Barra(
          icono: ArenaAssets.iconoVida,
          texto: 'Vida',
          valor: stats.vida,
          maxPuntosBarra: maxPuntosBarra,
          color: ArenaColors.positivo,
        ),

        const SizedBox(height: 12),

        Barra(
          icono: ArenaAssets.iconoAtaque,
          texto: 'Ataque',
          valor: stats.ataque,
          maxPuntosBarra: maxPuntosBarra,
          color: ArenaColors.negativo,
        ),

        const SizedBox(height: 12),

        Barra(
          icono: ArenaAssets.iconoVelocidad,
          texto: 'Velocidad',
          valor: stats.velocidad,
          maxPuntosBarra: maxPuntosBarra,
          color: ArenaColors.dorado,
        ),
      ],
    );
  }
}

class Barra extends StatelessWidget {
  const Barra({
    super.key,
    required this.maxPuntosBarra,
    required this.color,
    required this.icono,
    required this.valor,
    required this.texto,
  });

  final int valor;
  final String icono;
  final int maxPuntosBarra;
  final Color color;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icono, width: 22, height: 22),

        const SizedBox(width: 8),

        SizedBox(
            width: 85,
            child: Text(
              texto,
              textAlign: TextAlign.left,
            )
        ),

        const SizedBox(width: 8),

        Expanded(
          child: LinearProgressIndicator(
            value: (valor / maxPuntosBarra).clamp(0.0, 1.0),
            minHeight: 10,
            color: color,
            backgroundColor: ArenaColors.superficieAlta,
          ),
        ),

        SizedBox(
          width: 24,
          child: Text(
            '$valor',
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
