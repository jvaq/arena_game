import 'package:flutter/material.dart';
import 'package:arena_game/theme/arena_theme.dart';

import '../../models/models.dart';

/// PIEZA H · Rejilla 2×2 con las armas de la clase.
///
/// Cada tarjeta: imagen (`arma.imagen`), nombre y bonus (por ejemplo «+3 ataque · −1 vel.»).
///  - Las armas de `elegidas` se muestran seleccionadas (borde del color de la clase).
///  - Al pulsar una: `onAlternar(arma)`. NO decides tú el máximo (lo hace la pantalla),
///    pero puedes atenuar visualmente las no elegidas cuando `elegidas.length >= maxArmas`.
///
/// NO cambies el constructor.
class RejillaArmas extends StatelessWidget {
  const RejillaArmas({
    super.key,
    required this.armas,
    required this.elegidas,
    required this.maxArmas,
    required this.colorClase,
    required this.onAlternar,
  });

  final List<Arma> armas;
  final List<Arma> elegidas;
  final int maxArmas;
  final Color colorClase;
  final ValueChanged<Arma> onAlternar;

  String _formatearAtaque(Arma arma) {
    String bonusFormateado = "";
    if (arma.bonus.vida > 0) {
      bonusFormateado = "+${arma.bonus.vida} vida";
    } else if (arma.bonus.vida < 0) {
      bonusFormateado = "${arma.bonus.vida} vida";
    }

    if (arma.bonus.ataque > 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · +${arma.bonus.ataque} atq";
      } else {
        bonusFormateado = "+${arma.bonus.ataque} atq";
      }
    } else if (arma.bonus.ataque < 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · ${arma.bonus.ataque} atq";
      } else {
        bonusFormateado = "${arma.bonus.ataque} atq";
      }
    }

    if (arma.bonus.velocidad > 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · +${arma.bonus.velocidad} vel";
      } else {
        bonusFormateado = "+${arma.bonus.velocidad} vel";
      }
    } else if (arma.bonus.velocidad < 0) {
      if (bonusFormateado.isNotEmpty) {
        bonusFormateado += " · ${arma.bonus.velocidad} vel";
      } else {
        bonusFormateado = "${arma.bonus.velocidad} vel";
      }
    }
    return bonusFormateado;
  }

  @override
  Widget build(BuildContext context) {
    final bool maxAlcanzado = elegidas.length >= maxArmas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ARMAS", style: ArenaTextos.subtitulo),
            Text(
              "${elegidas.length} / $maxArmas elegidas",
              style: ArenaTextos.cuerpoSuave.copyWith(
                color: ArenaColors.dorado,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: ArenaMedidas.s8),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var arma in armas)
              Stack(
                clipBehavior: Clip.none, // Permite que el círculo sobresalga
                children: [
                  Opacity(
                    opacity: (maxAlcanzado && !elegidas.contains(arma)) ? 0.4 : 1.0,
                    child: OutlinedButton(
                      onPressed: () => onAlternar(arma),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        backgroundColor: elegidas.contains(arma)
                            ? ArenaColors.superficieAlta
                            : ArenaColors.superficie,
                        side: BorderSide(
                          color: elegidas.contains(arma) ? ArenaColors.dorado : ArenaColors.borde,
                          width: elegidas.contains(arma)
                              ? ArenaMedidas.grosorBordeSeleccion
                              : ArenaMedidas.grosorBorde,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ArenaMedidas.radioTarjeta,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: Image.asset(arma.imagen, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  arma.nombre,
                                  style: ArenaTextos.cuerpo.copyWith(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _formatearAtaque(arma),
                                  style: ArenaTextos.cuerpoSuave.copyWith(
                                    fontSize: 11,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (elegidas.contains(arma))
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ArenaColors.dorado,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 18,
                          color: ArenaColors.textoSobreDorado,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
