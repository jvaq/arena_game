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

    return Column(children: [
      BarraStats(
        tipo:"vida",
        valor: stats.vida,
        maxPuntosBarra: maxPuntosBarra,
      ),
      const SizedBox(height: 12),
      BarraStats(
        tipo: "ataque",
        valor: stats.ataque,
        maxPuntosBarra: maxPuntosBarra,


      ),
      const SizedBox(height: 12),
      BarraStats(
        tipo: "velocidad",
        valor: stats.velocidad,
        maxPuntosBarra: maxPuntosBarra,
      )
    ],);
  }
}
class BarraStats extends StatelessWidget {
  const BarraStats({super.key,
    required this.maxPuntosBarra,
    required this.tipo,
    required this.valor,
  });

  final int valor;
  final String tipo;
  final int maxPuntosBarra;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 24, height: 24, child: imagenStats(tipo: tipo)),
        const SizedBox(width: 12),
        Container(
            width: 80,
            child: Text(tipo)),
        if(tipo == "vida")
          Expanded(
            child: LinearProgressIndicator(
              value: (valor / maxPuntosBarra).clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: ArenaColors.superficieAlta,
              color: ArenaColors.positivo
            ),
          ),
        if(tipo == "ataque")
          Expanded(
            child: LinearProgressIndicator(
                value: (valor / maxPuntosBarra).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: ArenaColors.superficieAlta,
                color: ArenaColors.negativo
            ),
          ),
        if(tipo == "velocidad")
          Expanded(
            child: LinearProgressIndicator(
                value: (valor / maxPuntosBarra).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: ArenaColors.superficieAlta,
                color: Colors.amber,
            ),
          ),
        const SizedBox(width: 12),
        Text(
          '$valor',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class imagenStats extends StatelessWidget {
  const imagenStats({super.key, required this.tipo});
  final String tipo;
  @override
  Widget build(BuildContext context) {
    if (tipo == "vida"){
      return Image.asset( ArenaAssets.iconoVida);
    }else if (tipo == "ataque"){
      return Image.asset( ArenaAssets.iconoAtaque);
    }else {
    }return Image.asset( ArenaAssets.iconoVelocidad);
  }
}
