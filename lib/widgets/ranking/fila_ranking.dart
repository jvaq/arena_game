import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';

/// PIEZA A · Fila del ranking.
class FilaRanking extends StatelessWidget {
  const FilaRanking({super.key, required this.entrada, this.resaltada = false});

  final EntradaRanking entrada;
  final bool resaltada;

  @override
  Widget build(BuildContext context) {
    final pos = entrada.posicion;
    final esTop3 = pos >= 1 && pos <= 3;
    final String? rutaMedalla = esTop3 ? ArenaAssets.medalla(pos) : null;
    final clase = claseVisual(entrada.clase);
    final colorClase = ArenaColors.deClase(clase);

    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: resaltada ? ArenaColors.superficieAlta : ArenaColors.superficie,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(
          color: pos == 1 ? ArenaColors.dorado : ArenaColors.borde,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: rutaMedalla != null
                  ? Image.asset(
                rutaMedalla,
                width: 24,
                height: 24,
                errorBuilder: (_, __, _) => Text('$pos'),
              )
                  : Text('$pos', style: ArenaTextos.cuerpo),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorClase, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                ArenaAssets.avatar(clase),
                fit: BoxFit.cover,
                errorBuilder: (_, __, _) => const Icon(Icons.person, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entrada.nick,
                  style: ArenaTextos.cuerpo,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  entrada.victoriasDerrotas,
                  style: ArenaTextos.etiqueta,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('${entrada.puntos}', style: ArenaTextos.puntos),
        ],
      ),
    );
  }
}