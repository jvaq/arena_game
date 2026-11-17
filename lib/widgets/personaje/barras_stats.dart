import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
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
        _FilaStat(
          icono: ArenaAssets.iconoVida,
          etiqueta: 'Vida',
          valor: stats.vida,
          maxPuntos: maxPuntosBarra,
          color: const Color(0xFF4ADE80),
        ),
        const SizedBox(height: 12),
        _FilaStat(
          icono: ArenaAssets.iconoAtaque,
          etiqueta: 'Ataque',
          valor: stats.ataque,
          maxPuntos: maxPuntosBarra,
          color: const Color(0xFFEF4444),
        ),
        const SizedBox(height: 12),
        _FilaStat(
          icono: ArenaAssets.iconoVelocidad,
          etiqueta: 'Velocidad',
          valor: stats.velocidad,
          maxPuntos: maxPuntosBarra,
          color: const Color(0xFFFACC15),
        ),
      ],
    );
  }
}

class _FilaStat extends StatelessWidget {
  const _FilaStat({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.maxPuntos,
    required this.color,
  });

  final String icono;
  final String etiqueta;
  final int valor;
  final int maxPuntos;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double progreso = (valor / maxPuntos).clamp(0.0, 1.0);

    return Row(
      children: [
        Image.asset(icono, width: 24, height: 24),
        const SizedBox(width: 12),

        SizedBox(
          width: 80,
          child: Text(etiqueta, style: ArenaTextos.cuerpoSuave),
        ),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 12,
              color: color,
              backgroundColor: ArenaColors.superficieAlta,
            ),
          ),
        ),
        const SizedBox(width: 16),

        SizedBox(
          width: 24,
          child: Text(
            valor.toString(),
            textAlign: TextAlign.right,
            style: ArenaTextos.cuerpo.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}