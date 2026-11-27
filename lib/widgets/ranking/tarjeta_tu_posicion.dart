import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/arena_assets.dart';
import '../../theme/arena_theme.dart';
import '../../utils/clase_visual.dart';

/// PIEZA B · Tarjeta fija «Tu posición» (va abajo del todo en la pantalla).
class TarjetaTuPosicion extends StatelessWidget {
  const TarjetaTuPosicion({super.key, required this.entrada});

  final EntradaRanking entrada;

  @override
  Widget build(BuildContext context) {
    final clase = claseVisual(entrada.clase);
    final colorClase = ArenaColors.deClase(clase);

    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ArenaColors.superficieAlta,
        borderRadius: BorderRadius.circular(ArenaMedidas.radioTarjeta),
        border: Border.all(
          color: ArenaColors.dorado,
          width: ArenaMedidas.grosorBordeSeleccion,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('TU POSICIÓN', style: ArenaTextos.etiqueta),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${entrada.posicion}', style: ArenaTextos.subtitulo),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorClase, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    ArenaAssets.avatar(clase),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, _) => const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entrada.nick,
                            style: ArenaTextos.cuerpo,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ArenaColors.dorado,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'TÚ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ArenaColors.textoSobreDorado,
                            ),
                          ),
                        ),
                      ],
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
        ],
      ),
    );
  }
}
